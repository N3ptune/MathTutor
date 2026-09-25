import { useContext, useEffect, useState } from "react";
import { motion } from "framer-motion";
import { AuthState } from "../authState.jsx";
import {
  loginWithGoogle,
  registerEmailPassword,
  loginEmailPassword,
} from "../supabase.js";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/dialog";
import LoadingOverlay from "@/components/LoadingOverlay";
import ErrorMessage from "@/components/ErrorMessage";
import MathText from "@/components/MathText";
import StepFeedback from "@/components/StepFeedback";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { friendlyError } from "@/lib/api";
import { PLANS, PRODUCT_NAME } from "@/lib/config";
import { Camera, Check, ClipboardCheck, History, LineChart, ShieldCheck, Sparkles } from "lucide-react";

const EXAMPLE_STEPS = [
  { work: "$2x + 6 = 14$", feedback: "Correct: you distributed the 2 to both terms.", correct: true },
  {
    work: "$2x = 20$",
    feedback: "Check this step: subtracting 6 from both sides gives $14 - 6$, not $14 + 6$.",
    correct: false,
  },
];

const HOW_IT_WORKS = [
  { title: "Pick a problem", body: "Choose a class and section, or generate a fresh practice problem." },
  { title: "Show your steps", body: "Type each step, or snap a photo or upload a PDF of your handwritten work." },
  {
    title: "See what went wrong",
    body: "Every step is marked right or wrong with an explanation, so you can fix it yourself.",
  },
];

const FEATURES = [
  {
    icon: ClipboardCheck,
    title: "Step-by-step grading",
    body: "Find the exact step where a solution goes off track, not just whether the final answer is right.",
  },
  { icon: Camera, title: "Photos and PDFs", body: "Work on paper? Upload a picture and MathTutor reads your steps." },
  {
    icon: LineChart,
    title: "Track your progress",
    body: "See your proficiency in every section and class, and prove mastery with section exams.",
  },
  { icon: Sparkles, title: "Unlimited practice", body: "Generate new problems on any section whenever you want more practice." },
  { icon: History, title: "Every attempt saved", body: "Review your past attempts and feedback before a test." },
  { icon: ShieldCheck, title: "Hints, not answers", body: "Feedback explains mistakes without giving away the final answer." },
];

const PRICING = [
  {
    name: PLANS.free.name,
    price: "$0",
    period: "",
    cta: "Start free",
    features: [`${PLANS.free.monthlyActions} AI checks a month`, "Step-by-step feedback", "Progress tracking"],
  },
  {
    name: PLANS.pro.name,
    price: `$${PLANS.pro.price.toFixed(2)}`,
    period: "/month",
    cta: "Start free, upgrade anytime",
    highlight: true,
    features: [
      `${PLANS.pro.monthlyActions} AI checks a month`,
      "Photo and PDF grading",
      "Personal practice problems",
      "Proficiency exams for every section",
      "Cancel anytime",
    ],
  },
];

const FAQ = [
  {
    q: "Will it just give me the answers?",
    a: "No. MathTutor points out which step is wrong and why, so you can find and fix the mistake yourself.",
  },
  {
    q: "How accurate is the grading?",
    a: "It's right most of the time, but AI can make mistakes. If a grade looks wrong, report it with one click and we'll review it. Always check with your teacher when it matters.",
  },
  {
    q: "What classes are covered?",
    a: "Algebra 1 and 2, Geometry, Trigonometry, Calculus 1 and 2, and Linear Algebra, with more on the way.",
  },
  {
    q: "What happens if I use up my checks?",
    a: "Free checks reset on the 1st of each month, or you can upgrade to Pro anytime. Pro includes enough checks for daily practice.",
  },
  {
    q: "Can I cancel Pro?",
    a: "Yes, anytime from your Account page. You keep Pro until the end of the month you've paid for.",
  },
  {
    q: "Who can use MathTutor?",
    a: "Anyone 13 or older. Students under 18 need a parent or guardian's permission.",
  },
];

