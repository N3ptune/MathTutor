from app.services.supabase_service import get_problem_text
from app.services.ai_service import send_ai_request, parse_ai_feedback

# Takes in the problemId from supabase, and the steps submitted from the front end
# First snages the problem text from the database. Maybe this could be better implemented in the future by sending that as part
# of the frontend data package
# Then it generates the prompt that it makes from the steps package
# Then it takes the response grabbed from the api, and turns that into feedback per step, which it returns to the frontend to be thrown up
async def evaluate_steps(problemId: int, steps: list[str]):
    problem_text = await get_problem_text(problemId)

    messages = [
        {"role": "system", "content": "You are a helpful math tutor. Evaluate each step of the student's solution. Do not add any headers like evaluation or labelling the step. Simply respond with feedback on each step, separated by newline characters"},
        {"role": "user", "content": f"Problem: {problem_text}"}
    ]

    for i, step in enumerate(steps):
        messages.append({"role": "user", "content": f"Step {i+1}: {step}"})

    raw_feedback = await send_ai_request(messages)

    feedback_per_step = parse_ai_feedback(raw_feedback)

    return feedback_per_step