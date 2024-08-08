-- Creación de la base de datos
CREATE DATABASE sistema_educativo;
USE sistema_educativo;

-- Creación de las tablas

CREATE TABLE Usuario (
    ID_usuario INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_active BOOLEAN,
    is_superuser BOOLEAN
);

CREATE TABLE Profesor (
    ID_usuario INTEGER NOT NULL PRIMARY KEY,
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Apoderado (
    ID_usuario INTEGER NOT NULL PRIMARY KEY,
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Alumno (
    ID_usuario INTEGER NOT NULL PRIMARY KEY,
    tutor INTEGER NOT NULL,
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario),
    FOREIGN KEY (tutor) REFERENCES Apoderado(ID_usuario)
);

CREATE TABLE Tokens (
    ID_usuario INTEGER NOT NULL,
    token_autenticacion INTEGER NOT NULL PRIMARY KEY,
    dead_time_token_autenticacion DATETIME NOT NULL,
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Asignatura (
    ID_asignatura INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255)
);

CREATE TABLE Anuncio (
    ID_anuncio INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido VARCHAR(255) NOT NULL,
    last_updated VARCHAR(255) NOT NULL,
    ID_profesor INTEGER NOT NULL,
    FOREIGN KEY (ID_profesor) REFERENCES Profesor(ID_usuario)
);

CREATE TABLE AnuncioAsignatura (
    ID_anuncio INTEGER NOT NULL,
    ID_asignatura INTEGER NOT NULL,
    PRIMARY KEY (ID_anuncio, ID_asignatura),
    FOREIGN KEY (ID_anuncio) REFERENCES Anuncio(ID_anuncio),
    FOREIGN KEY (ID_asignatura) REFERENCES Asignatura(ID_asignatura)
);

CREATE TABLE Material (
    ID_material INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_asignatura INTEGER NOT NULL,
    ID_profesor INTEGER NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255),
    archivo LONGBLOB,
    fecha_publicacion DATETIME,
    FOREIGN KEY (ID_asignatura) REFERENCES Asignatura(ID_asignatura),
    FOREIGN KEY (ID_profesor) REFERENCES Profesor(ID_usuario)
);

CREATE TABLE Evaluacion (
    ID_evaluacion INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_asignatura INTEGER NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255),
    fecha_inicio DATETIME,
    fecha_termino DATETIME,
    tipo ENUM('Evaluacion', 'Trabajo escrito', 'Presentacion oral'),
    FOREIGN KEY (ID_asignatura) REFERENCES Asignatura(ID_asignatura)
);

CREATE TABLE AsignaturaEvaluacion (
    ID_evaluacion INTEGER NOT NULL,
    ID_asignatura INTEGER NOT NULL,
    PRIMARY KEY (ID_evaluacion, ID_asignatura),
    FOREIGN KEY (ID_evaluacion) REFERENCES Evaluacion(ID_evaluacion),
    FOREIGN KEY (ID_asignatura) REFERENCES Asignatura(ID_asignatura)
);

CREATE TABLE Calificacion (
    ID_calificacion INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_evaluacion INTEGER NOT NULL,
    ID_usuario INTEGER NOT NULL,
    comentario VARCHAR(255),
    calificacion FLOAT,
    FOREIGN KEY (ID_evaluacion) REFERENCES Evaluacion(ID_evaluacion),
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Asistencia (
    ID_asistencia INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_alumno INTEGER NOT NULL,
    dia DATE,
    jornada ENUM('AM', 'PM'),
    estado ENUM('P', 'A', 'R'),
    FOREIGN KEY (ID_alumno) REFERENCES Alumno(ID_usuario)
);

CREATE TABLE Justificacion (
    ID_justificacion INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_apoderado INTEGER NOT NULL,
    mensaje VARCHAR(255),
    certificado BOOLEAN,
    fecha_justificacion DATETIME,
    FOREIGN KEY (ID_apoderado) REFERENCES Apoderado(ID_usuario)
);

CREATE TABLE AsistenciaJustificacion (
    ID_asistencia INTEGER NOT NULL,
    ID_justificacion INTEGER NOT NULL,
    PRIMARY KEY (ID_asistencia, ID_justificacion),
    FOREIGN KEY (ID_asistencia) REFERENCES Asistencia(ID_asistencia),
    FOREIGN KEY (ID_justificacion) REFERENCES Justificacion(ID_justificacion)
);

CREATE TABLE RegistroAsignatura (
    ID_registro INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_asignatura INTEGER NOT NULL,
    ID_usuario INTEGER NOT NULL,
    FOREIGN KEY (ID_asignatura) REFERENCES Asignatura(ID_asignatura),
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario)
);

