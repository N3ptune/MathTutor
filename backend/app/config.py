import os
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY")
# Bypasses row-level security. Only used for writes users must not be able to make
# themselves: billing state, usage metering, and deleting accounts.
SUPABASE_SERVICE_ROLE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
# Reasoning effort for grading (minimal/low/medium/high). Lower is cheaper and faster;
# run backend/evals/run_grading_eval.py before lowering it to confirm accuracy holds.
GRADING_REASONING_EFFORT = os.getenv("GRADING_REASONING_EFFORT", "medium")

# Where Stripe sends people back to after checkout / the billing portal
FRONTEND_URL = os.getenv("FRONTEND_URL", "http://localhost:5173").rstrip("/")

STRIPE_SECRET_KEY = os.getenv("STRIPE_SECRET_KEY")
STRIPE_WEBHOOK_SECRET = os.getenv("STRIPE_WEBHOOK_SECRET")
# The recurring monthly Price for the Pro plan, created in the Stripe dashboard
STRIPE_PRICE_ID = os.getenv("STRIPE_PRICE_ID")

SENTRY_DSN = os.getenv("SENTRY_DSN")
ENVIRONMENT = os.getenv("ENVIRONMENT", "local")


def is_configured(value: str | None) -> bool:
    """Terraform seeds every secret as PLACEHOLDER until someone sets the real value."""
    return bool(value) and value != "PLACEHOLDER"
