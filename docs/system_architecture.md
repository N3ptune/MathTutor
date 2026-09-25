# Math Learning App - Complete Project Structure

A complete hierarchical explanation of each folder and file in the system.

This document describes the architecture, purpose, responsibilities, and interactions of every directory and important file in the project.

## 📁 Project Structure Overview

```txt
math-learning-app/
├── README.md
├── .gitignore
├── .env.example
├── docker-compose.yml
├── infra/
├── ci-cd/
├── frontend/
├── backend/
├── database/
├── analytics/
├── scripts/
└── docs/
```

Each top-level section below explains the contents and purpose of every folder and file.

---

## 🧱 Top-Level Project Files

### README.md

Main documentation for developers and contributors:

- Setup instructions
- Overview of architecture
- How to run local environment
- Deployment instructions

### .gitignore

Specifies which files Git should ignore:

- Logs
- Environment files
- Node modules
- Python cache files
- Build artifacts

### .env.example

A template listing environment variables required for the project:

- API keys
- DB credentials
- Supabase settings
- AWS configuration

### docker-compose.yml

Defines multi-container local development environment:

- Backend container
- PostgreSQL container
- Adminer/pgAdmin
- Optional local S3 emulator (MinIO)

---

## ☁️ infra/

Infrastructure code for deployment, cloud architecture, and automation.

```txt
infra/
├── terraform/
├── aws/
└── scripts/
```

### 🌍 infra/terraform/

Infrastructure as Code (IaC) for fully automating AWS.

#### main.tf

Entry point: configures AWS provider, backend state, and includes modules.

#### variables.tf

Declares variables such as:

- Instance sizes
- Database credentials
- Bucket names

#### outputs.tf

Outputs resource IDs (RDS URL, S3 URL, etc.) for other systems.

#### modules/

Reusable resource modules.

