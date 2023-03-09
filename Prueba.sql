####SCRIPT DE CREACION####
CREATE DATABASE PRUEBA;

USE PRUEBA;

CREATE TABLE DEPARTAMENTO (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE PROFESOR(
ID_PROFESOR INT NOT NULL UNIQUE,
NOMBRE VARCHAR(50),
SALARIO FLOAT,
PRIMARY KEY(ID_PROFESOR)
);

CREATE TABLE DEPARTAMENTO_PROFESOR(
ID_DEPARTAMENTO INT NOT NULL,
ID_PROFESOR INT NOT NULL,
PRIMARY KEY(ID_DEPARTAMENTO, ID_PROFESOR),
UNIQUE(ID_DEPARTAMENTO, ID_PROFESOR),
FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO),
FOREIGN KEY (ID_PROFESOR) REFERENCES PROFESOR(ID_PROFESOR)
);

CREATE TABLE CURSO(
ID_CURSO INT NOT NULL UNIQUE,
NOMBRE VARCHAR(50)
);

CREATE TABLE ASIGNATURA(
ID_ASIGNATURA INT NOT NULL UNIQUE,
NOMBRE VARCHAR(50) NOT NULL,
ID_DEPARTAMENTO INT,
CREDITO INT,
ID_CURSO INT,
FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO),
FOREIGN KEY (ID_CURSO) REFERENCES CURSO(ID_CURSO)
);

CREATE TABLE PROFESOR_IMPARTE(
ID_ASIGNATURA INT NOT NULL,
ID_PROFESOR INT NOT NULL,
PRIMARY KEY(ID_ASIGNATURA, ID_PROFESOR),
UNIQUE(ID_ASIGNATURA, ID_PROFESOR),
FOREIGN KEY (ID_ASIGNATURA) REFERENCES ASIGNATURA(ID_ASIGNATURA),
FOREIGN KEY(ID_PROFESOR) REFERENCES PROFESOR(ID_PROFESOR)
);

CREATE TABLE ALUMNO(
ID_ALUMNO INT NOT NULL UNIQUE,
NOMBRE VARCHAR(50) NOT NULL,
ID_CURSO INT,
CREDITO INT,
FOREIGN KEY (ID_CURSO) REFERENCES CURSO(ID_CURSO),
PRIMARY KEY(ID_ALUMNO)
);

CREATE TABLE ASIGNATURAS_CURSADAS(
ID_ASIGNATURA INT NOT NULL,
ID_ALUMNO INT NOT NULL,
NOTA FLOAT,
PRIMARY KEY (ID_ASIGNATURA, ID_ALUMNO),
UNIQUE(ID_ASIGNATURA, ID_ALUMNO),
FOREIGN KEY(ID_ASIGNATURA) REFERENCES ASIGNATURA(ID_ASIGNATURA),
FOREIGN KEY(ID_ALUMNO) REFERENCES ALUMNO(ID_ALUMNO)
);
#############################
####INSERCCIÓN DE DATOS####
INSERT INTO DEPARTAMENTO(nombre) VALUES ('Ciencias de la Computación');
INSERT INTO DEPARTAMENTO(nombre) VALUES ('Matemáticas');
INSERT INTO DEPARTAMENTO(nombre) VALUES ('Física');

INSERT INTO PROFESOR(ID_PROFESOR, NOMBRE, SALARIO) VALUES (1, 'Juan', 2500);
INSERT INTO PROFESOR(ID_PROFESOR, NOMBRE, SALARIO) VALUES (2, 'Maria', 2800);
INSERT INTO PROFESOR(ID_PROFESOR, NOMBRE, SALARIO) VALUES (3, 'Carlos', 3000);
INSERT INTO PROFESOR(ID_PROFESOR, NOMBRE, SALARIO) VALUES (4, 'Ana', 2700);

INSERT INTO DEPARTAMENTO_PROFESOR(ID_DEPARTAMENTO, ID_PROFESOR) VALUES (1, 1);
INSERT INTO DEPARTAMENTO_PROFESOR(ID_DEPARTAMENTO, ID_PROFESOR) VALUES (2, 2);
INSERT INTO DEPARTAMENTO_PROFESOR(ID_DEPARTAMENTO, ID_PROFESOR) VALUES (3, 3);
INSERT INTO DEPARTAMENTO_PROFESOR(ID_DEPARTAMENTO, ID_PROFESOR) VALUES (1, 4);
INSERT INTO DEPARTAMENTO_PROFESOR(ID_DEPARTAMENTO, ID_PROFESOR) VALUES (2, 1);
INSERT INTO DEPARTAMENTO_PROFESOR(ID_DEPARTAMENTO, ID_PROFESOR) VALUES (2, 4);

