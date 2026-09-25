import { describe, expect, it, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import LoadingOverlay from "./LoadingOverlay";
import ErrorMessage from "./ErrorMessage";
import StepFeedback, { ResultBanner } from "./StepFeedback";
import AttemptHistory from "./AttemptHistory";

describe("LoadingOverlay", () => {
  it("renders nothing when hidden", () => {
    const { container } = render(<LoadingOverlay show={false} />);
    expect(container).toBeEmptyDOMElement();
  });

  it("shows a busy status with its message", () => {
    render(<LoadingOverlay show message="Evaluating your work..." />);
    const status = screen.getByRole("status");
    expect(status).toHaveAttribute("aria-busy", "true");
    expect(status).toHaveTextContent("Evaluating your work...");
  });
});

describe("ErrorMessage", () => {
  it("renders nothing without a message", () => {
    const { container } = render(<ErrorMessage message="" />);
    expect(container).toBeEmptyDOMElement();
  });

  it("calls onRetry from the Try again button", async () => {
    const onRetry = vi.fn();
    render(<ErrorMessage message="Can't reach the server." onRetry={onRetry} />);

    expect(screen.getByRole("alert")).toHaveTextContent("Can't reach the server.");
    await userEvent.click(screen.getByRole("button", { name: "Try again" }));
    expect(onRetry).toHaveBeenCalledOnce();
  });
});

describe("StepFeedback", () => {
  it("is green and labelled for a correct step", () => {
    const { container } = render(<StepFeedback text="Nice." correct={true} />);
    expect(container.firstChild.className).toContain("green");
    expect(screen.getByLabelText("Correct step")).toBeInTheDocument();
  });

  it("is red and labelled for an incorrect step", () => {
    const { container } = render(<StepFeedback text="Sign error." correct={false} />);
    expect(container.firstChild.className).toContain("red");
    expect(screen.getByLabelText("Incorrect step")).toBeInTheDocument();
  });

  it("is neutral when correctness is unknown", () => {
    const { container } = render(<StepFeedback text="Hmm." correct={null} />);
    expect(container.firstChild.className).not.toMatch(/green|red/);
  });
});

describe("ResultBanner", () => {
  it("congratulates a correct answer", () => {
    render(<ResultBanner allCorrect />);
    expect(screen.getByRole("status")).toHaveTextContent("Correct!");
  });

  it("points to the red steps on a wrong answer", () => {
    render(<ResultBanner allCorrect={false} />);
    expect(screen.getByRole("status")).toHaveTextContent("Not quite");
  });
});

describe("AttemptHistory", () => {
  const attempts = [
    {
      attemptId: 2,
      createdAt: "2026-09-25T15:00:00Z",
      isCorrect: false,
      steps: ["x + 1 = 3", "x = 4"],
      stepFeedback: ["Good.", "Should be 2."],
      stepCorrect: [true, false],
    },
    {
      attemptId: 1,
      createdAt: "2026-09-24T15:00:00Z",
      isCorrect: true,
      aiFeedback: "Older attempt saved before step history existed.",
    },
  ];

  it("shows an empty state", () => {
    render(<AttemptHistory attempts={[]} />);
    expect(screen.getByText(/No attempts yet/)).toBeInTheDocument();
  });

  it("lists attempts newest first with their result", () => {
    render(<AttemptHistory attempts={attempts} />);
    const rows = screen.getAllByRole("listitem");
    expect(rows[0]).toHaveTextContent("Incorrect");
    expect(rows[0]).toHaveTextContent("Attempt 2");
    expect(rows[1]).toHaveTextContent("Correct");
    expect(rows[1]).toHaveTextContent("Attempt 1");
  });

  it("expands an attempt to show its steps and feedback", async () => {
    render(<AttemptHistory attempts={attempts} />);
    expect(screen.queryByText("Should be 2.")).not.toBeInTheDocument();

    await userEvent.click(screen.getByRole("button", { name: /Attempt 2/ }));

    expect(screen.getByText("Should be 2.")).toBeInTheDocument();
    expect(screen.getByText("Should be 2.").closest("div").className).toContain("red");
  });

  it("falls back to the combined feedback for old attempts", async () => {
    render(<AttemptHistory attempts={attempts} />);
    await userEvent.click(screen.getByRole("button", { name: /Attempt 1/ }));
    expect(screen.getByText("Older attempt saved before step history existed.")).toBeInTheDocument();
  });
});
