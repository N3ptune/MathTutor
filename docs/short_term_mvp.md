# 🚀 MVP Development Checklist (3–4 Week Plan)

## Week 1 — Project Foundation

### 🧱 Repo, Frontend, Backend, and Basic Schema

- [X] Create GitHub repository
- [X] Initialize React project (`create-react-app` or Vite)
- [X] Create basic React page structure:
  - [X] Home page
  - [X] Problem input page
  - [X] Dashboard page
- [X] Initialize FastAPI backend
- [X] Create `/evaluate` endpoint (stub response)
- [X] Set up auth (originally Firebase, now Supabase Auth: email/password + Google)
- [X] Set up PostgreSQL (Supabase)
- [X] Create minimal DB schema:
  - [X] `users` table
  - [X] `attempts` table
- [X] Connect backend to PostgreSQL
- [X] Implement basic full-stack flow with mock evaluation:
  - [X] User submits steps → backend returns fake output

---

## Week 2 — AI Integration & Data Persistence

### 🤖 Build Real Evaluation Pipeline

- [X] Integrate OpenAI API into backend
- [X] Create first prompt template for math-step evaluation
- [X] Parse user steps into prompt format
- [X] Create standardized AI response format (JSON)
- [X] Validate and sanitize AI output
- [X] Implement frontend logic to:
  - [X] Submit problem steps
  - [X] Display AI evaluation (where/why mistake)
- [X] Test with:
  - [X] Algebra problems
- [X] Add minimal error handling and retry logic

---

## Week 3 — UI Polish & Deployment

### 🌐 Ship the MVP to the Web

- [X] Add loading states in UI (full-screen throbber on every load and action)
- [X] Add validation for user inputs (blank submissions blocked in UI and API)
- [X] Improve layout and basic styling (responsive down to phone width)
- [X] Deploy frontend:
  - [X] AWS S3 bucket for static hosting
  - [X] CloudFront distribution (HTTPS on the default CloudFront domain)
  - [ ] Add custom domain
- [X] Deploy backend (AWS App Runner from ECR instead of EC2 + NGINX):
  - [X] Container image (Dockerfile) with Python and FastAPI
  - [X] Environment variables and secrets via SSM Parameter Store
- [X] Database on Supabase Postgres (instead of RDS)
- [X] Configure CORS and security settings (allowed origins, Supabase token checks, RLS)
- [ ] Perform end-to-end smoke tests:
  - [ ] Login → submit → AI evaluation → save → history

---

## Week 4 — Buffer & Optional Enhancements

### ✨ Enhancements (If Time Allows)

- [X] Add topic selector (class registration, courses, and sections)
- [X] Add simple proficiency score (per section, based on correct answers)
- [X] Add progress chart (proficiency rings per class and section)
- [X] Add GitHub Actions CI for:
  - [X] Linting (flake8 / eslint)
  - [X] Backend unit tests (pytest)
  - [X] Frontend unit tests (Vitest)
  - [X] Frontend build check
- [X] Add lightweight logging in backend
- [X] Add better styling (Tailwind + shadcn/ui)
- [X] Add basic rate limiting on `/evaluate`
- [X] Per-step right/wrong feedback and attempt history
- [ ] Add simple admin page (history lookup)

---

## Final Pre-Launch

### 🧪 QA & Polish

- [ ] Test on mobile devices
- [ ] Test slow networks / low bandwidth
- [ ] Test invalid inputs (empty steps, malformed spacing)
- [ ] Validate error reporting accuracy
- [ ] Run test accounts through typical problems
- [X] Finalize README and deployment instructions
- [X] Tag MVP release (`v0.1.0`)

---

## 🎉 MVP READY
