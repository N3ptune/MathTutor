import { Link } from "react-router-dom";
import { auth } from "../firebase";
import { signOut } from "firebase/auth";
import { Button } from "@/components/ui/button";
import {
  Sheet,
  SheetTrigger,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetDescription,
  SheetFooter,
  SheetClose,
} from "@/components/ui/sheet";

export default function Navbar() {
  function handleLogout() {
    signOut(auth).catch((err) => console.error("Logout failed:", err));
  }

  return (
    <>
      <div className="flex items-center gap-3 p-4 bg-primary text-primary-foreground relative z-30">
        <Sheet>
          <SheetTrigger asChild>
            <Button variant="ghost" size="icon" className="text-primary-foreground hover:bg-primary-foreground/10">
              <span className="text-xl">☰</span>
            </Button>
          </SheetTrigger>

          <SheetContent side="left" className="flex flex-col">
            <SheetHeader>
              <SheetTitle>Menu</SheetTitle>
              <SheetDescription className="sr-only">Navigation menu</SheetDescription>
            </SheetHeader>

            <nav className="flex flex-col gap-2 px-4 flex-1">
              <SheetClose asChild>
                <Link
                  to="/dashboard"
                  className="text-foreground font-medium text-base hover:text-primary transition-colors py-2"
                >
                  Dashboard
                </Link>
              </SheetClose>
            </nav>

            <SheetFooter>
              <SheetClose asChild>
                <Button variant="destructive" className="w-full" onClick={handleLogout}>
                  Logout
                </Button>
              </SheetClose>
            </SheetFooter>
          </SheetContent>
        </Sheet>

        <h1 className="text-xl font-bold">Math Tutor</h1>
      </div>
    </>
  );
}
