-- Inserción de datos en la tabla Usuario
INSERT INTO Usuario (username, email, password, is_active, is_superuser) VALUES
('jdoe', 'jdoe@gmail.com', 'password123', TRUE, FALSE),
('asmith', 'asmith@gmail.com', 'password456', TRUE, FALSE),
('tparent', 'tparent@gmail.com', 'password789', TRUE, FALSE);

-- Inserción de datos en la tabla Profesor
INSERT INTO Profesor (ID_usuario) VALUES
(1), -- jdoe
(2); -- asmith

-- Inserción de datos en la tabla Apoderado
INSERT INTO Apoderado (ID_usuario) VALUES
(3); -- tparent

-- Inserción de datos en la tabla Alumno
INSERT INTO Alumno (ID_usuario, tutor) VALUES
(4, 3), -- Nuevo alumno con tparent como tutor
(5, 3); -- Otro alumno con tparent como tutor

-- Inserción de datos en la tabla Tokens
INSERT INTO Tokens (ID_usuario, token_autenticacion, dead_time_token_autenticacion) VALUES
(1, 1234567890, '2024-12-31 23:59:59'),
(2, 2345678901, '2024-12-31 23:59:59');

-- Inserción de datos en la tabla Asignatura
INSERT INTO Asignatura (nombre) VALUES
('Matemáticas'),
('Historia'),
('Ciencias');

-- Inserción de datos en la tabla Anuncio
INSERT INTO Anuncio (titulo, contenido, last_updated, ID_profesor) VALUES
('Inicio de Clases', 'Las clases comienzan el lunes', '2024-08-01', 1),
('Reunión de Apoderados', 'Reunión programada para el viernes', '2024-08-02', 2);

-- Inserción de datos en la tabla AnuncioAsignatura
INSERT INTO AnuncioAsignatura (ID_anuncio, ID_asignatura) VALUES
(1, 1), -- Anuncio relacionado con Matemáticas
(2, 2); -- Anuncio relacionado con Historia

-- Inserción de datos en la tabla Material
INSERT INTO Material (ID_asignatura, ID_profesor, titulo, descripcion, archivo, fecha_publicacion) VALUES
(1, 1, 'Guía de Álgebra', 'Material de apoyo para el curso de álgebra', NULL, '2024-08-01'),
(2, 2, 'Historia de Chile', 'Documentos sobre la independencia de Chile', NULL, '2024-08-02');

-- Inserción de datos en la tabla Evaluacion
INSERT INTO Evaluacion (ID_asignatura, titulo, descripcion, fecha_inicio, fecha_termino, tipo) VALUES
(1, 'Prueba de Álgebra', 'Primera prueba del semestre', '2024-08-10 08:00:00', '2024-08-10 10:00:00', 'Evaluacion'),
(2, 'Ensayo sobre la Independencia', 'Ensayo crítico', '2024-08-15 08:00:00', '2024-08-15 10:00:00', 'Trabajo escrito');

-- Inserción de datos en la tabla AsignaturaEvaluacion
INSERT INTO AsignaturaEvaluacion (ID_evaluacion, ID_asignatura) VALUES
(1, 1), -- Prueba de Álgebra para Matemáticas
(2, 2); -- Ensayo para Historia

-- Inserción de datos en la tabla Calificacion
INSERT INTO Calificacion (ID_evaluacion, ID_usuario, comentario, calificacion) VALUES
(1, 4, 'Buen trabajo', 6.5),
(2, 5, 'Necesita mejorar', 4.0);

-- Inserción de datos en la tabla Asistencia
INSERT INTO Asistencia (ID_alumno, dia, jornada, estado) VALUES
(4, '2024-08-07', 'AM', 'P'),
(5, '2024-08-07', 'AM', 'A');

-- Inserción de datos en la tabla Justificacion
INSERT INTO Justificacion (ID_apoderado, mensaje, certificado, fecha_justificacion) VALUES
(3, 'Enfermedad', TRUE, '2024-08-08 08:00:00');

-- Inserción de datos en la tabla AsistenciaJustificacion
INSERT INTO AsistenciaJustificacion (ID_asistencia, ID_justificacion) VALUES
(2, 1); -- Relaciona la ausencia del alumno 5 con la justificación de enfermedad

-- Inserción de datos en la tabla RegistroAsignatura
INSERT INTO RegistroAsignatura (ID_asignatura, ID_usuario) VALUES
(1, 1), -- jdoe es responsable de Matemáticas
(2, 2); -- asmith es responsable de Historia

-- Inserción de datos en la tabla ProfesorApoderado
INSERT INTO ProfesorApoderado (ID_profesor, ID_apoderado) VALUES
(1, 3); -- jdoe es también apoderado
