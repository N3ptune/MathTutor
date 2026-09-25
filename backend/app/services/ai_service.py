import openai
import json
import asyncio

from app.services.usage_service import record_model_usage

_client = None

def _get_client() -> openai.OpenAI:
    global _client
    if _client is None:
        _client = openai.OpenAI()
    return _client

# Takes in the messages from the router
# Sends a message to ai of choice and returns the response
# Hidden reasoning tokens are billed as output and are most of the cost, so tasks that don't
# need careful judgment (writing problems) run at "low" effort. Grading stays at the default.
async def send_ai_request(messages: list[dict], use_vision: bool = False, effort: str = "medium") -> str:
    model = "gpt-5" if use_vision else "gpt-5-mini"

    def call_openai():
        return _get_client().responses.create(
            model=model,
            input=messages,
            reasoning={"effort": effort},
        )

    response = await asyncio.to_thread(call_openai)
    # Reports tokens to the usage meter for billing; a no-op outside a metered request
    record_model_usage(model, getattr(response, "usage", None))
    return response.output_text



# Takes in the raw text resopnse from send_ai_request
# Returns a list of strings so that the steps each have their own response.
def parse_ai_feedback(raw_text: str) -> list[str]:
    data = json.loads(raw_text)
    return data["feedback"]

# takes in the raw text response from send_ai_request and returns a structured course format
def parse_ai_course_structure(raw_text: str) -> dict:
    data = json.loads(raw_text)
    return data["course"]

def parse_ai_section_structure(raw_text: str) -> dict:
    data = json.loads(raw_text)
    return data["section"]   