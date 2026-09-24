import { motion } from "framer-motion";

// An SVG ring showing proficiency (0-100) as a filled arc, with the percentage centered.
// Turns the "mastered" color once the section's proficiency exam has been passed.
export default function ProficiencyRing({
  rating = 0,
  examPassed = false,
  size = 96,
  strokeWidth = 10,
  label,
}) {
  const clamped = Math.max(0, Math.min(100, rating));
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const filled = (clamped / 100) * circumference;
  const fillColor = examPassed ? "var(--chart-2)" : "var(--primary)";

  return (
    <div className="flex flex-col items-center gap-1">
      <div className="relative" style={{ width: size, height: size }}>
        <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} className="-rotate-90">
          <circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            fill="none"
            stroke="var(--muted)"
            strokeWidth={strokeWidth}
          />
          <motion.circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            fill="none"
            stroke={fillColor}
            strokeWidth={strokeWidth}
            strokeLinecap="round"
            strokeDasharray={circumference}
            initial={{ strokeDashoffset: circumference }}
            animate={{ strokeDashoffset: circumference - filled }}
            transition={{ duration: 0.8, ease: "easeOut" }}
          />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-lg font-semibold">{Math.round(clamped)}%</span>
        </div>
      </div>
      {label && <span className="text-sm text-muted-foreground text-center">{label}</span>}
      {examPassed && <span className="text-xs font-medium" style={{ color: "var(--chart-2)" }}>Mastered</span>}
    </div>
  );
}
