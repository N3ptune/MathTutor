from evals.run_grading_eval import load_cases, score


def test_cases_are_well_formed():
    cases = load_cases()
    ids = [c["id"] for c in cases]

    assert len(cases) >= 40
    assert len(ids) == len(set(ids))
    for case in cases:
        assert case["problem"] and case["steps"]
        assert isinstance(case["all_correct"], bool)
        assert len(case["step_correct"]) == len(case["steps"]), case["id"]
        # A fully correct solution can't contain a wrong step
        if case["all_correct"]:
            assert False not in case["step_correct"], case["id"]
    # Both kinds of case, so the eval can catch false accepts and false rejects
    assert any(c["all_correct"] for c in cases)
    assert any(not c["all_correct"] for c in cases)


def case(case_id, all_correct, step_correct):
    return {"id": case_id, "all_correct": all_correct, "step_correct": step_correct}


def test_score_separates_false_accepts_from_false_rejects():
    summary = score([
        {"case": case("a", True, [True]), "graded": {"all_correct": True, "step_correct": [True]}},
        {"case": case("b", False, [False]), "graded": {"all_correct": True, "step_correct": [True]}},
        {"case": case("c", True, [True]), "graded": {"all_correct": False, "step_correct": [True]}},
    ])

    assert summary["verdict_accuracy"] == 1 / 3
    assert summary["false_accepts"] == 1
    assert summary["false_rejects"] == 1
    assert any("FALSE ACCEPT  b" in m for m in summary["misses"])


def test_score_ignores_unlabeled_steps_and_counts_missing_ones_wrong():
    summary = score([
        {"case": case("a", False, [False, None, True]), "graded": {"all_correct": False, "step_correct": [False, True]}},
    ])

    # Step 2 is unlabeled; step 3 is missing from the grader's output
    assert summary["step_accuracy"] == 0.5
