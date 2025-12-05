# MathTutor

An app that takes in user input in clear steps for a higher level math problem, and then passes the user input to AI in order to read through and determine if and where the user made a mistake in the solving of their problem. The user will receive a background proficiency rating per section of the class, and can generate reviews/study guides.  

## Time Tracking

| Date | What | Hours |
|------|------|-------|
| 11/4/2025 | Worked on initial designs | 2.5 |
| 11/17/2025 | Worked on cost plans  | 2 |
| 11/24/2025 | System Architecture design | 4 |
| 11/25/2025  | Home page and login UI mock | 8 |
| 12/3/2025| More frontend | 4 |
| 12/4/2025 | Backend database, evaluate endpoint, firebase | 9 |
| 12/5/2025 | Frontend connect to supabase and firebase | 4 |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |

### **Total: 33.5**

## ✅ Project Development Checklist

A checklist to track progress across all parts of the system (frontend, backend, AI pipeline, infra, deployment).

---

## 📁 Project Setup

- [X] Initialize monorepo structure (`client/`, `server/`, `infrastructure/`)
- [X] Set up GitHub repository
- [ ] Add `.gitignore` for React, Python, and environment files
- [X] Create initial README with project overview
- [ ] Define environment variable structure (`.env.example`)

---

## 🎨 Frontend — React App (client/)

### Core Setup

- [X] Initialize React app
- [X] Install dependencies (React Router, Axios, Tailwind, etc.)
- [ ] Set up global state management (Zustand / Redux)
- [X] Configure route structure
- [ ] Add reusable layout components

### UI Screens

- [X] Home / Landing Page
- [X] Login / Signup UI
- [X] Dashboard (progress overview)
- [ ] Problem Input Flow (multi-step wizard)
- [ ] AI Feedback / Results Page
- [ ] Study Guide / Review Generator Page
- [ ] User Settings Page

### Services & Utilities

- [ ] API service wrapper
- [ ] Firebase Auth integration
- [ ] Reusable input components
- [ ] Math formatting (MathJax/KaTeX)
- [ ] Error boundaries & loading states

---

## 🧠 Backend — Python API (server/)

### Setup

- [ ] Create FastAPI project
- [ ] Set up Poetry / pipenv for dependencies
- [ ] Add OpenAI SDK, LangChain, NumPy, SymPy
- [ ] Configure logging + error handling middleware
- [ ] Create environment variable loader

### API Endpoints

- [ ] `/auth/login`
- [ ] `/auth/register`
- [ ] `/problems/submit`
- [ ] `/problems/evaluate`
- [ ] `/reviews/generate`
- [ ] `/progress/user`
- [ ] `/admin/health`

### AI Processing Pipeline

- [ ] Create LangChain pipeline for step-by-step evaluation
- [ ] Implement symbolic math checks using SymPy
- [ ] Implement mistake detection logic
- [ ] Implement proficiency scoring model (per topic)
- [ ] Create review/study guide generator

---

## 🗄️ Database — PostgreSQL (server/db)

### Schema Setup

- [ ] Create `users` table
- [ ] Create `problem_attempts` table
- [ ] Create `steps` table
- [ ] Create `ai_evaluations` table
- [ ] Create `proficiency_scores` table
- [ ] Create `study_guides` table
- [ ] Write initial SQL migrations

### ORM / Query Layer

- [ ] Implement SQLAlchemy models
- [ ] Implement repository classes
- [ ] Add unit tests for DB access

---

## ☁️ Firebase Authentication

- [ ] Configure Firebase project
- [ ] Enable email/password auth
- [ ] Connect Firebase to frontend
- [ ] Validate Firebase tokens in backend middleware
- [ ] Secure protected routes

---

## 🪣 AWS Infrastructure (infrastructure/)

### S3

- [ ] Create S3 bucket for static assets / files
- [ ] Configure permissions & bucket policies

### EC2 / ECS

- [ ] Provision compute resource for backend
- [ ] Set up Docker environment
- [ ] Configure auto-restart policies

### RDS

- [ ] Create PostgreSQL instance
- [ ] Configure backups
- [ ] Enable IAM database authentication

### CloudFront

- [ ] Connect S3 + CloudFront for frontend deployment
- [ ] Add caching + HTTPS

### IAM & Security

- [ ] Create roles for app services
- [ ] Lock down access policies
- [ ] Set up secrets in AWS Parameter Store

---

## 🔐 Authentication & Authorization

- [ ] Token validation middleware in backend
- [ ] Role system (admin/user)
- [ ] Permission levels for endpoints
- [ ] Secure API routes with Firebase tokens

---

## 🔄 CI/CD — GitHub Actions

- [ ] Set up linting & formatting checks
- [ ] Add unit test workflow (client + server)
- [ ] Build React on push to main
- [ ] Build & deploy backend Docker image
- [ ] Deploy frontend to S3/CloudFront
- [ ] Add automatic database migrations

---

## 🧪 Testing

### Frontend

- [ ] Component tests
- [ ] Workflow tests for problem submission
- [ ] Snapshot tests

### Backend

- [ ] Unit tests for logic & AI pipeline
- [ ] Endpoint integration tests
- [ ] DB tests with test container

### End-to-End

- [ ] User login flow
- [ ] Submit math problem
- [ ] AI detects mistake
- [ ] Proficiency updated
- [ ] Study guide generated

---

## 📈 Monitoring & Logging

- [ ] Configure CloudWatch logs
- [ ] Add API request logging
- [ ] Add error alerts
- [ ] Add system health dashboard

---

## 🚀 Deployment

- [ ] Deploy frontend (S3 + CloudFront)
- [ ] Deploy backend (EC2 / ECS)
- [ ] Connect backend to RDS
- [ ] Add domain name (Route 53)
- [ ] Set up HTTPS certificates
- [ ] Validate full production workflow

---

## 📚 Documentation

- [ ] Full architecture documentation
- [ ] API reference docs
- [ ] ERD diagram
- [ ] Developer onboarding guide
- [ ] Feature roadmap

---

### 🎉 Final Goal

- [ ] MVP live with user accounts
- [ ] Users can submit problems
- [ ] AI detects mistakes & explains them
- [ ] Proficiency tracking works
- [ ] Study guides generate successfully
- [ ] System stable & monitored
