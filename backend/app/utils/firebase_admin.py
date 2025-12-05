import firebase_admin
from firebase_admin import credentials, auth
import os

cred = credentials.Certificate(
    os.path.join(os.path.dirname(__file__), "serviceAccountKey.json")
)

firebase_admin.initialize_app(cred)

def verify_firebase_token(id_token: str):
    try:
        decoded = auth.verify_id_token(id_token)
        return decoded
    except Exception:
        return None