INSERT INTO CURSO(ID_CURSO, NOMBRE) VALUES (1, 'Programación 101');
INSERT INTO CURSO(ID_CURSO, NOMBRE) VALUES (2, 'Matemáticas 101');
INSERT INTO CURSO(ID_CURSO, NOMBRE) VALUES (3, 'Física 101');

INSERT INTO ASIGNATURA(ID_ASIGNATURA, NOMBRE, ID_DEPARTAMENTO, CREDITO, ID_CURSO) VALUES (1, 'Introducción a la programación', 1, 4, 1);
INSERT INTO ASIGNATURA(ID_ASIGNATURA, NOMBRE, ID_DEPARTAMENTO, CREDITO, ID_CURSO) VALUES (2, 'Arquitectura de Computadores.', 1, 15, 1);
INSERT INTO ASIGNATURA(ID_ASIGNATURA, NOMBRE, ID_DEPARTAMENTO, CREDITO, ID_CURSO) VALUES (3, 'Cálculo Infinitesimal I', 2, 14, 2);
INSERT INTO ASIGNATURA(ID_ASIGNATURA, NOMBRE, ID_DEPARTAMENTO, CREDITO, ID_CURSO) VALUES (4, 'Álgebra lineal', 2, 3, 2);
INSERT INTO ASIGNATURA(ID_ASIGNATURA, NOMBRE, ID_DEPARTAMENTO, CREDITO, ID_CURSO) VALUES (5, 'Física clásica', 3, 5, 3);
INSERT INTO ASIGNATURA(ID_ASIGNATURA, NOMBRE, ID_DEPARTAMENTO, CREDITO, ID_CURSO) VALUES (6, 'Física Computacional II', 3, 15, 3);

INSERT INTO PROFESOR_IMPARTE(ID_ASIGNATURA, ID_PROFESOR) VALUES (1, 1);
INSERT INTO PROFESOR_IMPARTE(ID_ASIGNATURA, ID_PROFESOR) VALUES (3, 1);
INSERT INTO PROFESOR_IMPARTE(ID_ASIGNATURA, ID_PROFESOR) VALUES (2, 2);
INSERT INTO PROFESOR_IMPARTE(ID_ASIGNATURA, ID_PROFESOR) VALUES (3, 3);
INSERT INTO PROFESOR_IMPARTE(ID_ASIGNATURA, ID_PROFESOR) VALUES (3, 4);

INSERT INTO ALUMNO(ID_ALUMNO, NOMBRE, ID_CURSO, CREDITO) VALUES (1, 'Luis', 1, 100);
INSERT INTO ALUMNO(ID_ALUMNO, NOMBRE, ID_CURSO, CREDITO) VALUES (2, 'Ana', 2, 85);
INSERT INTO ALUMNO(ID_ALUMNO, NOMBRE, ID_CURSO, CREDITO) VALUES (3, 'Pedro', 3, 40);

INSERT INTO ASIGNATURAS_CURSADAS(ID_ASIGNATURA, ID_ALUMNO, NOTA) VALUES (1, 1, 8.5);
INSERT INTO ASIGNATURAS_CURSADAS(ID_ASIGNATURA, ID_ALUMNO, NOTA) VALUES (2, 1, 9);
INSERT INTO ASIGNATURAS_CURSADAS(ID_ASIGNATURA, ID_ALUMNO, NOTA) VALUES (1, 3, 7.5);
INSERT INTO ASIGNATURAS_CURSADAS(ID_ASIGNATURA, ID_ALUMNO, NOTA) VALUES (3, 2, 9.5);
###############
##CONSULTAS##
#Obtener el alumno con mas creditos cursados
SELECT AL.NOMBRE , AL.CREDITO
FROM ALUMNO AS AL
    ORDER BY AL.CREDITO DESC
    LIMIT 1;

#Asignaturas que cursa cada alumno
SELECT  asg.NOMBRE AS ASIGNATURAS_CURSADAS, AL.NOMBRE AS NOMBRE_ALUMNO
FROM ALUMNO AS AL
INNER JOIN asignaturas_cursadas as aCURSADA on AL.ID_ALUMNO = aCURSADA.ID_ALUMNO
        INNER JOIN asignatura as asg on asg.ID_ASIGNATURA = aCURSADA.ID_ASIGNATURA;
 

