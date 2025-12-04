-- Insert sample users
INSERT INTO "user" (firstName, lastName, email)
VALUES
('John', 'Doe', 'john@example.com')
ON CONFLICT DO NOTHING;

-- Insert sample courses
INSERT INTO course (name, personId)
VALUES
('Algebra 1', 1)
ON CONFLICT DO NOTHING;

-- Insert sample sections
INSERT INTO section (name, classId)
VALUES
('Linear Equations', 1)
ON CONFLICT DO NOTHING;

-- Insert sample problems
INSERT INTO problem (problem)
VALUES
('2x + 3 = 7'),
('x^2 - 4 = 0')
ON CONFLICT DO NOTHING;
