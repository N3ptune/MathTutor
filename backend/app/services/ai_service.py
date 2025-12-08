import openai
import os

openai_key = os.environ.get("OPENAI_API_KEY")

client = openai.OpenAI()

# Takes in the messages from the router
# Sends a message to ai of choice and returns the response
# returns first choice in case of split choices to ensure an option is always picked and nothing hangs
async def send_ai_request(messages: list[dict]) -> str:
    response = client.responses.create(
        model = "gpt-5",
        input = messages
    )
    return response.output_text

# Takes in the raw text resopnse from send_ai_request
# Returns a list of strings so that the steps each have their own response.
def parse_ai_feedback(raw_text: str) -> list[str]:
    lines = raw_text.strip().split("\n")
    return [line for line in lines if line.strip()]