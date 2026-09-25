-- One-off backfill: recompute every non-exam-passed proficiency rating as the share of the
-- section's course problems the user has answered correctly, scaled to 95 (matches
-- recompute_section_proficiency in proficiency_service.py). Safe to run more than once.
-- Run this in the Supabase SQL editor against your live project.

update public.proficiency p
set rating = coalesce((
        select count(distinct a."problemId")
        from public.user_problem_attempt a
        join public.problem pr on pr."problemId" = a."problemId"
        where a."userId" = p."userId"
          and a."isCorrect"
          and pr."sectionId" = p."sectionId"
          and pr."source" = 'course'
    )::real * 95.0 / nullif((
        select count(*)
        from public.problem pr
        where pr."sectionId" = p."sectionId"
          and pr."source" = 'course'
    ), 0), 0),
    "updatedAt" = now()
where not p."examPassed";
