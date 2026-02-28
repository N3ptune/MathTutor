import openai
import json
import os
import asyncio

openai_key = os.environ.get("OPENAI_API_KEY")

client = openai.OpenAI()

# Takes in the messages from the router
# Sends a message to ai of choice and returns the response
# returns first choice in case of split choices to ensure an option is always picked and nothing hangs
async def send_ai_request(messages: list[dict], use_vision: bool = False) -> str:
    def call_openai():
        response = client.responses.create(
            model = "gpt-5" if use_vision else "gpt-5-mini",
            input = messages
        )
        return response.output_text
    return await asyncio.to_thread(call_openai)



# Takes in the raw text resopnse from send_ai_request
# Returns a list of strings so that the steps each have their own response.
def parse_ai_feedback(raw_text: str) -> list[str]:
    data = json.loads(raw_text)
    return data["feedback"]