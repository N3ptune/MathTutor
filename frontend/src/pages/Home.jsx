import { useContext, useEffect, useState } from "react";
import { motion } from "framer-motion";
import { AuthState } from "../authState.jsx";
import {
  loginWithGoogle,
  registerEmailPassword,
  loginEmailPassword,
  isFirebaseAuthConfigured,
} from "../firebase";
import { useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
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

export default function Home() {
  const navigate = useNavigate();
  const { user, setSupabaseUser } = useContext(AuthState);

  const [showLogin, setShowLogin] = useState(false);
  const [showRegister, setShowRegister] = useState(false);

  const [loginEmail, setLoginEmail] = useState("");
  const [loginPassword, setLoginPassword] = useState("");

  const [regEmail, setRegEmail] = useState("");
  const [regPassword, setRegPassword] = useState("");
  const [regConfirm, setRegConfirm] = useState("");

  useEffect(() => {
    if (user) navigate("/dashboard");
  }, [user, navigate]);

  async function handleLoginEmail() {
    if (!isFirebaseAuthConfigured) {
      return;
    }
    try {
      const userCred = await loginEmailPassword(loginEmail, loginPassword);

      const { data, error } = await supabase
        .from("users")
        .select("*")
        .eq("firebase_uid", userCred.user.uid)
        .single();

      if (error) throw error;

      setSupabaseUser(data);
      setShowLogin(false);
      navigate("/dashboard");
    } catch (err) {
      console.error(err);
      alert("Login failed: " + err.message);
    }
  }

  async function handleRegisterEmail() {
    if (!isFirebaseAuthConfigured) {
      return;
    }
    if (regPassword !== regConfirm) {
      alert("Passwords do not match!");
      return;
    }

    try {
      const userCred = await registerEmailPassword(regEmail, regPassword);

      const { data, error } = await supabase
        .from("users")
        .insert([
          {
            email: regEmail,
            firebase_uid: userCred.user.uid,
          }
        ])
        .select()
        .single();

      if (error) throw error;

      setSupabaseUser(data);
      setShowRegister(false);
      navigate("/dashboard");
    } catch (err) {
      console.error(err);
      alert("Registration failed: " + err.message);
    }
  }

  async function handleGoogleLogin() {
    if (!isFirebaseAuthConfigured) {
      return;
    }
    try {
      const userCred = await loginWithGoogle();

      const { data, error } = await supabase
        .from("users")
        .select("*")
        .eq("firebase_uid", userCred.user.uid)
        .single();

      let supabaseData = data;

      if (!supabaseData) {
        const { data: newUser, error: insertError } = await supabase
          .from("users")
          .insert([
            { email: userCred.user.email, firebase_uid: userCred.user.uid }
          ])
          .select()
          .single();

        if (insertError) throw insertError;
        supabaseData = newUser;
      }

      setSupabaseUser(supabaseData);
      setShowLogin(false);
      setShowRegister(false);
      navigate("/dashboard");
    } catch (err) {
      console.error(err);
      alert("Google login failed: " + err.message);
    }
  }

  return (
    <div className="relative w-full min-h-screen bg-background overflow-hidden flex flex-col items-center justify-center">
      <motion.h1
        className="text-5xl font-bold text-primary mb-4 z-10"
        initial={{ opacity: 0, y: -40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1 }}
      >
        Welcome to MathTutor
      </motion.h1>

      <motion.h2
        className="text-2xl text-foreground mb-10 z-10"
        initial={{ opacity: 0, y: -40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1, delay: 0.2 }}
      >
        Your AI-powered math tutor
      </motion.h2>

      {!user && (
        <div className="flex gap-4 z-10">
          <Button size="lg" onClick={() => setShowLogin(true)} disabled={!isFirebaseAuthConfigured}>
            Sign In
          </Button>
          <Button size="lg" variant="outline" onClick={() => setShowRegister(true)} disabled={!isFirebaseAuthConfigured}>
            Register
          </Button>
        </div>
      )}

      {!isFirebaseAuthConfigured && (
        <p className="mt-4 text-destructive text-sm">
          Firebase auth is not configured. Add VITE_FIREBASE_* values in frontend/.env to enable sign-in.
        </p>
      )}

      {/* LOGIN DIALOG */}
      <Dialog open={showLogin} onOpenChange={setShowLogin}>
        <DialogContent className="sm:max-w-md">
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
            <Button onClick={handleLoginEmail}>Sign In</Button>
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
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Create Account</DialogTitle>
            <DialogDescription>Fill in your details to get started.</DialogDescription>
          </DialogHeader>
          <div className="flex flex-col gap-4">
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
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
