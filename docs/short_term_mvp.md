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
- [X] Set up Firebase Auth (email/password only)
- [X] Set up PostgreSQL locally or on RDS
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

- [ ] Add loading states in UI
- [ ] Add validation for user inputs
- [ ] Improve layout and basic styling
- [ ] Deploy frontend:
  - [ ] AWS S3 bucket for static hosting
  - [ ] CloudFront distribution
  - [ ] Add custom domain and HTTPS
- [ ] Deploy backend:
  - [ ] Launch EC2 instance (t3.small)
  - [ ] Install Python, FastAPI
  - [ ] Configure reverse proxy (NGINX)
  - [ ] Add environment variables (OpenAI key, Firebase keys, DB credentials)
- [ ] Set up PostgreSQL RDS instance (if not local)
- [ ] Configure CORS and security settings
- [ ] Perform end-to-end smoke tests:
  - [ ] Login → submit → AI evaluation → save → history

---

## Week 4 — Buffer & Optional Enhancements

### ✨ Enhancements (If Time Allows)

- [ ] Add topic-selector dropdown (Algebra, Calculus, etc.)
- [ ] Add simple proficiency score per problem
- [ ] Add progress chart (local, not full analytics system)
- [ ] Add GitHub Actions CI for:
  - [ ] Linting (flake8 / eslint)
  - [ ] Backend unit tests
  - [ ] Frontend build check
- [ ] Add lightweight logging in backend (file + console)
- [ ] Add better styling (Tailwind or Material UI)
- [ ] Add basic rate limiting on `/evaluate`
- [ ] Add simple admin page (history lookup)

---

## Final Pre-Launch

### 🧪 QA & Polish

- [ ] Test on mobile devices
- [ ] Test slow networks / low bandwidth
- [ ] Test invalid inputs (empty steps, malformed spacing)
- [ ] Validate error reporting accuracy
- [ ] Run test accounts through typical problems
- [ ] Finalize README and deployment instructions
- [ ] Tag MVP release (`v0.1.0`)

---

## 🎉 MVP READY
