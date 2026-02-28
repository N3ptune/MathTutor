import { useEffect, useState, useContext } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabase.js";
import { AuthState } from "../authState.jsx";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";

export default function Course() {
  const { courseId } = useParams();
  const navigate = useNavigate();
  const { supabaseUser } = useContext(AuthState);

  const [sections, setSections] = useState([]);
  const [courseName, setCourseName] = useState("");

  useEffect(() => {
    if (!supabaseUser) return;

    async function fetchCourseAndSections() {
      try {
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
      } catch (err) {
        console.error("Failed to fetch course or sections:", err);
      }
    }

    fetchCourseAndSections();
  }, [supabaseUser, courseId]);

  return (
    <div className="max-w-6xl mx-auto px-6 py-10">
      <Button variant="ghost" size="sm" className="mb-4" onClick={() => navigate("/dashboard")}>
        <ArrowLeft className="size-4" />
        Back to Dashboard
      </Button>
      <h1 className="text-3xl font-bold mb-8">{courseName}</h1>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {sections.length > 0 ? (
          sections.map((section) => (
            <Card key={section.sectionId}>
              <CardHeader>
                <CardTitle>{section.name}</CardTitle>
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
          ))
        ) : (
          <p className="col-span-full text-center text-muted-foreground">No sections available for this course.</p>
        )}
      </div>
    </div>
  );
}
