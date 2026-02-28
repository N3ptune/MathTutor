from app.services.ai_service import send_ai_request, parse_ai_course_structure

async def generate_course(topic: str):
    prompt = f"""
You are a math professor that creates comprehensive courses on various topics.
Create a course for Supabase insertion on the following topic: {topic}.
Include:
- Course title
- Sections with titles
- For each section, 3 problems (easy, medium, hard)
- For each problem, include a description of what they are solving for, and the problem itself.parse_ai_course_structure

Respond ONLY with valid JSON in this format:

{{
  "course": {{
    "title": "Course Title",
    "sections": [
      {{
        "title": "Section 1",
        "problems": [
          {{"description": "...", "problem": "..."}},
          ...
        ]
      }}
    ]
  }}
}}
"""
    
    messages = [
        {
            "role": "user",
            "content": prompt
        }
    ]

    raw_response = await send_ai_request(messages)
    course_structure = parse_ai_course_structure(raw_response)
    return course_structure
