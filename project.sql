-- Crear esquema de la base de datos
CREATE SCHEMA `proyecto_sql`;

-- Crear tabla Estudiantes
CREATE TABLE `proyecto_sql`.`estudiantes` (
  `id_estudiantes` INT NOT NULL AUTO_INCREMENT,
  `nombres_estudiantes` VARCHAR(100) NOT NULL,
  `apellidos_estudiantes` VARCHAR(100) NOT NULL,
  `fecha_nacimiento` DATE NOT NULL,
  PRIMARY KEY (`id_estudiantes`),
  UNIQUE INDEX `id_estudiantes_UNIQUE` (`id_estudiantes` ASC) VISIBLE
);

-- Crear tabla Profesores
CREATE TABLE `proyecto_sql`.`profesores` (
  `id_profesores` INT NOT NULL AUTO_INCREMENT,
  `nombres_profesores` VARCHAR(100) NOT NULL,
  `apellidos_profesores` VARCHAR(100) NOT NULL,
  `departamento_profesores` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_profesores`),
  UNIQUE INDEX `id_profesores_UNIQUE` (`id_profesores` ASC) VISIBLE
);

-- Crear tabla Cursos
CREATE TABLE `proyecto_sql`.`cursos` (
  `id_cursos` INT NOT NULL AUTO_INCREMENT,
  `nombre_curso` VARCHAR(100) NOT NULL,
  `descripcion_curso` TEXT NOT NULL,
  `id_profesores` INT NOT NULL,
  PRIMARY KEY (`id_cursos`),
  UNIQUE INDEX `id_cursos_UNIQUE` (`id_cursos` ASC) VISIBLE,
  INDEX `fk_profesores_idx` (`id_profesores` ASC) VISIBLE,
  CONSTRAINT `fk_profesores`
    FOREIGN KEY (`id_profesores`)
    REFERENCES `proyecto_sql`.`profesores` (`id_profesores`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Crear tabla Calificaciones
CREATE TABLE `proyecto_sql`.`calificaciones` (
  `id_calificaciones` INT NOT NULL AUTO_INCREMENT,
  `id_estudiantes` INT NOT NULL,
  `id_cursos` INT NOT NULL,
  `calificacion` DECIMAL(4,2) NOT NULL,
  `fecha_calificacion` DATE NOT NULL,
  PRIMARY KEY (`id_calificaciones`),
  UNIQUE INDEX `id_calificaciones_UNIQUE` (`id_calificaciones` ASC) VISIBLE,
  INDEX `fk_estudiantes_idx` (`id_estudiantes` ASC) VISIBLE,
  INDEX `fk_cursos_idx` (`id_cursos` ASC) VISIBLE,
  CONSTRAINT `fk_estudiantes`
    FOREIGN KEY (`id_estudiantes`)
    REFERENCES `proyecto_sql`.`estudiantes` (`id_estudiantes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cursos`
    FOREIGN KEY (`id_cursos`)
    REFERENCES `proyecto_sql`.`cursos` (`id_cursos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Insertar datos en la tabla Profesores
INSERT INTO `proyecto_sql`.`profesores` (nombres_profesores, apellidos_profesores, departamento_profesores)
VALUES
('Juan', 'Pérez', 'Matemáticas'),
('Ana', 'García', 'Ciencias'),
('Carlos', 'López', 'Historia');

-- Insertar datos en la tabla Cursos
INSERT INTO `proyecto_sql`.`cursos` (nombre_curso, descripcion_curso, id_profesores)
VALUES
('Álgebra', 'Curso básico de álgebra', 1),
('Física', 'Introducción a la física', 2),
('Historia Moderna', 'Historia del siglo XIX', 3);

-- Insertar datos en la tabla Estudiantes
INSERT INTO `proyecto_sql`.`estudiantes` (nombres_estudiantes, apellidos_estudiantes, fecha_nacimiento)
VALUES
('Luis', 'Martínez', '2000-05-15'),
('María', 'Fernández', '1999-08-22'),
('Pedro', 'Gómez', '2001-02-10');

-- Insertar datos en la tabla Calificaciones
INSERT INTO `proyecto_sql`.`calificaciones` (id_estudiantes, id_cursos, calificacion, fecha_calificacion)
VALUES
(1, 1, 85.50, '2023-06-10'),
(1, 2, 90.00, '2023-06-15'),
(2, 1, 88.00, '2023-06-10'),
(2, 3, 92.00, '2023-06-20'),
(3, 3, 77.50, '2023-06-20');

-- Consulta a: Nota media que otorga cada profesor
SELECT P.nombres_profesores, P.apellidos_profesores, AVG(Cal.calificacion) AS nota_media
FROM `proyecto_sql`.`profesores` P
JOIN `proyecto_sql`.`cursos` Cu ON P.id_profesores = Cu.id_profesores
JOIN `proyecto_sql`.`calificaciones` Cal ON Cu.id_cursos = Cal.id_cursos
GROUP BY P.id_profesores, P.nombres_profesores, P.apellidos_profesores;

-- Consulta b: Mejores notas de cada estudiante
SELECT E.nombres_estudiantes, E.apellidos_estudiantes, MAX(Cal.calificacion) AS mejor_nota
FROM `proyecto_sql`.`estudiantes` E
JOIN `proyecto_sql`.`calificaciones` Cal ON E.id_estudiantes = Cal.id_estudiantes
GROUP BY E.id_estudiantes, E.nombres_estudiantes, E.apellidos_estudiantes;

-- Consulta c: Ordenar a los estudiantes por los cursos en los que están inscritos
SELECT E.nombres_estudiantes, E.apellidos_estudiantes, Cu.nombre_curso
FROM `proyecto_sql`.`estudiantes` E
JOIN `proyecto_sql`.`calificaciones` Cal ON E.id_estudiantes = Cal.id_estudiantes
JOIN `proyecto_sql`.`cursos` Cu ON Cal.id_cursos = Cu.id_cursos
ORDER BY E.nombres_estudiantes, E.apellidos_estudiantes, Cu.nombre_curso;

-- Consulta d: Informe de los cursos con calificaciones promedio, ordenados de más difícil a más fácil
SELECT Cu.nombre_curso, AVG(Cal.calificacion) AS calificacion_promedio
FROM `proyecto_sql`.`cursos` Cu
JOIN `proyecto_sql`.`calificaciones` Cal ON Cu.id_cursos = Cal.id_cursos
GROUP BY Cu.id_cursos, Cu.nombre_curso
ORDER BY calificacion_promedio ASC;

-- Consulta e: Estudiante y profesor con más cursos en común
SELECT E.nombres_estudiantes AS estudiante, E.apellidos_estudiantes, P.nombres_profesores AS profesor, P.apellidos_profesores, COUNT(Cu.id_cursos) AS cursos_en_comun
FROM `proyecto_sql`.`estudiantes` E
JOIN `proyecto_sql`.`calificaciones` Cal ON E.id_estudiantes = Cal.id_estudiantes
JOIN `proyecto_sql`.`cursos` Cu ON Cal.id_cursos = Cu.id_cursos
JOIN `proyecto_sql`.`profesores` P ON Cu.id_profesores = P.id_profesores
GROUP BY E.id_estudiantes, P.id_profesores
ORDER BY cursos_en_comun DESC
LIMIT 1;
