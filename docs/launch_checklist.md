# Paid launch checklist

The code for billing, usage limits, consent, legal pages, account tools, grade reports, error tracking, a custom domain, and a staging environment is in the repo. These steps need your accounts or a decision, so they have to be done by hand. Do them in order: staging first, then prod.

## 0. Before merging this into `main`

Merging deploys immediately. Two things must already be done, or grading and sign-in break:

- **Run `database/migrate_billing.sql` on prod.** Every AI request checks the new `ai_usage` table, and the consent screen writes the new `termsAcceptedAt` column. Without the migration, grading fails with an error and students get stuck on the consent screen.
- **Set `/mathtutor/prod/SUPABASE_SERVICE_ROLE_KEY` in SSM to the real service-role key** (Supabase → Project Settings → API). The backend never used it before, so it may still say `PLACEHOLDER`. Usage limits need it, so without it every AI request fails.

Stripe, Sentry, and everything else below can come later: the app runs with billing off (everyone on Free) until the Stripe keys are set.

## 1. Database (Supabase SQL editor)

Run in each Supabase project (staging and prod). All are safe to re-run.

1. `database/migrate_attempt_history.sql`, if not already run
2. `database/migrate_billing.sql`: subscriptions, AI usage, grade reports, and terms-acceptance columns

## 2. Supabase settings

- **Upgrade prod to the Pro plan ($25/month).** The free plan pauses inactive projects and has no backups.
- **Authentication → Providers → Email: turn on "Confirm email".** The signup form already handles it.
- **Authentication → URL Configuration:** set the Site URL to the public frontend URL, and add `https://<your-domain>/reset-password` to the redirect URLs (plus the staging and `http://localhost:5173` equivalents).
- **Authentication → SMTP:** set up a real email sender (Resend, Postmark, SES). Supabase's built-in sender is rate-limited to a few emails an hour, which breaks signups.

## 3. Stripe

1. Create the Stripe account and finish business verification.
2. **Product catalog:** create a product "MathTutor Pro" with a **$9.99 monthly recurring** price. Copy the price ID (`price_...`).
3. **Developers → Webhooks:** add the endpoint `https://<APPRUNNER_SERVICE_URL>/billing/webhook` with these events:
   - `checkout.session.completed`
   - `customer.subscription.created`, `customer.subscription.updated`, `customer.subscription.deleted`, `customer.subscription.paused`, `customer.subscription.resumed`

   Copy the signing secret (`whsec_...`).
4. **Settings → Billing → Customer portal:** turn on cancelling subscriptions and updating payment methods.
5. **Settings → Tax:** turn on Stripe Tax if you need to collect sales tax.
6. Use test mode for staging and live mode for prod. Each has its own keys, price ID, and webhook.

Put the values in SSM (Terraform creates the parameters as `PLACEHOLDER`):

```bash
ENV=prod   # or staging
aws ssm put-parameter --overwrite --type SecureString --name "/mathtutor/$ENV/STRIPE_SECRET_KEY"     --value "sk_live_..."
aws ssm put-parameter --overwrite --type SecureString --name "/mathtutor/$ENV/STRIPE_WEBHOOK_SECRET" --value "whsec_..."
aws ssm put-parameter --overwrite --type SecureString --name "/mathtutor/$ENV/STRIPE_PRICE_ID"       --value "price_..."
```

App Runner reads secrets when it starts, so redeploy the backend after changing them. Billing stays off, and the Upgrade button stays disabled, until all three are set.

Test end to end on staging with card `4242 4242 4242 4242`: upgrade, check that the Account page shows Pro, cancel in the portal, and check that the plan shows it ending.

## 4. Sentry (optional but recommended)

Create two Sentry projects, one Python (FastAPI) and one React.

- Put the backend DSN in SSM as `/mathtutor/<env>/SENTRY_DSN`.
- Set the frontend DSN as the GitHub variable `VITE_SENTRY_DSN` (`STAGING_VITE_SENTRY_DSN` for staging).

