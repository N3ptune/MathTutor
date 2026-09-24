from app.services.ai_service import send_ai_request, parse_ai_section_structure
from app.services.supabase_service import get_section_name, push_section_problems_to_supabase

async def generate_problem_for_section(
    course_id: int, section_id: int, access_token: str,
    source: str = "course", created_by: int | None = None,
) -> dict:
    section_name = await get_section_name(section_id, access_token)

    prompt = f"""
You are a math professor generating a single problem for the section titled "{section_name}".
The problem must directly test the topic of that section and nothing else.
Write every mathematical expression in LaTeX wrapped in $...$ (for example $x^2 + \\\\frac{{1}}{{2}}$). Because your reply is JSON, escape every backslash as a double backslash.
Return only JSON in this format:
{{
  "section": {{
    "title": "{section_name}",
    "problems": [
      {{"description": "...", "problem": "..."}}
    ]
  }}
}}
"""

    messages = [{"role": "user", "content": prompt}]
    raw_response = await send_ai_request(messages)
    section_data = parse_ai_section_structure(raw_response)

    # Push to Supabase and return the inserted row (has the real problemId)
    inserted = await push_section_problems_to_supabase(
        course_id, section_id, section_data, access_token, source=source, created_by=created_by
    )

    return inserted[0]
