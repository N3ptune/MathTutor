-- Proficiency tracking migration. Non-destructive: only adds columns/tables/policies,
-- never drops or rewrites existing data. Safe to run more than once.
-- Run this in the Supabase SQL editor against your live project.

-- ---------------------------------------------------------------------------
-- problem: separate the shared per-section catalog from a student's own
-- practice problems, and make sure sectionId exists (the app already relies
-- on it, but it was missing from the committed schema.sql).
-- ---------------------------------------------------------------------------
alter table public.problem add column if not exists "sectionId" bigint references public.section("sectionId");
alter table public.problem add column if not exists "source" text not null default 'course';
alter table public.problem add column if not exists "createdBy" bigint references public.users("userId");

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'problem_source_check'
  ) then
    alter table public.problem add constraint problem_source_check check ("source" in ('course', 'user'));
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- New tables
-- ---------------------------------------------------------------------------
create table if not exists public.user_problem_attempt (
    "attemptId" bigserial primary key,
    "userId" bigint not null references public.users("userId") on delete cascade,
    "problemId" bigint not null references public.problem("problemId") on delete cascade,
    "isCorrect" boolean not null,
    "proficiencyRating" real not null,
    "aiFeedback" text,
    "createdAt" timestamptz not null default now()
);

create table if not exists public.proficiency (
    "proficiencyId" bigserial primary key,
    "userId" bigint not null references public.users("userId") on delete cascade,
    "sectionId" bigint not null references public.section("sectionId") on delete cascade,
    rating real not null default 0,
    "examPassed" boolean not null default false,
    "updatedAt" timestamptz not null default now(),
    unique ("userId", "sectionId")
);

create table if not exists public.proficiency_exam_question (
    "examQuestionId" bigserial primary key,
    "sectionId" bigint not null references public.section("sectionId") on delete cascade,
    question text not null,
    "createdAt" timestamptz not null default now()
);

create table if not exists public.proficiency_exam_attempt (
    "examAttemptId" bigserial primary key,
    "userId" bigint not null references public.users("userId") on delete cascade,
    "sectionId" bigint not null references public.section("sectionId") on delete cascade,
    score real,
    passed boolean not null default false,
    "startedAt" timestamptz not null default now(),
    "completedAt" timestamptz
);

create table if not exists public.proficiency_exam_response (
    "examResponseId" bigserial primary key,
    "examAttemptId" bigint not null references public.proficiency_exam_attempt("examAttemptId") on delete cascade,
    "userId" bigint not null references public.users("userId") on delete cascade,
    "examQuestionId" bigint not null references public.proficiency_exam_question("examQuestionId"),
    "studentAnswer" text,
    "isCorrect" boolean,
    "aiFeedback" text
);

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
alter table public.user_problem_attempt      enable row level security;
alter table public.proficiency               enable row level security;
alter table public.proficiency_exam_question enable row level security;
alter table public.proficiency_exam_attempt  enable row level security;
alter table public.proficiency_exam_response enable row level security;

-- Tighten problem's read policy: "course" problems stay visible to everyone,
-- but "user" (personal practice) problems are now visible only to their creator.
drop policy if exists "problem: read" on public.problem;
create policy "problem: read" on public.problem
  for select to authenticated
  using ("source" = 'course' or "createdBy" = public.current_app_user_id());

drop policy if exists "user_problem_attempt: read own" on public.user_problem_attempt;
create policy "user_problem_attempt: read own" on public.user_problem_attempt
  for select to authenticated
  using ("userId" = public.current_app_user_id());

drop policy if exists "user_problem_attempt: insert own" on public.user_problem_attempt;
create policy "user_problem_attempt: insert own" on public.user_problem_attempt
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());

drop policy if exists "proficiency: read own" on public.proficiency;
create policy "proficiency: read own" on public.proficiency
  for select to authenticated
  using ("userId" = public.current_app_user_id());

drop policy if exists "proficiency: insert own" on public.proficiency;
create policy "proficiency: insert own" on public.proficiency
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());

drop policy if exists "proficiency: update own" on public.proficiency;
create policy "proficiency: update own" on public.proficiency
  for update to authenticated
  using ("userId" = public.current_app_user_id())
  with check ("userId" = public.current_app_user_id());

drop policy if exists "proficiency_exam_question: read" on public.proficiency_exam_question;
create policy "proficiency_exam_question: read" on public.proficiency_exam_question
  for select to authenticated using (true);

drop policy if exists "proficiency_exam_question: insert" on public.proficiency_exam_question;
create policy "proficiency_exam_question: insert" on public.proficiency_exam_question
  for insert to authenticated with check (true);

drop policy if exists "proficiency_exam_attempt: read own" on public.proficiency_exam_attempt;
create policy "proficiency_exam_attempt: read own" on public.proficiency_exam_attempt
  for select to authenticated
  using ("userId" = public.current_app_user_id());

drop policy if exists "proficiency_exam_attempt: insert own" on public.proficiency_exam_attempt;
create policy "proficiency_exam_attempt: insert own" on public.proficiency_exam_attempt
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());

drop policy if exists "proficiency_exam_attempt: update own" on public.proficiency_exam_attempt;
create policy "proficiency_exam_attempt: update own" on public.proficiency_exam_attempt
  for update to authenticated
  using ("userId" = public.current_app_user_id())
  with check ("userId" = public.current_app_user_id());

drop policy if exists "proficiency_exam_response: read own" on public.proficiency_exam_response;
create policy "proficiency_exam_response: read own" on public.proficiency_exam_response
  for select to authenticated
  using ("userId" = public.current_app_user_id());

drop policy if exists "proficiency_exam_response: insert own" on public.proficiency_exam_response;
create policy "proficiency_exam_response: insert own" on public.proficiency_exam_response
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());
