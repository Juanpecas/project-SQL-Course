-- Crear tabla Estudiantes
CREATE TABLE Estudiantes (
    estudiante_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    fecha_nacimiento DATE
);

-- Crear tabla Profesores
CREATE TABLE Profesores (
    profesor_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    departamento VARCHAR(100)
);

-- Crear tabla Cursos
CREATE TABLE Cursos (
    curso_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_curso VARCHAR(100),
    descripcion TEXT,
    profesor_id INT,
    FOREIGN KEY (profesor_id) REFERENCES Profesores(profesor_id)
);

-- Crear tabla Calificaciones
CREATE TABLE Calificaciones (
    calificacion_id INT PRIMARY KEY AUTO_INCREMENT,
    estudiante_id INT,
    curso_id INT,
    calificacion DECIMAL(4,2),
    fecha DATE,
    FOREIGN KEY (estudiante_id) REFERENCES Estudiantes(estudiante_id),
    FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id)
);

-- Insertar datos en la tabla Profesores
INSERT INTO Profesores (nombre, apellido, departamento)
VALUES
('Juan', 'Pérez', 'Matemáticas'),
('Ana', 'García', 'Ciencias'),
('Carlos', 'López', 'Historia');

-- Insertar datos en la tabla Cursos
INSERT INTO Cursos (nombre_curso, descripcion, profesor_id)
VALUES
('Álgebra', 'Curso básico de álgebra', 1),
('Física', 'Introducción a la física', 2),
('Historia Moderna', 'Historia del siglo XIX', 3);

-- Insertar datos en la tabla Estudiantes
INSERT INTO Estudiantes (nombre, apellido, fecha_nacimiento)
VALUES
('Luis', 'Martínez', '2000-05-15'),
('María', 'Fernández', '1999-08-22'),
('Pedro', 'Gómez', '2001-02-10');

-- Insertar datos en la tabla Calificaciones
INSERT INTO Calificaciones (estudiante_id, curso_id, calificacion, fecha)
VALUES
(1, 1, 85.50, '2023-06-10'),
(1, 2, 90.00, '2023-06-15'),
(2, 1, 88.00, '2023-06-10'),
(2, 3, 92.00, '2023-06-20'),
(3, 3, 77.50, '2023-06-20');

-- Consulta a: Nota media que otorga cada profesor
SELECT P.nombre, P.apellido, AVG(Cal.calificacion) AS nota_media
FROM Profesores P
JOIN Cursos Cu ON P.profesor_id = Cu.profesor_id
JOIN Calificaciones Cal ON Cu.curso_id = Cal.curso_id
GROUP BY P.profesor_id, P.nombre, P.apellido;

-- Consulta b: Mejores notas de cada estudiante
SELECT E.nombre, E.apellido, MAX(Cal.calificacion) AS mejor_nota
FROM Estudiantes E
JOIN Calificaciones Cal ON E.estudiante_id = Cal.estudiante_id
GROUP BY E.estudiante_id, E.nombre, E.apellido;

-- Consulta c: Ordenar a los estudiantes por los cursos en los que están inscritos
SELECT E.nombre, E.apellido, Cu.nombre_curso
FROM Estudiantes E
JOIN Calificaciones Cal ON E.estudiante_id = Cal.estudiante_id
JOIN Cursos Cu ON Cal.curso_id = Cu.curso_id
ORDER BY E.nombre, E.apellido, Cu.nombre_curso;

-- Consulta d: Informe de los cursos con calificaciones promedio, ordenados de más difícil a más fácil
SELECT Cu.nombre_curso, AVG(Cal.calificacion) AS calificacion_promedio
FROM Cursos Cu
JOIN Calificaciones Cal ON Cu.curso_id = Cal.curso_id
GROUP BY Cu.curso_id, Cu.nombre_curso
ORDER BY calificacion_promedio ASC;

-- Consulta e: Estudiante y profesor con más cursos en común
SELECT E.nombre AS estudiante, E.apellido AS apellido_estudiante, P.nombre AS profesor, P.apellido AS apellido_profesor, COUNT(Cu.curso_id) AS cursos_en_comun
FROM Estudiantes E
JOIN Calificaciones Cal ON E.estudiante_id = Cal.estudiante_id
JOIN Cursos Cu ON Cal.curso_id = Cu.curso_id
JOIN Profesores P ON Cu.profesor_id = P.profesor_id
GROUP BY E.estudiante_id, P.profesor_id
ORDER BY cursos_en_comun DESC
LIMIT 1;
