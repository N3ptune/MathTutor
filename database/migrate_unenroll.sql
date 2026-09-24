-- Allows a user to delete their own enrollment row, so they can unregister from a class.
-- Non-destructive: only adds an RLS policy, no schema/data changes. Safe to re-run.
-- Run this in the Supabase SQL editor against your live project.

drop policy if exists "user_course: unenroll self" on public.user_course;
create policy "user_course: unenroll self" on public.user_course
  for delete to authenticated
  using ("userId" = public.current_app_user_id());
