"""Tops up every section's shared course problems to a target count with AI-generated ones.

Course problems are what proficiency is measured against, so a section with only a handful
runs dry quickly for a paying student. Uses the service-role key (bypasses RLS) and calls
OpenAI, so run it by hand against the environment you mean to change:

    cd backend
    python -m scripts.top_up_course_problems --dry-run          # show what would be added
    python -m scripts.top_up_course_problems --target 15 --max-new 200

Review a sample of the new problems afterwards; generated problems are not hand-checked.
"""
import argparse
import asyncio
import sys
from collections import defaultdict

import httpx

from app.config import SUPABASE_URL
from app.services import supabase_service, usage_service
from app.workers.problem_generation_worker import generate_problem_for_section


async def fetch(path: str) -> list[dict]:
    async with httpx.AsyncClient(timeout=30) as client:
        resp = await client.get(f"{SUPABASE_URL}/rest/v1/{path}", headers=supabase_service._service_headers())
    resp.raise_for_status()
    return resp.json()


async def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--target", type=int, default=15, help="course problems wanted per section")
    parser.add_argument("--max-new", type=int, default=100, help="stop after generating this many (cost cap)")
    parser.add_argument("--course", type=int, help="only this courseId")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    # Run the generator's database calls with the service-role key instead of a user's token
    supabase_service._user_headers = lambda _token: supabase_service._service_headers()

    sections = await fetch("section?select=sectionId,name,courseId&order=courseId,sectionId")
    if args.course:
        sections = [s for s in sections if s["courseId"] == args.course]
    problems = await fetch("problem?source=eq.course&select=sectionId,problem")

    by_section = defaultdict(list)
    for problem in problems:
        by_section[problem["sectionId"]].append(problem["problem"])

    plan = [(s, args.target - len(by_section[s["sectionId"]])) for s in sections]
    plan = [(s, need) for s, need in plan if need > 0]
    total_needed = sum(need for _, need in plan)

    print(f"{len(plan)} of {len(sections)} sections are below {args.target} course problems "
          f"({total_needed} to generate, capped at {args.max_new}).")
    for section, need in plan:
        print(f"  course {section['courseId']:>3}  {section['name']:<45} +{need}")
    if args.dry_run or not plan:
        return 0

    calls: list[dict] = []
    usage_service._meter.set(calls)
    generated = failures = 0

    for section, need in plan:
        for _ in range(need):
            if generated >= args.max_new:
                break
            try:
                row = await generate_problem_for_section(
                    section["courseId"], section["sectionId"], "service-role", avoid=by_section[section["sectionId"]]
                )
                by_section[section["sectionId"]].append(row["problem"])
                generated += 1
            except Exception as exc:
                failures += 1
                print(f"  failed for section {section['sectionId']}: {exc}", file=sys.stderr)

    cost = sum(c["costUsd"] for c in calls)
    print(f"Generated {generated} problems ({failures} failures). OpenAI cost: ${cost:.4f}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
