-- Ескі кестелер бар болса, ?ате шы?пас ?шін оларды ?шіру (кері т?ртіппен)
IF OBJECT_ID('user_progress', 'U') IS NOT NULL DROP TABLE user_progress;
IF OBJECT_ID('lessons', 'U') IS NOT NULL DROP TABLE lessons;
IF OBJECT_ID('courses', 'U') IS NOT NULL DROP TABLE courses;
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE users;
IF OBJECT_ID('roles', 'U') IS NOT NULL DROP TABLE roles;

-- SQL Server Schema for Project
CREATE TABLE roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT FOREIGN KEY REFERENCES roles(role_id),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE courses (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    difficulty_level VARCHAR(20)
);

CREATE TABLE lessons (
    lesson_id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT FOREIGN KEY REFERENCES courses(course_id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    content TEXT
);

CREATE TABLE user_progress (
    progress_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES users(user_id) ON DELETE CASCADE,
    lesson_id INT FOREIGN KEY REFERENCES lessons(lesson_id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'Started',
    score INT CHECK (score >= 0 AND score <= 100)
);

-- Тестілік жазбалар (INSERT)
INSERT INTO roles (role_name) VALUES ('Admin'), ('Student'), ('Teacher');

INSERT INTO users (username, email, password_hash, role_id) VALUES 
('Abdu', 'abdu@example.com', 'hash_123', 2),
('Aruzhan', 'aruzhan@example.com', 'hash_456', 2),
('AdminUser', 'admin@example.com', 'hash_789', 1);

INSERT INTO courses (title, description, difficulty_level) VALUES 
('English Basics', 'Introduction to basic English speaking', 'Beginner'),
('Advanced Grammar', 'Complex grammar rules and structures', 'Advanced');

INSERT INTO lessons (course_id, title, content) VALUES 
(1, 'Greetings and Introductions', 'Learn how to say hello and introduce yourself.'),
(1, 'Daily Routines', 'Talking about your everyday schedule.'),
(2, 'Conditionals', 'First, second, and third conditionals.');

INSERT INTO user_progress (user_id, lesson_id, status, score) VALUES 
(1, 1, 'Completed', 95),
(1, 2, 'In Progress', 70),
(2, 1, 'Completed', 85);

-- 1-ші с?раныс: Кемінде 3 кестені JOIN ар?ылы біріктіру
SELECT 
    u.username, 
    c.title AS course_title, 
    l.title AS lesson_title, 
    up.status, 
    up.score
FROM user_progress up
JOIN users u ON up.user_id = u.user_id
JOIN lessons l ON up.lesson_id = l.lesson_id
JOIN courses c ON l.course_id = c.course_id;

-- 2-ші с?раныс: GROUP BY ?олдану (?р курс бойынша орташа баллды шы?ару)
SELECT 
    c.title AS course_title, 
    AVG(up.score) AS average_score,
    COUNT(up.progress_id) AS total_submissions
FROM user_progress up
JOIN lessons l ON up.lesson_id = l.lesson_id
JOIN courses c ON l.course_id = c.course_id
GROUP BY c.title;
