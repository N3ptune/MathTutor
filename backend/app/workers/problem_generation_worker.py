from app.services.ai_service import send_ai_request, parse_ai_section_structure
from app.services.supabase_service import get_section_name, push_section_problems_to_supabase

async def generate_problem_for_section(course_id: int, section_id: int) -> dict:
    section_name = await get_section_name(section_id)

    prompt = f"""
You are a math professor generating a single problem for the section titled "{section_name}".
The problem must directly test the topic of that section and nothing else.
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

    # Push to Supabase
    await push_section_problems_to_supabase(course_id, section_id, section_data)

    return section_data["problems"][0]