**aws-network/**
Creates:

- VPC
- Subnets
- Security groups
- NAT + routing

**rds-postgres/**
Creates:

- PostgreSQL DB instance
- Backup retention
- Automated failover

**s3-frontend/**
Creates:

- S3 bucket for React build
- Bucket policy
- Versioning

**ecs-backend/**
Creates:

- ECS Fargate cluster
- Task definition
- Load balancer

**cloudfront/**
Creates global CDN for the React frontend.

### 🏗 infra/aws/

Manual deployment configurations (if you aren't using Terraform).

Includes JSON/YAML templates for:

- IAM roles
- S3 buckets
- RDS configs
- ECS task definitions

### 🔧 infra/scripts/

Automation scripts.

#### deploy_frontend.sh

Builds and uploads React app → S3 → invalidates CloudFront.

#### deploy_backend.sh

Builds Docker container, pushes to ECR, deploys to ECS.

#### backup_db.sh

Triggers RDS snapshot for safety.

#### rotate_logs.sh

Clears CloudWatch logs on schedule.

---

## 🚦 ci-cd/

```txt
ci-cd/
├── github/
├── tests/
└── static-analysis/
```

### 📦 ci-cd/github/workflows/

GitHub Actions pipelines.

#### frontend-ci.yml

Runs:

- npm install
- Lint
- Tests
- Build

#### backend-ci.yml

Runs:

- pip install
- mypy
- unit tests
- integration tests

#### deploy.yml

Auto-deploys to AWS on merge to main.

### 🧪 ci-cd/tests/integration-tests.sh

Calls backend endpoints, ensuring no breaking API changes.

### 🧼 ci-cd/static-analysis/

#### eslint.config.js

Frontend JS/TS linting rules.

#### mypy.ini

Backend Python type-checking rules.

---

## 🎨 frontend/ (React)

```txt
frontend/
├── public/
├── src/
│   ├── components/
│   ├── pages/
│   ├── hooks/
│   ├── utils/
│   ├── context/
│   ├── services/
│   ├── styles/
│   └── assets/
└── tests/
```

### 📁 public/

Static assets served directly:

- Favicon
- Manifest
- Robots.txt

### 📁 src/

#### App.jsx

Main application router + layout wrapper.

#### index.jsx

Entry point to React, renders `<App />`.

### 🧩 components/

Reusable UI components.

**layout/**

- Navbar
- Sidebar
- Footer

**ui/**
General UI elements:

- Buttons
- Inputs
- Cards

**problem-solving/**
Specialized math components:

- Step input fields
- Equation renderer (KaTeX)
- AI feedback panel

**charts/**
Charts using Recharts for proficiency heatmaps, progress graphs.

### 📄 pages/

Screens of the app.

#### Home.jsx

Landing screen.

#### Dashboard.jsx

Visualizes:

- Trends
- Ratings
- Recent problems

#### ProblemSolver.jsx

Step-by-step input UI for math problems.

#### ReviewGenerator.jsx

Generates personalized study guides.

#### AuthCallback.jsx

Handles Supabase Auth (Google OAuth) redirect logins.

### 🪝 hooks/

Custom React hooks, e.g.:

- `useAuth()`
- `useApi()`
- `useProficiency()`

### 🧰 utils/

Helpful logic:

- `latex.ts` — formatting math for UI
- `supabase.js` — browser-side Supabase client and auth helpers

### 🔌 services/

API clients and business logic (frontend-side).

#### api.js

CRUD operations for backend.

#### auth.js

Sign-in/out with Supabase Auth.

#### analytics.js

Event tracking for user behavior.

### 🎨 styles/

CSS / Tailwind configuration.

### 🖼 assets/

Static images, icons, and illustrations.

### 🧪 tests/

Unit + end-to-end tests.

---

## 🐍 backend/ (FastAPI)

```txt
backend/
├── app/
│   ├── main.py
│   ├── config.py
│   ├── routers/
│   ├── controllers/
│   ├── services/
│   ├── models/
│   ├── schemas/
│   ├── db/
│   ├── utils/
│   ├── workers/
│   └── tests/
├── requirements.txt
├── Dockerfile
└── start.sh
```

### 📄 main.py

FastAPI app initialization:

- Middleware
- Routers
- Logging
- Supabase auth integration (`auth.py` verifies access tokens)

### 📄 config.py

Loads environment variables.

### 📁 routers/

API endpoints (HTTP interfaces).

#### auth_router.py

Login + tokens.

#### problems_router.py

Post new math problem.

#### steps_router.py

Submit step-by-step work.

#### evaluations_router.py

Call AI evaluator and return results.

#### users_router.py

User data and profile.

#### review_router.py

Study guide generation.

### 📁 controllers/

The business logic layer.

- `auth_controller.py`
- `evaluation_controller.py`
- `progress_controller.py`
- `review_controller.py`

These call:

- AI
- Math engines (SymPy)
- Database models

### 📁 services/

Internal reusable modules.

#### ai_service.py

Handles:

- LangChain chains
- OpenAI models
- Prompt templates
- AI error detection logic

#### math_service.py

Uses SymPy/NumPy for:

- Expression validation
- Step correctness checking
- Algebra simplification

#### proficiency_service.py

Updates user's mastery levels by topic.

#### feedback_service.py

Formats AI feedback into human-readable form.

#### user_service.py

Profile updates and user queries.

### 📁 models/

SQLAlchemy models describing database tables.

- `user.py` — User base data
- `problem.py` — Stores problem text
- `step.py` — Each step the user submitted
- `ai_evaluation.py` — AI-generated feedback and classification
- `proficiency.py` — Scores per category/topic
- `base.py` — Base SQLAlchemy metadata

### 📁 schemas/

Pydantic schemas for request/response validation.

### 📁 db/

Database configuration.

#### session.py

Creates SQLAlchemy session.

#### init_db.py

Runs migrations and seeds.

#### migrations/

Alembic auto-generated migration files.

### 📁 utils/

Helpers for:

- JWT tools
- Logging
- Validation

### 📁 workers/

Background task processors (Celery or RQ).

#### evaluation_worker.py

Asynchronously calls AI model to evaluate steps.

#### queue_config.py

Queue definitions.

### 🧪 tests/

Backend unit/integration tests.

### requirements.txt

All Python dependencies.

### Dockerfile

Backend build instructions for AWS ECS.

### start.sh

Boot script for container.

---

## 🛢 database/

### schema.sql

Full DB schema.

### seed_data.sql

Initial data for development/testing.

### maintenance/

Scripts:

- `vacuum.sh` — cleans database
- `migrate.sh` — runs Alembic migrations

---

## 📈 analytics/

### proficiency_report_templates/

Markdown or LaTeX templates for output.

### charts/

Reusable chart-generation code.

### generators/

#### proficiency_report_generator.py

Builds a student's full performance report.

#### study_guide_generator.py

AI-powered study guide generator.

### tracking/event_logger.py

Logs interactions or triggers for analytics.

---

## 🛠 scripts/

### run_local.sh

Boots local dev setup.

### init_env.sh

Creates environment variable files.

### lint_all.sh

Runs frontend + backend linters.

### backup_all.sh

Cloud backup automation.

### sync_s3.sh

Uploads assets to AWS S3.

---

## 📚 docs/

Internal developer documentation.

### system-architecture.md

High-level system overview and diagrams.

### data-model.md

ERD and table definitions.

### api-spec.md

Every backend endpoint (OpenAPI-style).

### ai-prompt-design.md

Prompt templates + chain logic.

### onboarding.md

New developer setup guide.

### scaling-plan.md

Strategies for backend, DB, CDN, and queue scaling.

### cost-model.md

Updated cost and pricing formulas.
