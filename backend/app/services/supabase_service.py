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