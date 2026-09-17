-- Drop tables if they exist
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
    problem TEXT NOT NULL
);

-- Enrollments: which users are registered for which courses
CREATE TABLE user_course (
    userId BIGINT NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
    courseId BIGINT NOT NULL REFERENCES course(courseId) ON DELETE CASCADE,
    PRIMARY KEY (userId, courseId)
);
