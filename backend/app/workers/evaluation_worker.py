from app.services.supabase_service import get_problem_text
from app.services.ai_service import send_ai_request, parse_ai_feedback

import json

# Takes in the problemId from supabase, and the steps submitted from the front end
# First snages the problem text from the database. Maybe this could be better implemented in the future by sending that as part
# of the frontend data package
# Then it generates the prompt that it makes from the steps package
# Then it takes the response grabbed from the api, and turns that into feedback per step, which it returns to the frontend to be thrown up
async def evaluate_steps(problemId: int, steps: list[str], image_base64_list: list[str] | None = None):
    problem_text = await get_problem_text(problemId)

    # If it's an image
    if image_base64_list:
        prompt = f"""
You are a helpful math tutor.

A student submitted a handwritten solution image.

1. Extract the steps the student took in order, with the exact math that the user submitted.
2. Evaluate each step.
3. Do NOT give away the final answer.

Respond ONLY with valid JSON in this format:

{{
  "extracted_steps": [
    "step 1 text",
    "step 2 text"
  ],
  "feedback": [
    "feedback for step 1",
    "feedback for step 2"
  ]
}}

Do not give more evaluations than steps, and do not give feedback for steps that don't exist. If you can't extract any steps, return an empty array for extracted_steps and give general feedback on the problem-solving approach in the feedback array.

Problem:
{problem_text}
"""

        content = [
            {
                "type": "input_text",
                "text": prompt
            },
        ]

        for img_base64 in image_base64_list:
            content.append({
                "type": "input_image",
                "image_url": f"data:image/png;base64,{img_base64}"
            })

    # If it's text
    else:
        prompt = f"""
You are a helpful math tutor.
Evaluate each step.
Respond ONLY with JSON:

{{
  "feedback": [
    "feedback 1",
    "feedback 2"
  ]
}}

Problem:
{problem_text}

Steps:
{steps}
"""

        content = [
            {
                "type": "input_text",
                "text": prompt
            }
        ]

    messages = [{"role": "user", "content": content}]

    raw_response = await send_ai_request(messages)

    data = json.loads(raw_response)

    return data