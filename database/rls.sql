-- Row-level security for MathTutor. Run in the Supabase SQL editor.
--
-- Column names are quoted because the app uses camelCase ("userId", "courseId", ...).
-- If your live tables use different casing, adjust the quoted names to match.
--
-- The frontend and backend both call Supabase as the signed-in user (the backend forwards
-- the user's access token), so every policy below is for the `authenticated` role.
-- Anonymous callers get nothing.

alter table public.users                     enable row level security;
alter table public.course                    enable row level security;
alter table public.section                   enable row level security;
alter table public.problem                   enable row level security;
alter table public.user_course               enable row level security;
alter table public.user_problem_attempt      enable row level security;
alter table public.proficiency               enable row level security;
alter table public.proficiency_exam_question enable row level security;
alter table public.proficiency_exam_attempt  enable row level security;
alter table public.proficiency_exam_response enable row level security;

-- ---------------------------------------------------------------------------
-- users: you can only see and change your own row.
-- The sign-in upsert matches by email (old rows can carry a stale auth_uid), so the
-- policies match on email OR auth_uid.
-- ---------------------------------------------------------------------------
create policy "users: read own row" on public.users
  for select to authenticated
  using (email = (auth.jwt() ->> 'email') or auth_uid::text = auth.uid()::text);

create policy "users: insert own row" on public.users
  for insert to authenticated
  with check (email = (auth.jwt() ->> 'email') and auth_uid::text = auth.uid()::text);

create policy "users: update own row" on public.users
  for update to authenticated
  using (email = (auth.jwt() ->> 'email') or auth_uid::text = auth.uid()::text)
  with check (email = (auth.jwt() ->> 'email') and auth_uid::text = auth.uid()::text);

-- Helper: the app-level "userId" of whoever is calling. SECURITY DEFINER so it can read
-- users without tripping that table's own policies.
create or replace function public.current_app_user_id()
returns bigint
language sql
stable
security definer
set search_path = public
as $$
  select "userId" from public.users
  where auth_uid::text = auth.uid()::text
  limit 1
$$;

-- ---------------------------------------------------------------------------
-- course / section / problem: any signed-in user can read.
-- ---------------------------------------------------------------------------
create policy "course: read" on public.course
  for select to authenticated using (true);

create policy "section: read" on public.section
  for select to authenticated using (true);

-- "course" problems (the shared, per-section catalog) are visible to everyone signed in.
-- "user" problems (a student's own extra practice) are visible only to their creator.
create policy "problem: read" on public.problem
  for select to authenticated
  using (source = 'course' or "createdBy" = public.current_app_user_id());

-- The backend inserts generated problems using the caller's token, so signed-in users
-- need insert on problem. Tighten later by moving generation to a service-role key.
create policy "problem: insert" on public.problem
  for insert to authenticated with check (true);

-- ---------------------------------------------------------------------------
-- user_course (enrollments): you can only see and create your own.
-- ---------------------------------------------------------------------------
create policy "user_course: read own" on public.user_course
  for select to authenticated
  using ("userId" = public.current_app_user_id());

create policy "user_course: enroll self" on public.user_course
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());

-- ---------------------------------------------------------------------------
-- user_problem_attempt: an append-only log of graded attempts. Own rows only.
-- ---------------------------------------------------------------------------
create policy "user_problem_attempt: read own" on public.user_problem_attempt
  for select to authenticated
  using ("userId" = public.current_app_user_id());

create policy "user_problem_attempt: insert own" on public.user_problem_attempt
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());

-- ---------------------------------------------------------------------------
-- proficiency: one row per user per section. Own rows only. Backend upserts this
-- (insert on first attempt, update as the rolling score changes), using the caller's token.
-- ---------------------------------------------------------------------------
create policy "proficiency: read own" on public.proficiency
  for select to authenticated
  using ("userId" = public.current_app_user_id());

create policy "proficiency: insert own" on public.proficiency
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());

create policy "proficiency: update own" on public.proficiency
  for update to authenticated
  using ("userId" = public.current_app_user_id())
  with check ("userId" = public.current_app_user_id());

-- ---------------------------------------------------------------------------
-- proficiency_exam_question: a per-section question bank, generated on demand.
-- Readable/insertable by any signed-in user, same trust model as `problem` above.
-- ---------------------------------------------------------------------------
create policy "proficiency_exam_question: read" on public.proficiency_exam_question
  for select to authenticated using (true);

create policy "proficiency_exam_question: insert" on public.proficiency_exam_question
  for insert to authenticated with check (true);

-- ---------------------------------------------------------------------------
-- proficiency_exam_attempt / proficiency_exam_response: own rows only.
-- ---------------------------------------------------------------------------
create policy "proficiency_exam_attempt: read own" on public.proficiency_exam_attempt
  for select to authenticated
  using ("userId" = public.current_app_user_id());

create policy "proficiency_exam_attempt: insert own" on public.proficiency_exam_attempt
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());

create policy "proficiency_exam_attempt: update own" on public.proficiency_exam_attempt
  for update to authenticated
  using ("userId" = public.current_app_user_id())
  with check ("userId" = public.current_app_user_id());

create policy "proficiency_exam_response: read own" on public.proficiency_exam_response
  for select to authenticated
  using ("userId" = public.current_app_user_id());

create policy "proficiency_exam_response: insert own" on public.proficiency_exam_response
  for insert to authenticated
  with check ("userId" = public.current_app_user_id());