export default function Home() {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useContext(AuthState);

  const [showLogin, setShowLogin] = useState(false);
  const [showRegister, setShowRegister] = useState(false);

  const [loginEmail, setLoginEmail] = useState("");
  const [loginPassword, setLoginPassword] = useState("");

  const [regFirstName, setRegFirstName] = useState("");
  const [regLastName, setRegLastName] = useState("");
  const [regEmail, setRegEmail] = useState("");
  const [regPassword, setRegPassword] = useState("");
  const [regConfirm, setRegConfirm] = useState("");

  const [busyMessage, setBusyMessage] = useState("");
  const [loginError, setLoginError] = useState("");
  const [registerError, setRegisterError] = useState("");
  // Set after email signup when Supabase requires confirming the address first
  const [confirmationEmail, setConfirmationEmail] = useState("");

  useEffect(() => {
    if (user) navigate("/dashboard");
  }, [user, navigate]);

  // Footer links point at /#pricing; scroll there once the page has rendered. Only plain
  // anchors: after Google sign-in the hash holds tokens (#access_token=...), which aren't a
  // valid CSS selector and would throw.
  useEffect(() => {
    if (/^#[A-Za-z][\w-]*$/.test(location.hash)) {
      document.getElementById(location.hash.slice(1))?.scrollIntoView();
    }
  }, [location.hash]);

  // Supabase explains bad credentials itself; anything else gets the standard friendly message
  function authErrorMessage(err) {
    return err?.name === "AuthApiError" && err.message ? err.message : friendlyError(err);
  }

  async function handleLoginEmail() {
    if (!loginEmail.trim() || !loginPassword) {
      setLoginError("Please enter your email and password.");
      return;
    }

    setLoginError("");
    setBusyMessage("Signing in...");
    try {
      await loginEmailPassword(loginEmail.trim(), loginPassword);
      setShowLogin(false);
    } catch (err) {
      console.error(err);
      setLoginError(`Login failed. ${authErrorMessage(err)}`);
    } finally {
      setBusyMessage("");
    }
  }

  async function handleRegisterEmail() {
    if (!regFirstName.trim() || !regLastName.trim()) {
      setRegisterError("Please enter your first and last name.");
      return;
    }

    if (!regEmail.trim() || !regPassword) {
      setRegisterError("Please enter an email and password.");
      return;
    }

    if (regPassword !== regConfirm) {
      setRegisterError("Passwords do not match.");
      return;
    }

    setRegisterError("");
    setBusyMessage("Creating your account...");
    try {
      const { needsConfirmation } = await registerEmailPassword(
        regEmail.trim(), regPassword, regFirstName.trim(), regLastName.trim()
      );
      if (needsConfirmation) {
        setConfirmationEmail(regEmail.trim());
      } else {
        setShowRegister(false);
      }
    } catch (err) {
      console.error(err);
      setRegisterError(`Registration failed. ${authErrorMessage(err)}`);
    } finally {
      setBusyMessage("");
    }
  }

  async function handleGoogleLogin() {
    const setError = showRegister ? setRegisterError : setLoginError;
    setError("");
    // Google sign-in navigates away, so the overlay stays up until the redirect happens
    setBusyMessage("Redirecting to Google...");
    try {
      await loginWithGoogle();
    } catch (err) {
      console.error(err);
      setError(`Google sign-in failed. ${authErrorMessage(err)}`);
      setBusyMessage("");
    }
  }

  function openRegister() {
    setConfirmationEmail("");
    setShowRegister(true);
  }

  return (
    <div className="w-full bg-background">
      <LoadingOverlay show={Boolean(busyMessage)} message={busyMessage} />

      {/* Top bar */}
      <header className="max-w-6xl mx-auto px-4 sm:px-6 py-4 flex items-center justify-between gap-4">
        <span className="text-xl font-bold text-primary">{PRODUCT_NAME}</span>
        <div className="flex items-center gap-2">
          <Button variant="ghost" onClick={() => setShowLogin(true)}>
            Sign in
          </Button>
          <Button onClick={openRegister}>Start free</Button>
        </div>
      </header>

      {/* Hero */}
      <section className="max-w-6xl mx-auto px-4 sm:px-6 pt-8 pb-16 sm:pt-16 grid gap-10 md:grid-cols-2 md:items-center">
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="space-y-6 text-center md:text-left"
        >
          <h1 className="text-4xl sm:text-5xl font-bold tracking-tight">
            Show your work. <span className="text-primary">Find your mistake.</span>
          </h1>
          <p className="text-lg text-muted-foreground">
            {PRODUCT_NAME} checks every step of your solution, shows exactly where it went wrong, and explains why,
            without just handing you the answer.
          </p>
          <div className="flex flex-col sm:flex-row gap-3 justify-center md:justify-start">
            <Button size="lg" onClick={openRegister}>
              Start free: {PLANS.free.monthlyActions} checks a month
            </Button>
            <Button size="lg" variant="outline" asChild>
              <a href="#pricing">See pricing</a>
            </Button>
          </div>
          <p className="text-sm text-muted-foreground">No card needed to start.</p>
        </motion.div>

        <Card aria-label="Example of step-by-step feedback">
          <CardContent className="space-y-3">
            <MathText as="p" className="font-medium">{"Solve $2(x + 3) = 14$"}</MathText>
            {EXAMPLE_STEPS.map((step) => (
              <div key={step.work} className="space-y-1">
                <MathText as="div" className="text-sm">{step.work}</MathText>
                <StepFeedback text={step.feedback} correct={step.correct} />
              </div>
            ))}
          </CardContent>
        </Card>
      </section>

      {/* How it works */}
      <section className="bg-muted/40 py-16">
        <div className="max-w-6xl mx-auto px-4 sm:px-6">
          <h2 className="text-2xl sm:text-3xl font-bold text-center mb-10">How it works</h2>
          <ol className="grid gap-6 md:grid-cols-3">
            {HOW_IT_WORKS.map((item, i) => (
              <li key={item.title} className="rounded-xl border bg-card p-6 space-y-2">
                <span className="inline-flex size-8 items-center justify-center rounded-full bg-primary text-primary-foreground font-semibold">
                  {i + 1}
                </span>
                <h3 className="font-semibold text-lg">{item.title}</h3>
                <p className="text-muted-foreground text-sm">{item.body}</p>
              </li>
            ))}
          </ol>
        </div>
      </section>

      {/* Features */}
      <section className="max-w-6xl mx-auto px-4 sm:px-6 py-16">
        <h2 className="text-2xl sm:text-3xl font-bold text-center mb-10">Built for learning, not answer-copying</h2>
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {FEATURES.map((feature) => (
            <div key={feature.title} className="space-y-2">
              <feature.icon className="size-6 text-primary" />
              <h3 className="font-semibold">{feature.title}</h3>
              <p className="text-sm text-muted-foreground">{feature.body}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Pricing */}
      <section id="pricing" className="bg-muted/40 py-16 scroll-mt-4">
        <div className="max-w-4xl mx-auto px-4 sm:px-6">
          <h2 className="text-2xl sm:text-3xl font-bold text-center mb-2">Simple pricing</h2>
          <p className="text-center text-muted-foreground mb-10">Start free. Upgrade when you need more.</p>
          <div className="grid gap-6 md:grid-cols-2">
            {PRICING.map((plan) => (
              <Card key={plan.name} className={plan.highlight ? "border-primary border-2" : ""}>
                <CardHeader>
                  <CardTitle className="flex items-baseline justify-between gap-2">
                    <span>{plan.name}</span>
                    <span>
                      <span className="text-3xl font-bold">{plan.price}</span>
                      <span className="text-sm text-muted-foreground font-normal">{plan.period}</span>
                    </span>
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <ul className="space-y-2 text-sm">
                    {plan.features.map((feature) => (
                      <li key={feature} className="flex gap-2">
                        <Check className="size-4 shrink-0 text-primary mt-0.5" />
                        {feature}
                      </li>
                    ))}
                  </ul>
                  <Button className="w-full" variant={plan.highlight ? "default" : "outline"} onClick={openRegister}>
                    {plan.cta}
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
          <p className="text-xs text-center text-muted-foreground mt-6">
            An AI check is one graded submission, generated practice problem, or exam submission. Cancel anytime.
          </p>
        </div>
      </section>

      {/* FAQ */}
      <section className="max-w-3xl mx-auto px-4 sm:px-6 py-16">
        <h2 className="text-2xl sm:text-3xl font-bold text-center mb-8">Questions</h2>
        <div className="space-y-3">
          {FAQ.map((item) => (
            <details key={item.q} className="rounded-lg border p-4 group">
              <summary className="font-medium cursor-pointer list-none flex justify-between gap-4">
                {item.q}
                <span className="text-muted-foreground group-open:rotate-45 transition-transform">+</span>
              </summary>
              <p className="mt-3 text-sm text-muted-foreground">{item.a}</p>
            </details>
          ))}
        </div>
      </section>

      <section className="text-center pb-16 px-4">
        <Button size="lg" onClick={openRegister}>
          Try it free
        </Button>
      </section>

      {/* LOGIN DIALOG */}
      <Dialog open={showLogin} onOpenChange={setShowLogin}>
        <DialogContent className="sm:max-w-md max-h-[90dvh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Sign In</DialogTitle>
            <DialogDescription>Enter your credentials to continue.</DialogDescription>
          </DialogHeader>
          <div className="flex flex-col gap-4">
            <div className="space-y-2">
              <Label htmlFor="login-email">Email</Label>
              <Input
                id="login-email"
                type="email"
                placeholder="Email"
                value={loginEmail}
                onChange={(e) => setLoginEmail(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="login-password">Password</Label>
              <Input
                id="login-password"
                type="password"
                placeholder="Password"
                value={loginPassword}
                onChange={(e) => setLoginPassword(e.target.value)}
              />
            </div>
            <ErrorMessage message={loginError} />
            <Button onClick={handleLoginEmail}>Sign In</Button>
            <Link to="/reset-password" className="text-sm text-center text-muted-foreground underline">
              Forgot your password?
            </Link>
            <div className="relative my-2">
              <div className="absolute inset-0 flex items-center">
                <span className="w-full border-t" />
              </div>
              <div className="relative flex justify-center text-xs uppercase">
                <span className="bg-background px-2 text-muted-foreground">or</span>
              </div>
            </div>
            <Button variant="outline" onClick={handleGoogleLogin}>Sign in with Google</Button>
          </div>
        </DialogContent>
      </Dialog>

      {/* REGISTER DIALOG */}
      <Dialog open={showRegister} onOpenChange={setShowRegister}>
        <DialogContent className="sm:max-w-md max-h-[90dvh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Create Account</DialogTitle>
            <DialogDescription>Fill in your details to get started.</DialogDescription>
          </DialogHeader>
          {confirmationEmail ? (
            <div className="space-y-4">
              <p className="text-sm">
                We sent a confirmation link to <strong className="break-all">{confirmationEmail}</strong>. Click it to
                finish creating your account, then sign in.
              </p>
              <Button
                className="w-full"
                onClick={() => {
                  setShowRegister(false);
                  setShowLogin(true);
                }}
              >
                Go to sign in
              </Button>
            </div>
          ) : (
            <div className="flex flex-col gap-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="reg-first-name">First Name</Label>
                  <Input
                    id="reg-first-name"
                    type="text"
                    placeholder="First Name"
                    value={regFirstName}
                    onChange={(e) => setRegFirstName(e.target.value)}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="reg-last-name">Last Name</Label>
                  <Input
                    id="reg-last-name"
                    type="text"
                    placeholder="Last Name"
                    value={regLastName}
                    onChange={(e) => setRegLastName(e.target.value)}
                  />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="reg-email">Email</Label>
                <Input
                  id="reg-email"
                  type="email"
                  placeholder="Email"
                  value={regEmail}
                  onChange={(e) => setRegEmail(e.target.value)}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="reg-password">Password</Label>
                <Input
                  id="reg-password"
                  type="password"
                  placeholder="Password"
                  value={regPassword}
                  onChange={(e) => setRegPassword(e.target.value)}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="reg-confirm">Confirm Password</Label>
                <Input
                  id="reg-confirm"
                  type="password"
                  placeholder="Confirm Password"
                  value={regConfirm}
                  onChange={(e) => setRegConfirm(e.target.value)}
                />
              </div>
              <ErrorMessage message={registerError} />
              <Button onClick={handleRegisterEmail}>Register</Button>
              <div className="relative my-2">
                <div className="absolute inset-0 flex items-center">
                  <span className="w-full border-t" />
                </div>
                <div className="relative flex justify-center text-xs uppercase">
                  <span className="bg-background px-2 text-muted-foreground">or</span>
                </div>
              </div>
              <Button variant="outline" onClick={handleGoogleLogin}>Sign up with Google</Button>
              <p className="text-xs text-muted-foreground text-center">
                By creating an account you confirm you're 13 or older and agree to our{" "}
                <Link to="/terms" className="underline">Terms</Link> and{" "}
                <Link to="/privacy" className="underline">Privacy Policy</Link>.
              </p>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
