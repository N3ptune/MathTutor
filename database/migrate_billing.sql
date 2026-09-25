-- Billing, usage metering, consent, and grade reports. Non-destructive: only adds tables,
-- columns, indexes, and policies. Safe to run more than once.
-- Run this in the Supabase SQL editor against your live project.

-- ---------------------------------------------------------------------------
-- subscription: a cache of each user's Stripe subscription. Written only by the backend's
-- Stripe webhook using the service-role key (which bypasses RLS); users can only read theirs.
-- ---------------------------------------------------------------------------
create table if not exists public.subscription (
    "userId" bigint primary key references public.users("userId") on delete cascade,
    "stripeCustomerId" text unique,
    "stripeSubscriptionId" text unique,
    status text,
    "currentPeriodEnd" timestamptz,
    "cancelAtPeriodEnd" boolean not null default false,
    "updatedAt" timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- ai_usage: one row per request that called OpenAI, with its summed tokens and cost.
-- Monthly quotas count these rows. Written only by the backend (service role).
-- ---------------------------------------------------------------------------
create table if not exists public.ai_usage (
    "usageId" bigserial primary key,
    "userId" bigint not null references public.users("userId") on delete cascade,
    action text not null,
    model text not null,
    calls integer not null default 1,
    "inputTokens" integer not null default 0,
    "cachedTokens" integer not null default 0,
    "outputTokens" integer not null default 0,
    "reasoningTokens" integer not null default 0,
    "costUsd" numeric(12, 6) not null default 0,
    "createdAt" timestamptz not null default now()
);

create index if not exists ai_usage_user_created_idx on public.ai_usage ("userId", "createdAt" desc);

-- ---------------------------------------------------------------------------
-- grade_report: a student flagging an AI grade as wrong. Reviewed by hand, and the source
-- of new cases for backend/evals/grading_cases.json.
-- ---------------------------------------------------------------------------
create table if not exists public.grade_report (
    "reportId" bigserial primary key,
    "userId" bigint not null references public.users("userId") on delete cascade,
    "attemptId" bigint not null references public.user_problem_attempt("attemptId") on delete cascade,
    reason text not null check (char_length(reason) between 1 and 2000),
    status text not null default 'open' check (status in ('open', 'confirmed', 'rejected')),
    "createdAt" timestamptz not null default now(),
    unique ("userId", "attemptId")
);

-- ---------------------------------------------------------------------------
-- users: record when (and to which version of) the Terms and Privacy Policy someone agreed,
-- including confirming they are 13 or older.
-- ---------------------------------------------------------------------------
alter table public.users add column if not exists "termsAcceptedAt" timestamptz;
alter table public.users add column if not exists "termsVersion" text;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
alter table public.subscription enable row level security;
alter table public.ai_usage     enable row level security;
alter table public.grade_report enable row level security;

drop policy if exists "subscription: read own" on public.subscription;
create policy "subscription: read own" on public.subscription
  for select to authenticated
  using ("userId" = public.current_app_user_id());

drop policy if exists "ai_usage: read own" on public.ai_usage;
create policy "ai_usage: read own" on public.ai_usage
  for select to authenticated
  using ("userId" = public.current_app_user_id());

drop policy if exists "grade_report: read own" on public.grade_report;
create policy "grade_report: read own" on public.grade_report
  for select to authenticated
  using ("userId" = public.current_app_user_id());

-- Only for your own attempts
drop policy if exists "grade_report: insert own" on public.grade_report;
create policy "grade_report: insert own" on public.grade_report
  for insert to authenticated
  with check (
    "userId" = public.current_app_user_id()
    and exists (
      select 1 from public.user_problem_attempt a
      where a."attemptId" = grade_report."attemptId"
        and a."userId" = public.current_app_user_id()
    )
  );

-- No insert/update/delete policies on subscription or ai_usage: only the service role
-- (which bypasses RLS) may write them, so students can't grant themselves Pro or reset usage.

-- ---------------------------------------------------------------------------
-- problem: students may only insert their own personal practice problems. Shared course
-- problems set every student's proficiency denominator, so only the service role (the
-- scripts/top_up_course_problems.py admin script) may add them.
-- ---------------------------------------------------------------------------
drop policy if exists "problem: insert" on public.problem;
create policy "problem: insert" on public.problem
  for insert to authenticated
  with check (source = 'user' and "createdBy" = public.current_app_user_id());
