"""Account-level actions that need admin rights: exporting a user's data and deleting it."""
import httpx

from app.config import SUPABASE_URL
from app.services.billing_service import cancel_subscription_now
from app.services.supabase_service import _service_headers, _user_headers

# Everything tied to a user, read with their own token so RLS limits it to their rows
EXPORT_TABLES = {
    "enrollments": "user_course",
    "problemAttempts": "user_problem_attempt",
    "proficiency": "proficiency",
    "examAttempts": "proficiency_exam_attempt",
    "examResponses": "proficiency_exam_response",
    "gradeReports": "grade_report",
}


async def export_user_data(user_id: int, access_token: str) -> dict:
    headers = _user_headers(access_token)
    data = {}
    async with httpx.AsyncClient(timeout=30) as client:
        resp = await client.get(f"{SUPABASE_URL}/rest/v1/users?userId=eq.{user_id}&select=*", headers=headers)
        resp.raise_for_status()
        data["profile"] = (resp.json() or [None])[0]

        for key, table in EXPORT_TABLES.items():
            resp = await client.get(f"{SUPABASE_URL}/rest/v1/{table}?userId=eq.{user_id}&select=*", headers=headers)
            resp.raise_for_status()
            data[key] = resp.json()

        resp = await client.get(
            f"{SUPABASE_URL}/rest/v1/problem?createdBy=eq.{user_id}&select=*", headers=headers
        )
        resp.raise_for_status()
        data["generatedProblems"] = resp.json()

        for key, table in (("subscription", "subscription"), ("aiUsage", "ai_usage")):
            resp = await client.get(
                f"{SUPABASE_URL}/rest/v1/{table}?userId=eq.{user_id}&select=*", headers=_service_headers()
            )
            resp.raise_for_status()
            data[key] = resp.json()

    return data


async def delete_account(user_id: int, auth_uid: str) -> None:
    """Cancels billing, then removes the user's data and their sign-in. Rows keyed on userId
    cascade from `users`; the two references without a cascade are cleared first."""
    await cancel_subscription_now(user_id)

    headers = {**_service_headers(), "Content-Type": "application/json"}
    async with httpx.AsyncClient(timeout=30) as client:
        # Personal practice problems belong to the user (their attempts cascade with them)
        resp = await client.delete(f"{SUPABASE_URL}/rest/v1/problem?createdBy=eq.{user_id}", headers=headers)
        resp.raise_for_status()

        # Courses they created stay for everyone else; just drop the link to them
        resp = await client.patch(
            f"{SUPABASE_URL}/rest/v1/course?personId=eq.{user_id}", headers=headers, json={"personId": None}
        )
        resp.raise_for_status()

        resp = await client.delete(f"{SUPABASE_URL}/rest/v1/users?userId=eq.{user_id}", headers=headers)
        resp.raise_for_status()

        resp = await client.delete(f"{SUPABASE_URL}/auth/v1/admin/users/{auth_uid}", headers=headers)
        # Already gone is fine; the goal is that it doesn't exist
        if resp.status_code != 404:
            resp.raise_for_status()
