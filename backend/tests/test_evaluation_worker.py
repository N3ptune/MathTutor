from app.workers.evaluation_worker import normalize_evaluation


def test_keeps_well_formed_output():
    result = normalize_evaluation({
        "feedback": ["Good start.", "Sign error here."],
        "step_correct": [True, False],
        "all_correct": False,
        "proficiency_rating": 40,
    })

    assert result == {
        "feedback": ["Good start.", "Sign error here."],
        "step_correct": [True, False],
        "all_correct": False,
        "proficiency_rating": 40.0,
    }


def test_pads_missing_step_correctness_with_none():
    result = normalize_evaluation({"feedback": ["a", "b", "c"], "step_correct": [True]})

    assert result["step_correct"] == [True, None, None]


def test_truncates_extra_step_correctness():
    result = normalize_evaluation({"feedback": ["a"], "step_correct": [True, False, True]})

    assert result["step_correct"] == [True]


def test_non_boolean_correctness_becomes_none():
    result = normalize_evaluation({"feedback": ["a", "b"], "step_correct": ["yes", 1]})

    assert result["step_correct"] == [None, None]


def test_all_correct_requires_a_real_true():
    assert normalize_evaluation({"all_correct": "true"})["all_correct"] is False
    assert normalize_evaluation({"all_correct": True})["all_correct"] is True


def test_clamps_and_coerces_rating():
    assert normalize_evaluation({"proficiency_rating": 250})["proficiency_rating"] == 100.0
    assert normalize_evaluation({"proficiency_rating": -5})["proficiency_rating"] == 0.0
    assert normalize_evaluation({"proficiency_rating": "not a number"})["proficiency_rating"] == 0.0


def test_handles_garbage_input():
    result = normalize_evaluation(["not", "a", "dict"])

    assert result == {"feedback": [], "step_correct": [], "all_correct": False, "proficiency_rating": 0.0}


def test_keeps_extracted_steps_for_uploads():
    result = normalize_evaluation({"extracted_steps": ["x = 2", None], "feedback": ["ok"], "step_correct": [True]})

    assert result["extracted_steps"] == ["x = 2"]


def test_omits_extracted_steps_for_typed_answers():
    assert "extracted_steps" not in normalize_evaluation({"feedback": []})
