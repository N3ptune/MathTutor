-- Drop tables if they exist
DROP TABLE IF EXISTS section;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS problem;
DROP TABLE IF EXISTS "user";

-- Users table
CREATE TABLE "user" (
    userId BIGSERIAL PRIMARY KEY,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

-- Courses table
CREATE TABLE course (
    classId BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    personId BIGINT REFERENCES "user"(userId)
);

-- Sections table
CREATE TABLE section (
    sectionId BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    classId BIGINT REFERENCES course(classId)
);

-- Problems table
CREATE TABLE problem (
    problemId BIGSERIAL PRIMARY KEY,
    problem TEXT NOT NULL
);
