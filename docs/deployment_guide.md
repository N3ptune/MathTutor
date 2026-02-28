# MathTutor AWS Deployment Guide

Step-by-step instructions for first-time deployment and ongoing operations.

## Quick Local Deploy (Backend + Frontend)

Use this when you want to run both services locally instead of AWS.

```bash
cd /path/to/MathTutor
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env

# Fill in real values in backend/.env and frontend/.env

docker-compose -f docker-compose.local.yml up --build
```

Endpoints:
- Frontend: `http://localhost:5173`
- Backend: `http://localhost:8000`
- Health: `http://localhost:8000/health`

---

## Prerequisites

- AWS CLI configured with admin-level credentials
- Terraform >= 1.5 installed
- Docker installed locally
- GitHub repository with Actions enabled

---

## Step 1: Bootstrap Terraform State Backend (one-time)

```bash
cd infrastructure/scripts
chmod +x bootstrap_state.sh
./bootstrap_state.sh
```

This creates:
- S3 bucket `mathtutor-terraform-state` (versioned, encrypted)
- DynamoDB table `mathtutor-terraform-locks`

---

## Step 2: Configure Terraform Variables

```bash
cd infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set your `github_repo` to your actual GitHub `owner/repo`.

---

## Step 3: Apply Terraform

```bash
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
```

Note the outputs:
- `cloudfront_distribution_url` — your frontend URL
- `apprunner_service_url` — your backend API URL
- `ecr_repository_url` — where to push Docker images
- `github_actions_role_arn` — for GitHub Actions OIDC
- `s3_bucket_name` — frontend assets bucket
- `cloudfront_distribution_id` — for cache invalidation

---

## Step 4: Populate SSM Secrets

Replace placeholder values with real secrets:

```bash
aws ssm put-parameter \
  --name "/mathtutor/prod/OPENAI_API_KEY" \
  --value "sk-your-real-key" \
  --type SecureString \
  --overwrite

aws ssm put-parameter \
  --name "/mathtutor/prod/SUPABASE_URL" \
  --value "https://your-project.supabase.co" \
  --type SecureString \
  --overwrite

aws ssm put-parameter \
  --name "/mathtutor/prod/SUPABASE_ANON_KEY" \
  --value "your-anon-key" \
  --type SecureString \
  --overwrite

aws ssm put-parameter \
  --name "/mathtutor/prod/SUPABASE_SERVICE_ROLE_KEY" \
  --value "your-service-role-key" \
  --type SecureString \
  --overwrite

aws ssm put-parameter \
  --name "/mathtutor/prod/FIREBASE_SERVICE_ACCOUNT" \
  --value "$(cat path/to/serviceAccountKey.json)" \
  --type SecureString \
  --overwrite
```

---

## Step 5: First Backend Deploy

Build and push the Docker image manually for the first deploy:

```bash
# Get ECR login
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <ECR_REPOSITORY_URL>

# Build and push
cd backend
docker build -t mathtutor-backend .
docker tag mathtutor-backend:latest <ECR_REPOSITORY_URL>:latest
docker push <ECR_REPOSITORY_URL>:latest
```

App Runner will automatically pick up the image and start the service.

Verify: `curl https://<APPRUNNER_SERVICE_URL>/health`

---

## Step 6: First Frontend Deploy

```bash
cd frontend

# Set env vars for the build
export VITE_API_URL=https://<APPRUNNER_SERVICE_URL>
export VITE_SUPABASE_URL=https://your-project.supabase.co
export VITE_SUPABASE_ANON_KEY=your-anon-key
export VITE_FIREBASE_API_KEY=your-firebase-api-key
export VITE_FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
export VITE_FIREBASE_PROJECT_ID=your-project-id
export VITE_FIREBASE_STORAGE_BUCKET=your-project.firebasestorage.app
export VITE_FIREBASE_MESSAGING_SENDER_ID=your-sender-id
export VITE_FIREBASE_APP_ID=your-app-id

npm ci
npm run build

aws s3 sync dist/ s3://<S3_BUCKET_NAME> --delete
aws cloudfront create-invalidation \
  --distribution-id <CLOUDFRONT_DISTRIBUTION_ID> \
  --paths "/*"
```

---

## Step 7: Configure GitHub Actions

In your GitHub repository settings:

**Secrets** (Settings > Secrets and variables > Actions > Secrets):
- `AWS_ROLE_ARN` = the `github_actions_role_arn` output from Terraform

**Variables** (Settings > Secrets and variables > Actions > Variables):
- `S3_BUCKET_NAME` = the `s3_bucket_name` output
- `CLOUDFRONT_DISTRIBUTION_ID` = the `cloudfront_distribution_id` output
- `ECR_REPOSITORY_NAME` = `mathtutor-backend`
- `APPRUNNER_SERVICE_ARN` = from AWS console or `terraform output`
- `APPRUNNER_ECR_ROLE_ARN` = from AWS console (the ECR access role)
- `VITE_API_URL` = the `apprunner_service_url` output (with `https://`)
- `VITE_SUPABASE_URL` = your Supabase project URL
- `VITE_SUPABASE_ANON_KEY` = your Supabase anon key
- `VITE_FIREBASE_API_KEY` = your Firebase API key
- `VITE_FIREBASE_AUTH_DOMAIN` = your Firebase auth domain
- `VITE_FIREBASE_PROJECT_ID` = your Firebase project ID
- `VITE_FIREBASE_STORAGE_BUCKET` = your Firebase storage bucket
- `VITE_FIREBASE_MESSAGING_SENDER_ID` = your Firebase sender ID
- `VITE_FIREBASE_APP_ID` = your Firebase app ID

---

## Step 8: Smoke Test

1. Open `https://<CLOUDFRONT_URL>` in browser
2. Register / sign in via Firebase Auth
3. Navigate to a course > section > problem
4. Submit steps and verify AI evaluation returns feedback
5. Check App Runner logs in AWS console for any errors

---

## Credential Rotation Reminder

The following credentials were previously exposed in git history and should be rotated:

- OpenAI API key
- Supabase anon key
- Supabase service role key
- Supabase database password
- JWT secret

Rotate these in their respective platforms, then update SSM Parameter Store values.

---

## Ongoing Deploys

After initial setup, all deploys are automatic on merge to `main`:

- **Terraform changes** (`infrastructure/terraform/**`) -> `terraform-deploy.yml`
- **Frontend changes** (`frontend/**`) -> `frontend-deploy.yml`
- **Backend changes** (`backend/**`) -> `backend-deploy.yml`
