import { useState, useContext } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import ProficiencyRing from "@/components/ProficiencyRing";
import LoadingOverlay from "@/components/LoadingOverlay";
import ErrorMessage from "@/components/ErrorMessage";
import { usePageLoad } from "@/lib/usePageLoad";

export default function Course() {
  const { courseId } = useParams();
  const navigate = useNavigate();
  const { supabaseUser } = useContext(AuthState);

  const [sections, setSections] = useState([]);
  const [courseName, setCourseName] = useState("");
  const [proficiencyBySection, setProficiencyBySection] = useState({});

  const { loading, error: loadError, retry } = usePageLoad(async () => {
    const { data: courseData, error: courseError } = await supabase
      .from("course")
      .select("name")
      .eq("courseId", courseId)
      .single();

    if (courseError) throw courseError;

    setCourseName(courseData.name);

    const { data: sectionData, error: sectionError } = await supabase
      .from("section")
      .select("*")
      .eq("courseId", courseId)
      .order("sectionId", { ascending: true });

    if (sectionError) throw sectionError;

    setSections(sectionData);

    const sectionIds = (sectionData || []).map((s) => s.sectionId);
    if (sectionIds.length > 0) {
      const { data: profData, error: profError } = await supabase
        .from("proficiency")
        .select("sectionId, rating, examPassed")
        .eq("userId", supabaseUser.userId)
        .in("sectionId", sectionIds);

      if (profError) throw profError;

      const bySection = {};
      for (const row of profData || []) {
        bySection[row.sectionId] = row;
      }
      setProficiencyBySection(bySection);
    }
  }, [supabaseUser, courseId], Boolean(supabaseUser));

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      <LoadingOverlay show={loading} message="Loading class..." />

      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate("/dashboard")}>
        <ArrowLeft className="size-4" />
        Back to Dashboard
      </Button>
      <h1 className="text-2xl sm:text-3xl font-bold mb-8">{courseName}</h1>
      {loadError && <ErrorMessage message={loadError} onRetry={retry} className="mb-6" />}

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {loading || loadError ? null : sections.length > 0 ? (
          sections.map((section) => {
            const proficiency = proficiencyBySection[section.sectionId];
            return (
              <Card key={section.sectionId}>
                <CardHeader className="flex flex-row items-center justify-between gap-4">
                  <CardTitle>{section.name}</CardTitle>
                  <ProficiencyRing
                    rating={proficiency?.rating || 0}
                    examPassed={proficiency?.examPassed || false}
                    size={56}
                    strokeWidth={6}
                  />
                </CardHeader>
                <CardContent>
                  <Button
                    className="w-full"
                    onClick={() => navigate(`/section/${section.sectionId}`)}
                  >
                    Go to Section
                  </Button>
                </CardContent>
              </Card>
            );
          })
        ) : (
          <p className="col-span-full text-center text-muted-foreground">No sections available for this course.</p>
        )}
      </div>
    </div>
  );
}
