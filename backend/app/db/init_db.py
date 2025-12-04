import os
from pathlib import Path
from supabase import create_client, Client
from dotenv import load_dotenv

# Load .env from base directory
dotenv_path = Path(__file__).resolve().parents[3] / ".env"
load_dotenv(dotenv_path)

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("SUPABASE_URL or SUPABASE_KEY missing in .env")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Paths to SQL files
BASE_DIR = Path(__file__).resolve().parents[3]
SCHEMA_FILE = BASE_DIR / "database" / "schema.sql"
SEED_FILE = BASE_DIR / "database" / "seed_data.sql"

def run_sql_file(file_path: Path):
    with open(file_path, "r") as f:
        sql = f.read()
    # Supabase client doesn't support multi-statement execution directly, split by semicolon
    statements = [stmt.strip() for stmt in sql.split(";") if stmt.strip()]
    for stmt in statements:
        try:
            supabase.rpc("execute_sql", {"query": stmt}).execute()  # You need to set up a RPC to run raw SQL
        except Exception as e:
            print(f"Failed to execute statement:\n{stmt}\nError: {e}")

def init_db():
    print("Running schema.sql...")
    run_sql_file(SCHEMA_FILE)
    print("Running seed_data.sql...")
    run_sql_file(SEED_FILE)
    print("Database initialized!")

if __name__ == "__main__":
    init_db()






# THIS IS FOR SQLALCHEMY IF I EVER USE THE PAID PLAN FOR IPV4


# from backend.app.db.session import Base, engine, SessionLocal

# # Import all models here so SQLAlchemy sees them
# from backend.app.models.user import User
# from backend.app.models.problem import Problem
# from backend.app.models.section import Section
# from backend.app.models.course import Course
# # Add additional models if you have them
# # from app.models.review_guide import ReviewGuide
# # from app.models.proficiency import Proficiency
# # from app.models.user_submission import UserSubmission
# # from app.models.ai_eval import AiEval

# def init_db():
#     print("Creating tables...")
#     Base.metadata.create_all(bind=engine)
#     print("Tables created.")

#     # Seed initial data
#     with SessionLocal() as session:
#         # Sample user
#         if not session.query(User).first():
#             sample_user = User(firstName="John", lastName="Doe", email="john@example.com")
#             session.add(sample_user)
#             session.commit()
#             print("Added sample user")

#         # Sample class/course
#         if not session.query(Course).first():
#             sample_class = Course(name="Algebra 1", personId=1)  # Make sure userId exists
#             session.add(sample_class)
#             session.commit()
#             print("Added sample class")

#         # Sample section
#         if not session.query(Section).first():
#             sample_section = Section(name="Linear Equations", classId=1)  # Make sure classId exists
#             session.add(sample_section)
#             session.commit()
#             print("Added sample section")

#     print("Database initialized successfully.")

# if __name__ == "__main__":
#     init_db()