#Asignaturas que componen cada curso.
SELECT ASG.NOMBRE AS ASIGNATURAS_CURSOS, CRS.NOMBRE AS CURSO_ASIGNATURA
FROM CURSO AS CRS
    INNER JOIN ASIGNATURA AS ASG ON ASG.ID_CURSO = CRS.ID_CURSO;
   
#Consulta para obtener todas las asignaturas que imparte un profesor
SELECT ASG.NOMBRE AS NOMBRE_ASIGNATURA
FROM PROFESOR AS PRF
    INNER JOIN PROFESOR_IMPARTE AS P_IMPARTE ON PRF.ID_PROFESOR = P_IMPARTE.ID_PROFESOR
    INNER JOIN ASIGNATURA AS ASG ON ASG.ID_ASIGNATURA = P_IMPARTE.ID_ASIGNATURA
WHERE PRF.ID_PROFESOR = 1;
   
#Consulta para actualizar notas de un determinado alumno
UPDATE ASIGNATURAS_CURSADAS
SET NOTA = 7.8
WHERE ID_ALUMNO = 3
AND ID_ASIGNATURA = 1;

#CONSULTAMOS TODOS LOS DEPARTAMENTOS CON SUS PROFESORES CORRESPONDIENTES
SELECT DPT.NOMBRE AS NOMBRE_DEPARTAMENTO, PRF.NOMBRE AS NOMBRE_PROFESOR
FROM DEPARTAMENTO AS DPT
LEFT JOIN DEPARTAMENTO_PROFESOR AS DPT_PRF ON DPT_PRF.ID_DEPARTAMENTO = DPT.ID_DEPARTAMENTO
LEFT JOIN PROFESOR AS PRF ON PRF.ID_PROFESOR = DPT_PRF.ID_PROFESOR;

 
 #CONSULTAMOS TODAS LAS ASIGNATURAS CON SUS ALUMNOS CORRESPONDIENTES
 SELECT ASG.NOMBRE AS NOMBRE_ASIGNATURA, AL.NOMBRE AS NOMBRE_ALUMNO
FROM ASIGNATURA AS ASG
LEFT JOIN ASIGNATURAS_CURSADAS AS ASG_CURSADA ON ASG_CURSADA.ID_ASIGNATURA = ASG.ID_ASIGNATURA
LEFT JOIN ALUMNO AS AL ON AL.ID_ALUMNO = ASG_CURSADA.ID_ALUMNO;
 
 
#UTILIZACION DE GROUP BY Y HAVING PARA OBTENER LAS NOTAS MEDIAS DEL CURSO QUE SEAN SUPERIORES 8
SELECT CRS.NOMBRE, AVG(ASG_CURSADA.NOTA) AS MEDIA_CURSO
FROM CURSO AS CRS
INNER JOIN ALUMNO AS AL ON AL.ID_CURSO = CRS.ID_CURSO
INNER JOIN ASIGNATURAS_CURSADAS AS ASG_CURSADA ON ASG_CURSADA.ID_ALUMNO = AL.ID_ALUMNO
GROUP BY CRS.NOMBRE
HAVING AVG(ASG_CURSADA.NOTA) > 8
ORDER BY MEDIA_CURSO DESC;


#OBTENER TODAS LAS ASIGNATURAS DE UN PROFESOR (CONSULTA DONDE ME FALTO EL NOMBRE DEL PROFESOR)
drop procedure if exists ASIGNATURAS_PROFESOR;
delimiter $$
create procedure ASIGNATURAS_PROFESOR(ID_PROFESOR integer)
begin
SELECT PRF.NOMBRE AS NOMBRE_PROFESOR, ASG.NOMBRE AS NOMBRE_ASIGNATURA
FROM PROFESOR AS PRF
INNER JOIN PROFESOR_IMPARTE AS P_IMPARTE ON PRF.ID_PROFESOR = P_IMPARTE.ID_PROFESOR
INNER JOIN ASIGNATURA AS ASG ON ASG.ID_ASIGNATURA = P_IMPARTE.ID_ASIGNATURA
WHERE PRF.ID_PROFESOR = ID_PROFESOR
ORDER BY PRF.NOMBRE;
         end
    $$
   
call ASIGNATURAS_PROFESOR(3);