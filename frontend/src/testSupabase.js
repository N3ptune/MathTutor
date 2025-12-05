import { supabase } from "./supabase.js";

async function testConnection() {
  const { data, error } = await supabase
    .from("public.users")
    .select("*")
    .limit(1);

  if (error) {
    console.error("Supabase fetch failed:", error);
  } else {
    console.log("Supabase connection OK, sample data:", data);
  }
}

testConnection();
