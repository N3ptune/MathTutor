from app.config import SUPABASE_URL, SUPABASE_ANON_KEY
import httpx

# Queries supabase to find the problem text
# This definitely seems like something that would be easier to just send from front end
# Although I guess backend will eventually handle all supabase communication
# If this lasts long enough to pay for IPv4 tier
async def get_problem_text(problem_id: int) -> str:
    url = f"{SUPABASE_URL}/rest/v1/problem?problemId=eq.{problem_id}&select=problem"

    headers = {
        "apikey": SUPABASE_ANON_KEY,
        "Authorization": f"Bearer {SUPABASE_ANON_KEY}"
    }

    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=headers)

    if resp.status_code != 200:
        raise Exception(f"Supabase error: {resp.text}")
    
    data = resp.json()
    if not data:
        raise Exception("Problem not found")
    
    return data[0]["problem"]

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

