from app.config import SUPABASE_URL, SUPABASE_ANON_KEY
import httpx

# Requests to Supabase carry the signed-in user's token, so row-level security applies to them
def _user_headers(access_token: str) -> dict:
    return {
        "apikey": SUPABASE_ANON_KEY,
        "Authorization": f"Bearer {access_token}",
    }

# Queries supabase to find the problem text
# This definitely seems like something that would be easier to just send from front end
# Although I guess backend will eventually handle all supabase communication
# If this lasts long enough to pay for IPv4 tier
async def get_problem_text(problem_id: int, access_token: str) -> str:
    url = f"{SUPABASE_URL}/rest/v1/problem?problemId=eq.{problem_id}&select=problem"

    headers = _user_headers(access_token)

    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=headers)

    if resp.status_code != 200:
        raise Exception(f"Supabase error: {resp.text}")
    
    data = resp.json()
    if not data:
        raise Exception("Problem not found")
    
    return data[0]["problem"]

async def get_section_name(section_id: int, access_token: str) -> str:
    url = f"{SUPABASE_URL}/rest/v1/section?sectionId=eq.{section_id}&select=name"

    headers = _user_headers(access_token)

    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=headers)

    if resp.status_code != 200:
        raise Exception(f"Supabase error: {resp.text}")

    data = resp.json()
    if not data:
        raise Exception("Section not found")

    return data[0]["name"]

async def push_course_to_supabase(course_data: dict):
    url = f"{SUPABASE_URL}/rest/v1/courses"

    headers = {
        "apikey": SUPABASE_ANON_KEY,
        "Authorization": f"Bearer  {SUPABASE_ANON_KEY}",
        "Content-Type": "application/json"
    }

    course_title = course_data["title"]
    
    async with httpx.AsyncClient() as client:
        course_resp = await client.post(url, headers=headers, json={"title": course_title})
        course_resp.raise_for_status()
        course_id = course_resp.json()[0]["id"]

        for section in course_data["sections"]:
            section_title = section["title"]
            section_resp = await client.post(f"{url}/sections", headers=headers, json={"title": section_title, "course_id": course_id})
            section_resp.raise_for_status()
            section_id = section_resp.json()[0]["id"]

            for problem in section["problems"]:
                problem_data = {
                    "description": problem["description"],
                    "problem": problem["problem"],
                    "section_id": section_id
                }
                problem_resp = await client.post(f"{url}/problems", headers=headers, json=problem_data)
                problem_resp.raise_for_status()

async def push_section_problems_to_supabase(
    course_id: int, section_id: int, section_data: dict, access_token: str,
    source: str = "course", created_by: int | None = None,
) -> list[dict]:
    url = f"{SUPABASE_URL}/rest/v1/problem"

    headers = {**_user_headers(access_token), "Content-Type": "application/json", "Prefer": "return=representation"}

    inserted = []
    async with httpx.AsyncClient() as client:
        for problem in section_data["problems"]:
            problem_payload = {
                "problem": problem["problem"],
                "sectionId": section_id,
                "source": source,
                "createdBy": created_by,
            }
            resp = await client.post(url, headers=headers, json=problem_payload)
            resp.raise_for_status()
            inserted.append(resp.json()[0])

    return inserted
