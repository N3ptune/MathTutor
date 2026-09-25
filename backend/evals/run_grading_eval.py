"""Measures how accurately the AI grader judges known-answer solutions.

Calls the real OpenAI API (costs a few cents per full run), so it is run by hand, not in CI:

    cd backend
    python -m evals.run_grading_eval                    # uses GRADING_REASONING_EFFORT
    python -m evals.run_grading_eval --effort low       # try a cheaper setting
    python -m evals.run_grading_eval --repeat 3         # grading is not deterministic

Run it before changing the grading prompt, model, or reasoning effort, and compare:
false accepts (wrong work marked correct) are the most damaging mistake a tutor can make.
"""
import argparse
import asyncio
import json
import sys
from pathlib import Path

CASES_PATH = Path(__file__).with_name("grading_cases.json")


def load_cases() -> list[dict]:
    return json.loads(CASES_PATH.read_text(encoding="utf-8"))["cases"]


def score(results: list[dict]) -> dict:
    """results: [{"case": case, "graded": normalized grader output}] -> summary metrics."""
    verdict_right = false_accepts = false_rejects = 0
    steps_scored = steps_right = 0
    misses = []

    for result in results:
        case, graded = result["case"], result["graded"]
        expected, actual = case["all_correct"], graded["all_correct"]

        if expected == actual:
            verdict_right += 1
        elif actual and not expected:
            false_accepts += 1
            misses.append(f"FALSE ACCEPT  {case['id']}")
        else:
            false_rejects += 1
            misses.append(f"false reject  {case['id']}")

        for i, want in enumerate(case["step_correct"]):
            if want is None:
                continue
            steps_scored += 1
            got = graded["step_correct"][i] if i < len(graded["step_correct"]) else None
            if got == want:
                steps_right += 1
            else:
                misses.append(f"step {i + 1} wrong  {case['id']} (expected {want}, got {got})")

    total = len(results)
    return {
        "cases": total,
        "verdict_accuracy": verdict_right / total if total else 0.0,
        "false_accepts": false_accepts,
        "false_rejects": false_rejects,
        "step_accuracy": steps_right / steps_scored if steps_scored else 0.0,
        "misses": misses,
    }


async def run(cases: list[dict], effort: str | None, concurrency: int) -> tuple[list[dict], list[dict]]:
    # Imported here so `score` can be unit-tested without OpenAI credentials
    from app.services import usage_service
    from app.workers import evaluation_worker

    if effort:
        evaluation_worker.GRADING_REASONING_EFFORT = effort

    calls: list[dict] = []
    usage_service._meter.set(calls)
    semaphore = asyncio.Semaphore(concurrency)

    async def grade(case: dict) -> dict:
        async with semaphore:
            try:
                graded = await evaluation_worker.grade_solution(case["problem"], case["steps"])
            except Exception as exc:
                # An unparseable reply counts as a failed grade, as it would for a student
                print(f"  error grading {case['id']}: {exc}", file=sys.stderr)
                graded = {"all_correct": None, "step_correct": []}
            return {"case": case, "graded": graded}

    results = await asyncio.gather(*(grade(case) for case in cases))
    return results, calls


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--effort", choices=["minimal", "low", "medium", "high"], help="override reasoning effort")
    parser.add_argument("--repeat", type=int, default=1, help="run every case this many times")
    parser.add_argument("--only", help="run only cases whose id contains this text")
    parser.add_argument("--concurrency", type=int, default=5)
    parser.add_argument("--min-accuracy", type=float, default=0.0, help="exit 1 if verdict accuracy is below this")
    args = parser.parse_args()

    cases = [c for c in load_cases() if not args.only or args.only in c["id"]] * args.repeat
    results, calls = asyncio.run(run(cases, args.effort, args.concurrency))
    summary = score(results)

    cost = sum(c["costUsd"] for c in calls)
    print(f"\nCases:              {summary['cases']}")
    print(f"Verdict accuracy:   {summary['verdict_accuracy']:.1%}")
    print(f"False accepts:      {summary['false_accepts']}  (wrong work marked correct)")
    print(f"False rejects:      {summary['false_rejects']}  (right work marked wrong)")
    print(f"Step accuracy:      {summary['step_accuracy']:.1%}")
    print(f"OpenAI cost:        ${cost:.4f} total, ${cost / max(len(cases), 1):.5f} per grade")
    if summary["misses"]:
        print("\nMisses:")
        for miss in summary["misses"]:
            print(f"  {miss}")

    return 1 if summary["verdict_accuracy"] < args.min_accuracy else 0


if __name__ == "__main__":
    sys.exit(main())
