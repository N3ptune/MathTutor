-- Attempt history migration. Non-destructive: only adds columns, so older attempts keep
-- working (their new columns are null). Safe to run more than once.
-- Run this in the Supabase SQL editor against your live project.

-- Full record of each graded submission so students can review past attempts:
-- the steps as graded, the AI's feedback per step, and whether each step was correct.
alter table public.user_problem_attempt add column if not exists "steps" jsonb;
alter table public.user_problem_attempt add column if not exists "stepFeedback" jsonb;
alter table public.user_problem_attempt add column if not exists "stepCorrect" jsonb;

-- The problem page lists a student's attempts on one problem, newest first
create index if not exists user_problem_attempt_user_problem_idx
  on public.user_problem_attempt ("userId", "problemId", "createdAt" desc);
