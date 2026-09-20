-- Row-level security for MathTutor. Run in the Supabase SQL editor.
--
-- Column names are quoted because the app uses camelCase ("userId", "courseId", ...).
-- If your live tables use different casing, adjust the quoted names to match.
--
-- The frontend and backend both call Supabase as the signed-in user (the backend forwards
-- the user's access token), so every policy below is for the `authenticated` role.
-- Anonymous callers get nothing.

alter table public.users       enable row level security;
alter table public.course      enable row level security;
alter table public.section     enable row level security;
alter table public.problem     enable row level security;
alter table public.user_course enable row level security;

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

create policy "problem: read" on public.problem
  for select to authenticated using (true);

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