CREATE TABLE ProfesorApoderado (
    ID_profesor INTEGER NOT NULL,
    ID_apoderado INTEGER NOT NULL,
    PRIMARY KEY (ID_profesor, ID_apoderado),
    FOREIGN KEY (ID_profesor) REFERENCES Profesor(ID_usuario),
    FOREIGN KEY (ID_apoderado) REFERENCES Apoderado(ID_usuario)
);

-- Creación de vistas

CREATE VIEW VistaCalificacionesAlumnos AS
SELECT
    Alumno.ID_usuario AS ID_Alumno,
    Usuario.username AS Nombre_Alumno,
    Asignatura.nombre AS Nombre_Asignatura,
    Evaluacion.titulo AS Evaluacion,
    Calificacion.calificacion AS Calificacion,
    Calificacion.comentario AS Comentario,
    Profesor.ID_usuario AS ID_Profesor,
    (SELECT username FROM Usuario WHERE Usuario.ID_usuario = Profesor.ID_usuario) AS Nombre_Profesor
FROM
    Calificacion
    INNER JOIN Alumno ON Calificacion.ID_usuario = Alumno.ID_usuario
    INNER JOIN Evaluacion ON Calificacion.ID_evaluacion = Evaluacion.ID_evaluacion
    INNER JOIN Asignatura ON Evaluacion.ID_asignatura = Asignatura.ID_asignatura
    INNER JOIN RegistroAsignatura ON Asignatura.ID_asignatura = RegistroAsignatura.ID_asignatura
    INNER JOIN Profesor ON RegistroAsignatura.ID_usuario = Profesor.ID_usuario;

CREATE VIEW VistaAsistenciaAlumnos AS
SELECT
    Alumno.ID_usuario AS ID_Alumno,
    Usuario.username AS Nombre_Alumno,
    Asistencia.dia AS Dia,
    Asistencia.jornada AS Jornada,
    Asistencia.estado AS Estado,
    Justificacion.mensaje AS Justificacion
FROM
    Asistencia
    LEFT JOIN Justificacion ON Asistencia.ID_asistencia = AsistenciaJustificacion.ID_asistencia
    LEFT JOIN AsistenciaJustificacion ON Justificacion.ID_justificacion = AsistenciaJustificacion.ID_justificacion
    INNER JOIN Alumno ON Asistencia.ID_alumno = Alumno.ID_usuario
    INNER JOIN Usuario ON Alumno.ID_usuario = Usuario.ID_usuario;

-- Creación de funciones

CREATE FUNCTION CalcularPromedioAlumno(ID_Alumno INTEGER)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE promedio FLOAT;
    SELECT AVG(calificacion) INTO promedio
    FROM Calificacion
    WHERE ID_usuario = ID_Alumno;
    RETURN promedio;
END;

CREATE FUNCTION ObtenerEstadoAsistencia(ID_Alumno INTEGER, Fecha DATE)
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
    DECLARE estado_asistencia VARCHAR(2);
    SELECT estado INTO estado_asistencia
    FROM Asistencia
    WHERE ID_alumno = ID_Alumno AND dia = Fecha;
    RETURN estado_asistencia;
END;

-- Creación de stored procedures

CREATE PROCEDURE RegistrarCalificacion(
    IN ID_Evaluacion INTEGER,
    IN ID_Usuario INTEGER,
    IN Comentario VARCHAR(255),
    IN Calificacion FLOAT
)
BEGIN
    INSERT INTO Calificacion (ID_evaluacion, ID_usuario, comentario, calificacion)
    VALUES (ID_Evaluacion, ID_Usuario, Comentario, Calificacion);
END;

CREATE PROCEDURE ActualizarAsistencia(
    IN ID_Asistencia INTEGER,
    IN Estado ENUM('P', 'A', 'R')
)
BEGIN
    UPDATE Asistencia
    SET estado = Estado
    WHERE ID_asistencia = ID_Asistencia;
END;

-- Creación de triggers

CREATE TRIGGER ActualizarFechaUltimaModificacionAnuncio
AFTER UPDATE ON Anuncio
FOR EACH ROW
BEGIN
    SET NEW.last_updated = CURRENT_TIMESTAMP;
END;

CREATE TRIGGER AntesDeInsertarCalificacion
BEFORE INSERT ON Calificacion
FOR EACH ROW
BEGIN
    IF NEW.calificacion < 1 OR NEW.calificacion > 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La calificación debe estar entre 1 y 7.';
    END IF;
END;