## 5. OpenAI

- **Settings → Limits:** set a monthly budget with an email alert. This is your backstop if something unexpected happens.
- Check current prices against `MODEL_PRICES` in `backend/app/services/usage_service.py`.

## 6. Grading accuracy

```bash
cd backend
python -m evals.run_grading_eval --repeat 3
```

Aim for zero false accepts (wrong work marked correct). To cut costs, try `--effort low`; if accuracy holds, set `GRADING_REASONING_EFFORT=low` on App Runner. Review reports with `select * from grade_report where status = 'open'`, and add each confirmed miss to `backend/evals/grading_cases.json`.

## 7. Content

```bash
cd backend
python -m scripts.top_up_course_problems --dry-run
python -m scripts.top_up_course_problems --target 15 --max-new 200
```

Spot-check a sample of the new problems in each class before launch.

## 8. Legal

- Set the GitHub variables `VITE_SUPPORT_EMAIL`, `VITE_LEGAL_ENTITY`, and `VITE_GOVERNING_LAW`.
- **Have a lawyer review the Terms, Privacy Policy, and Refund Policy** (`frontend/src/pages/legal/`). They are drafts. Minors' data (COPPA for under-13s, state student-privacy laws) is the main risk area.
- If you change them materially later, bump `TERMS_VERSION` in `frontend/src/lib/config.js` so everyone is asked to accept again.
- Consider forming an LLC before taking payments.

## 9. Custom domain

1. Buy the domain.
2. In **ACM, in us-east-1**, request a certificate for the domain and `www.`, and validate it by DNS.
3. Set these GitHub variables, then push a Terraform change or run the Terraform workflow:
   - `TF_FRONTEND_DOMAIN_NAMES` = `["yourdomain.com","www.yourdomain.com"]`
   - `TF_FRONTEND_CERTIFICATE_ARN` = the certificate ARN
4. Point DNS at the CloudFront distribution: a CNAME for `www`, and an ALIAS/ANAME for the bare domain.
5. Update the Supabase Site URL and redirect URLs (step 2), and the Stripe webhook if you move the API.

## 10. Staging environment (one-time bootstrap)

Staging is a second copy of the stack deployed from the `staging` branch, with its own Supabase project and Stripe test keys. Prod's GitHub role can't create it, so bootstrap it once with admin AWS credentials:

```bash
cd infrastructure/terraform
cp staging.tfvars.example staging.tfvars      # set github_repo
terraform init -reconfigure -backend-config="key=staging/terraform.tfstate"
terraform apply -var-file=staging.tfvars
```

Local Terraform runs against prod now need `terraform init -reconfigure -backend-config="key=prod/terraform.tfstate"`.

Then add GitHub **secrets** `STAGING_AWS_ROLE_ARN` and `STAGING_VITE_SUPABASE_ANON_KEY`, and **variables**:

- `STAGING_S3_BUCKET_NAME`
- `STAGING_CLOUDFRONT_DISTRIBUTION_ID`
- `STAGING_ECR_REPOSITORY_NAME` (`mathtutor-staging-backend`)
- `STAGING_APPRUNNER_SERVICE_ARN`
- `STAGING_VITE_API_URL`
- `STAGING_VITE_SUPABASE_URL`

Take the values from `terraform output`. Put staging's Supabase and OpenAI secrets in SSM under `/mathtutor/staging/`, run the step 1 migrations in the staging Supabase project, and push the first backend image (see `deployment_guide.md`, step 5).

After that, merge into `staging` to test, then into `main` to release. Every deploy runs the CI checks first.

A staging App Runner instance costs about $10–25/month even when idle.

## 11. Before announcing

- [ ] Sign up as a new user on prod: confirmation email, consent screen, a graded problem, the free limit (the 16th check is blocked with an upgrade prompt), upgrade, cancel, download data, delete account
- [ ] Test password reset from a signed-out browser
- [ ] Test on a phone
- [ ] Check that Sentry receives a test error from both apps
