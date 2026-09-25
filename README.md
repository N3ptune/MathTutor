# MathTutor

An AI math tutor that grades your work step by step. Students type (or photograph) each step of their solution. MathTutor shows which steps are right in green and which are wrong in red, explains the mistakes without giving away the answer, and tracks proficiency for each section of a class.

**Version:** `v0.1.0` (MVP)

## Features

- **Step-by-step grading.** Each step gets its own feedback, marked correct or incorrect, plus an overall verdict for the problem.
- **Photo and PDF uploads.** Upload handwritten or typed work instead of typing it. The AI pulls out the steps and grades them.
- **Attempt history.** Every graded submission is saved. Students can reopen any past attempt on a problem to see its steps and feedback.
- **Classes and sections.** Students register for classes (Algebra 1, Calculus 2, ...). Each section has shared course problems, and students can also generate their own extra practice problems.
- **Proficiency tracking.** A section's proficiency is the share of its course problems answered correctly, capped at 95% from practice alone. Passing the section's proficiency exam raises it to 100%. A class's proficiency is the average of its sections.
- **Proficiency exams.** Five questions drawn from a bank for each section; scoring 80% or higher passes.
- **Works on phones.** The layout is responsive down to phone width. Anything that loads shows a full-screen throbber, and network failures show a clear message with a **Try again** button.

## Tech stack

| Layer | Technology |
| --- | --- |
| Frontend | React 19, Vite, Tailwind CSS 4, shadcn/ui, KaTeX, Framer Motion |
| Backend | Python 3.13, FastAPI, httpx |
| AI | OpenAI Responses API (`gpt-5-mini` for text, `gpt-5` for vision) |
| Auth and database | Supabase (Auth with email/password and Google, Postgres, row-level security) |
| Hosting | AWS: S3 + CloudFront (frontend), App Runner + ECR (backend), SSM Parameter Store (secrets) |
| Infrastructure | Terraform |
| CI/CD | GitHub Actions |
| Tests | pytest (backend), Vitest + Testing Library (frontend) |

## How it fits together

```text
Browser (React SPA on CloudFront)
  ├── Supabase directly ── sign-in, reading classes/problems/proficiency/attempts (RLS-protected)
  └── FastAPI backend (App Runner) ── anything that calls OpenAI
        ├── POST /api/evaluate/                    grade steps or an upload, save the attempt, update proficiency
        ├── POST /api/problem_generation/generate/ generate a personal practice problem
        ├── POST /api/proficiency/exam/start       sample exam questions for a section
        └── POST /api/proficiency/exam/submit      grade the exam
```

Every `/api` route needs a valid Supabase access token and is rate-limited per user (20 requests per minute). The backend talks to Supabase **as the signed-in user**, so row-level security applies to the backend's queries too.

## Repository layout

```text
backend/          FastAPI app (app/), tests (tests/), Dockerfile
frontend/         React app (src/pages, src/components, src/lib)
database/         Schema, row-level security, migrations, and seed data (run in the Supabase SQL editor)
infrastructure/   Terraform for AWS, plus deploy helper scripts
docs/             Architecture, deployment guide, API spec, cost model, plans
.github/workflows CI (lint/test/build) and deploys (backend, frontend, Terraform)
```

## Running locally

### Prerequisites

- Python 3.13+
- Node 20+
- A Supabase project and an OpenAI API key

### 1. Environment variables

```bash
cp backend/.env.example backend/.env     # SUPABASE_URL, SUPABASE_ANON_KEY, OPENAI_API_KEY, ALLOWED_ORIGINS
cp frontend/.env.example frontend/.env   # VITE_API_URL, VITE_SUPABASE_URL, VITE_SUPABASE_ANON_KEY
```

### 2. Database

Run these in the Supabase SQL editor. Everything except the seeds is safe to re-run.

1. `database/rls.sql` — row-level security policies
2. `database/migrate_proficiency.sql` — proficiency, attempts, and exam tables
3. `database/migrate_unenroll.sql` — lets students unregister from a class
4. `database/migrate_attempt_history.sql` — stores each attempt's steps and per-step feedback
5. `database/seed_courses.sql` and `database/seed_problems.sql` — classes, sections, and problems. `seed_problems.sql` is **destructive**: it replaces all problems and their attempt history.

`database/schema.sql` documents the full table layout. The live tables use quoted camelCase column names (`"userId"`), which the app relies on; see the note at the top of `rls.sql`.

After changing how proficiency is scored, run `database/recompute_proficiency.sql` to recalculate existing ratings.

### 3. Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements-dev.txt
uvicorn app.main:app --reload    # http://localhost:8000
```

### 4. Frontend

```bash
cd frontend
npm install
npm run dev                      # http://localhost:5173
```

You can also run both apps with Docker: `docker compose -f docker-compose.local.yml up`.

## Tests and checks

These are the same checks CI runs on every pull request and every push to `main` (`.github/workflows/ci.yml`):

```bash
# Backend
cd backend
flake8 app tests                 # pyflakes + syntax checks (see .flake8)
pytest -q

# Frontend
cd frontend
npm run lint
npm test
npm run build
```

## Deployment

Pushes to `main` deploy automatically:

| Change in | Workflow | What it does |
| --- | --- | --- |
| `backend/**` | `backend-deploy.yml` | Builds the Docker image, pushes it to ECR, and redeploys App Runner |
| `frontend/**` | `frontend-deploy.yml` | Builds the app, syncs it to S3, and invalidates CloudFront |
| `infrastructure/terraform/**` | `terraform-deploy.yml` | Runs `terraform plan` and `apply` |

First-time AWS setup (Terraform state, secrets, GitHub variables) is in [docs/deployment_guide.md](docs/deployment_guide.md).

## Documentation

- [System architecture](docs/system_architecture.md)
- [API spec](docs/api_spec.md)
- [Data model](docs/data_model.md)
- [AI prompt design](docs/ai_prompt_design.md)
- [Deployment guide](docs/deployment_guide.md)
- [Cost model](docs/cost_model.md)
- [MVP checklist](docs/short_term_mvp.md) and [long-term plan](docs/long_term_plan.md)

## Course log (CS 452)

### Time tracking

| Date | What | Hours |
| --- | --- | --- |
| 11/4/2025 | Worked on initial designs | 2.5 |
| 11/17/2025 | Worked on cost plans | 2 |
| 11/24/2025 | System Architecture design | 4 |
| 11/25/2025 | Home page and login UI mock | 8 |
| 12/3/2025 | More frontend | 4 |
| 12/4/2025 | Backend database, evaluate endpoint, firebase | 9 |
| 12/5/2025 | Frontend connect to supabase and firebase | 4 |
| 12/7/2025 | Trying to desperately get supabase to work | 8.5 |

Total: **42 hours**

### Takeaways

1. Storing and keeping secret keys and hidden information
2. Coordinating between a frontend and a backend
3. All of the different tools and even just languages that a project uses and needs

This project is interesting to me because of the relevance I feel it has to my time in higher level math courses, and how much I would've used this.
