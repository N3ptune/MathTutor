-- Drop tables if they exist
DROP TABLE IF EXISTS proficiency_exam_response;
DROP TABLE IF EXISTS proficiency_exam_attempt;
DROP TABLE IF EXISTS proficiency_exam_question;
DROP TABLE IF EXISTS proficiency;
DROP TABLE IF EXISTS user_problem_attempt;
DROP TABLE IF EXISTS user_course;
DROP TABLE IF EXISTS section;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS problem;
DROP TABLE IF EXISTS users;

-- Users table
CREATE TABLE users (
    userId BIGSERIAL PRIMARY KEY,
    firstName TEXT DEFAULT '',
    lastName TEXT DEFAULT '',
    email TEXT NOT NULL UNIQUE,
    auth_uid TEXT UNIQUE -- Supabase auth UID
);

-- Courses table
CREATE TABLE course (
    courseId BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    personId BIGINT REFERENCES users(userId)
);

-- Sections table
CREATE TABLE section (
    sectionId BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    courseId BIGINT REFERENCES course(courseId)
);

-- Problems table
CREATE TABLE problem (
    problemId BIGSERIAL PRIMARY KEY,
    problem TEXT NOT NULL,
    sectionId BIGINT REFERENCES section(sectionId),
    -- "course" problems are the shared, AI-generated-per-section catalog everyone in the
    -- course sees; "user" problems are a student's own extra practice, visible only to them.
    source TEXT NOT NULL DEFAULT 'course' CHECK (source IN ('course', 'user')),
    createdBy BIGINT REFERENCES users(userId)
);

-- Enrollments: which users are registered for which courses
CREATE TABLE user_course (
    userId BIGINT NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
    courseId BIGINT NOT NULL REFERENCES course(courseId) ON DELETE CASCADE,
    PRIMARY KEY (userId, courseId)
);

-- One row per graded problem attempt. AI assigns a 0-100 proficiencyRating for the attempt,
-- which feeds the rolling proficiency score for that problem's section.
CREATE TABLE user_problem_attempt (
    attemptId BIGSERIAL PRIMARY KEY,
    userId BIGINT NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
    problemId BIGINT NOT NULL REFERENCES problem(problemId) ON DELETE CASCADE,
    isCorrect BOOLEAN NOT NULL,
    proficiencyRating REAL NOT NULL,
    aiFeedback TEXT,
    createdAt TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- A user's current proficiency for a section. rating is the share of the section's course
-- problems answered correctly, scaled to at most 95 until the section's exam is passed (examPassed).
CREATE TABLE proficiency (
    proficiencyId BIGSERIAL PRIMARY KEY,
    userId BIGINT NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
    sectionId BIGINT NOT NULL REFERENCES section(sectionId) ON DELETE CASCADE,
    rating REAL NOT NULL DEFAULT 0,
    examPassed BOOLEAN NOT NULL DEFAULT false,
    updatedAt TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (userId, sectionId)
);

-- Bank of AI-generated mastery-exam questions per section. A subset is sampled per attempt.
CREATE TABLE proficiency_exam_question (
    examQuestionId BIGSERIAL PRIMARY KEY,
    sectionId BIGINT NOT NULL REFERENCES section(sectionId) ON DELETE CASCADE,
    question TEXT NOT NULL,
    createdAt TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- One row per exam attempt (a sampled set of questions, graded together).
CREATE TABLE proficiency_exam_attempt (
    examAttemptId BIGSERIAL PRIMARY KEY,
    userId BIGINT NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
    sectionId BIGINT NOT NULL REFERENCES section(sectionId) ON DELETE CASCADE,
    score REAL,
    passed BOOLEAN NOT NULL DEFAULT false,
    startedAt TIMESTAMPTZ NOT NULL DEFAULT now(),
    completedAt TIMESTAMPTZ
);

CREATE TABLE proficiency_exam_response (
    examResponseId BIGSERIAL PRIMARY KEY,
    examAttemptId BIGINT NOT NULL REFERENCES proficiency_exam_attempt(examAttemptId) ON DELETE CASCADE,
    userId BIGINT NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
    examQuestionId BIGINT NOT NULL REFERENCES proficiency_exam_question(examQuestionId),
    studentAnswer TEXT,
    isCorrect BOOLEAN,
    aiFeedback TEXT
);
