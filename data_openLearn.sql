INSERT INTO users (name, email, user_password, role) VALUES
('Admin User', 'admin@example.com', 'admin123', 'admin'),
('John Doe', 'johndoe@example.com', 'password123', 'teacher'),
('Jane Smith', 'janesmith@example.com', 'securepass', 'teacher'),
('Alice Brown', 'alicebrown@example.com', 'alicepass', 'student'),
('Bob White', 'bobwhite@example.com', 'bobpass', 'student');

INSERT INTO courses (teacher_id, title, description, subject, duration) VALUES
(2, 'Matemáticas Básicas', 'Curso introductorio de matemáticas', 'Matemáticas', 40),
(2, 'Álgebra Avanzada', 'Profundización en álgebra', 'Matemáticas', 50),
(3, 'Historia del Arte', 'Exploración de las principales corrientes artísticas', 'Arte', 30);

INSERT INTO resources (course_id, name, limit_date, url) VALUES
(1, 'Guía de ejercicios básicos', '2025-06-30', 'http://example.com/matematicas.pdf'),
(1, 'Video: Introducción a las fracciones', '2025-07-15', 'http://example.com/fracciones.mp4'),
(2, 'Libro de álgebra', '2025-08-01', 'http://example.com/algebra.pdf');

INSERT INTO comments (user_id, course_id, publication_date, comment_text, response_id) VALUES
(4, 1, '2025-03-30', '¡Este curso es increíble!', NULL),
(5, 1, '2025-03-31', '¿Alguien puede ayudarme con los ejercicios?', NULL),
(2, 1, '2025-04-01', 'Claro, revisa la guía de ejercicios.', 2);

INSERT INTO inscriptions (user_id, course_id) VALUES
(4, 1),
(4, 2),
(5, 1),
(5, 3);

INSERT INTO certificates (user_id, course_id, ending_date, code) VALUES
(4, 1, '2025-09-01', 'CERT12345'),
(5, 3, '2025-10-10', 'CERT67890');
