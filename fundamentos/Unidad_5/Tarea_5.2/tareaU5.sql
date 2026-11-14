-- =================================================================
-- SCRIPT CORREGIDO PARA MICROSOFT SQL SERVER EXPRESS (T-SQL)
-- Resuelve Error 1785: Rutas Múltiples de Cascada
-- =================================================================

USE master;
GO

-- 1. REINICIO LIMPIO DE LA BASE DE DATOS
IF DB_ID('BD_Hospital_Algebra') IS NOT NULL
BEGIN
    ALTER DATABASE BD_Hospital_Algebra SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BD_Hospital_Algebra;
END
GO

CREATE DATABASE BD_Hospital_Algebra;
GO

USE BD_Hospital_Algebra;
GO

-- =================================================================
-- FASE 1: DEFINICIÓN DE TABLAS (DDL / LDD)
-- =================================================================

-- 1. Tabla PERSONA (Superclase Base)
CREATE TABLE PERSONA (
    curp VARCHAR(18) NOT NULL,
    primer_nombre VARCHAR(50) NOT NULL,
    ap_paterno VARCHAR(50) NOT NULL,
    ap_materno VARCHAR(50) NULL,
    fecha_nacimiento DATE NOT NULL,
    CONSTRAINT PK_PERSONA PRIMARY KEY (curp),
    CONSTRAINT CHK_CURP_LEN CHECK (LEN(curp) = 18)
);

-- 2. Tabla TELEFONO_PERSONA (Atributo Multivalorado)
CREATE TABLE TELEFONO_PERSONA (
    id_telefono INT IDENTITY(1,1) NOT NULL,
    curp_persona VARCHAR(18) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    CONSTRAINT PK_TELEFONO_PERSONA PRIMARY KEY (id_telefono),
    CONSTRAINT FK_TEL_PERSONA FOREIGN KEY (curp_persona)
        REFERENCES PERSONA(curp) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Tabla MEDICO (Subclase de PERSONA)
CREATE TABLE MEDICO (
    cedula_profesional VARCHAR(20) NOT NULL,
    curp VARCHAR(18) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_MEDICO PRIMARY KEY (cedula_profesional),
    CONSTRAINT UQ_MEDICO_CURP UNIQUE (curp),
    CONSTRAINT FK_MED_PERSONA FOREIGN KEY (curp)
        REFERENCES PERSONA(curp) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT CHK_MED_SUELDO CHECK (sueldo > 0)
);

-- 4. Tabla PACIENTE (Subclase de PERSONA)
CREATE TABLE PACIENTE (
    num_expediente VARCHAR(20) NOT NULL,
    curp VARCHAR(18) NOT NULL,
    tipo_sangre VARCHAR(5) NOT NULL,
    CONSTRAINT PK_PACIENTE PRIMARY KEY (num_expediente),
    CONSTRAINT UQ_PACIENTE_CURP UNIQUE (curp),
    CONSTRAINT FK_PAC_PERSONA FOREIGN KEY (curp)
        REFERENCES PERSONA(curp) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT CHK_PAC_SANGRE CHECK (tipo_sangre IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);

-- 5. Tabla ALERGIA_PACIENTE (Atributo Multivalorado)
CREATE TABLE ALERGIA_PACIENTE (
    id_alergia INT IDENTITY(1,1) NOT NULL,
    num_expediente VARCHAR(20) NOT NULL,
    alergia VARCHAR(50) NOT NULL,
    CONSTRAINT PK_ALERGIA_PACIENTE PRIMARY KEY (id_alergia),
    CONSTRAINT FK_ALERGIA_PACIENTE FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Tabla PACIENTE_INTERNO (Especialización)
CREATE TABLE PACIENTE_INTERNO (
    num_expediente VARCHAR(20) NOT NULL,
    num_cama INT NOT NULL,
    fecha_ingreso DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_PACIENTE_INTERNO PRIMARY KEY (num_expediente),
    CONSTRAINT FK_INTERNO_PACIENTE FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CHK_INTERNO_CAMA CHECK (num_cama > 0)
);

-- 7. Tabla PACIENTE_AMBULATORIO (Especialización)
CREATE TABLE PACIENTE_AMBULATORIO (
    num_expediente VARCHAR(20) NOT NULL,
    fecha_proxima_cita DATE NULL,
    CONSTRAINT PK_PACIENTE_AMBULATORIO PRIMARY KEY (num_expediente),
    CONSTRAINT FK_AMB_PACIENTE FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. Tabla CONSULTA_MEDICA (Atención Clínica)
CREATE TABLE CONSULTA_MEDICA (
    id_consulta VARCHAR(20) NOT NULL,
    cedula_medico VARCHAR(20) NOT NULL,
    num_expediente VARCHAR(20) NOT NULL,
    fecha_hora DATETIME2 NOT NULL DEFAULT GETDATE(),
    diagnostico VARCHAR(MAX) NOT NULL,
    sintomas VARCHAR(MAX) NOT NULL,
    CONSTRAINT PK_CONSULTA_MEDICA PRIMARY KEY (id_consulta),
    CONSTRAINT FK_CONS_MEDICO FOREIGN KEY (cedula_medico)
        REFERENCES MEDICO(cedula_profesional) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_CONS_PACIENTE FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- 9. Tabla MEDICAMENTO (Catálogo de Fármacos)
CREATE TABLE MEDICAMENTO (
    codigo_barras VARCHAR(30) NOT NULL,
    nombre_comercial VARCHAR(100) NOT NULL,
    dosis_recomendada VARCHAR(50) NOT NULL,
    CONSTRAINT PK_MEDICAMENTO PRIMARY KEY (codigo_barras)
);

-- 10. Tabla PRESCRIPCION_DETALLE (Agregación N:M)
CREATE TABLE PRESCRIPCION_DETALLE (
    id_prescripcion INT IDENTITY(1,1) NOT NULL,
    id_consulta VARCHAR(20) NOT NULL,
    codigo_barras VARCHAR(30) NOT NULL,
    indicaciones VARCHAR(MAX) NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT PK_PRESCRIPCION_DETALLE PRIMARY KEY (id_prescripcion),
    CONSTRAINT FK_PRESC_CONSULTA FOREIGN KEY (id_consulta)
        REFERENCES CONSULTA_MEDICA(id_consulta) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT FK_PRESC_MEDICAMENTO FOREIGN KEY (codigo_barras)
        REFERENCES MEDICAMENTO(codigo_barras) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT CHK_PRESC_CANTIDAD CHECK (cantidad > 0)
);
GO

-- =================================================================
-- FASE 2: POBLADO DE DATOS DE PRUEBA (INSERT INTO)
-- =================================================================

INSERT INTO PERSONA (curp, primer_nombre, ap_paterno, ap_materno, fecha_nacimiento) VALUES
('PERM800101HDFRRL01', 'Carlos', 'Mendoza', 'Rios', '1980-01-01'),
('PERG850512MDFRRL02', 'Elena', 'Gomez', 'Lara', '1985-05-12'),
('PERH900920HDFRRL03', 'Roberto', 'Hernandez', 'Soto', '1990-09-20'),
('PERL950315MDFRRL04', 'Lucia', 'Lopez', 'Vazquez', '1995-03-15'),
('PERR781130HDFRRL05', 'Raul', 'Ramirez', 'Castro', '1978-11-30'),
('PERA020710MDFRRL06', 'Ana', 'Aguilar', 'Morales', '2002-07-10');

INSERT INTO TELEFONO_PERSONA (curp_persona, telefono) VALUES
('PERM800101HDFRRL01', '555-111-2233'),
('PERG850512MDFRRL02', '555-222-3344'),
('PERH900920HDFRRL03', '555-333-4455'),
('PERL950315MDFRRL04', '555-444-5566'),
('PERA020710MDFRRL06', '555-666-7788');

INSERT INTO MEDICO (cedula_profesional, curp, especialidad, sueldo) VALUES
('CED-1001', 'PERM800101HDFRRL01', 'Cardiologia', 45000.00),
('CED-1002', 'PERG850512MDFRRL02', 'Pediatria', 42000.00),
('CED-1003', 'PERR781130HDFRRL05', 'Neurologia', 48000.00);

INSERT INTO PACIENTE (num_expediente, curp, tipo_sangre) VALUES
('EXP-2001', 'PERH900920HDFRRL03', 'O+'),
('EXP-2002', 'PERL950315MDFRRL04', 'A+'),
('EXP-2003', 'PERA020710MDFRRL06', 'O-');

INSERT INTO ALERGIA_PACIENTE (num_expediente, alergia) VALUES
('EXP-2001', 'Penicilina'),
('EXP-2001', 'Polen'),
('EXP-2002', 'Aspirina');

INSERT INTO PACIENTE_INTERNO (num_expediente, num_cama, fecha_ingreso) VALUES
('EXP-2001', 101, '2026-10-25 08:00:00'),
('EXP-2002', 104, '2026-10-27 12:30:00');

INSERT INTO PACIENTE_AMBULATORIO (num_expediente, fecha_proxima_cita) VALUES
('EXP-2003', '2026-11-20');

INSERT INTO CONSULTA_MEDICA (id_consulta, cedula_medico, num_expediente, fecha_hora, diagnostico, sintomas) VALUES
('CON-3001', 'CED-1001', 'EXP-2001', '2026-10-26 10:00:00', 'Hipertension', 'Cefalea y mareo'),
('CON-3002', 'CED-1002', 'EXP-2002', '2026-10-27 11:30:00', 'Infeccion Respiratoria', 'Fiebre y tos'),
('CON-3003', 'CED-1001', 'EXP-2003', '2026-10-28 09:15:00', 'Arritmia Leve', 'Palpitaciones');

INSERT INTO MEDICAMENTO (codigo_barras, nombre_comercial, dosis_recomendada) VALUES
('MED-7001', 'Losartan 50mg', '1 tableta diaria'),
('MED-7002', 'Amoxicilina 500mg', '1 cada 8 horas'),
('MED-7003', 'Paracetamol 500mg', '1 cada 8 horas si fiebre');

INSERT INTO PRESCRIPCION_DETALLE (id_consulta, codigo_barras, indicaciones, cantidad) VALUES
('CON-3001', 'MED-7001', 'Tomar en la manana', 30),
('CON-3002', 'MED-7002', 'Tomar con alimentos', 21),
('CON-3002', 'MED-7003', 'Solo si presenta dolor', 10),
('CON-3003', 'MED-7001', 'Control continuo', 60);
GO

-- =================================================================
-- FASE 3: LAS 3 CONSULTAS COMPLEJAS
-- (Selección, Proyecciones Anidadas y Múltiples Joins)
-- =================================================================

-- CONSULTA 1: Recetas emitidas exclusivamente por Cardiología
SELECT 
    Cardiologos.cedula_profesional,
    Cardiologos.nombre_medico,
    Cardiologos.especialidad,
    C.id_consulta,
    C.fecha_hora,
    (PerPac.primer_nombre + ' ' + PerPac.ap_paterno) AS paciente,
    C.diagnostico,
    Med.nombre_comercial,
    Det.cantidad,
    Det.indicaciones
FROM 
    (
        SELECT 
            M.cedula_profesional,
            (P.primer_nombre + ' ' + P.ap_paterno) AS nombre_medico,
            M.especialidad
        FROM MEDICO M
        INNER JOIN PERSONA P ON M.curp = P.curp
        WHERE M.especialidad = 'Cardiologia'
    ) AS Cardiologos
INNER JOIN CONSULTA_MEDICA C ON Cardiologos.cedula_profesional = C.cedula_medico
INNER JOIN PACIENTE Pac ON C.num_expediente = Pac.num_expediente
INNER JOIN PERSONA PerPac ON Pac.curp = PerPac.curp
INNER JOIN PRESCRIPCION_DETALLE Det ON C.id_consulta = Det.id_consulta
INNER JOIN MEDICAMENTO Med ON Det.codigo_barras = Med.codigo_barras;
GO

-- CONSULTA 2: Pacientes alérgicos con recetas de alto volumen (> 20 unidades)
SELECT 
    Pac.num_expediente,
    (Per.primer_nombre + ' ' + Per.ap_paterno) AS nombre_paciente,
    Pac.tipo_sangre,
    A.alergia
FROM PACIENTE Pac
INNER JOIN PERSONA Per ON Pac.curp = Per.curp
INNER JOIN ALERGIA_PACIENTE A ON Pac.num_expediente = A.num_expediente
WHERE Pac.num_expediente IN (
    SELECT C.num_expediente
    FROM CONSULTA_MEDICA C
    INNER JOIN PRESCRIPCION_DETALLE P ON C.id_consulta = P.id_consulta
    WHERE P.cantidad > 20
);
GO

-- CONSULTA 3: Médicos con salario sobre la media y preservación de inactivos
SELECT 
    MedicosTop.cedula_profesional,
    MedicosTop.nombre_medico,
    MedicosTop.especialidad,
    MedicosTop.sueldo,
    ISNULL(C.id_consulta, 'SIN CONSULTAS') AS id_consulta,
    ISNULL(CONVERT(VARCHAR(20), C.fecha_hora, 120), 'N/A') AS fecha_atencion,
    ISNULL(C.diagnostico, 'N/A') AS diagnostico
FROM 
    (
        SELECT 
            M.cedula_profesional,
            (P.primer_nombre + ' ' + P.ap_paterno) AS nombre_medico,
            M.especialidad,
            M.sueldo
        FROM MEDICO M
        INNER JOIN PERSONA P ON M.curp = P.curp
        WHERE M.sueldo > (SELECT AVG(sueldo) FROM MEDICO)
    ) AS MedicosTop
LEFT OUTER JOIN CONSULTA_MEDICA C ON MedicosTop.cedula_profesional = C.cedula_medico
ORDER BY MedicosTop.sueldo DESC;
GO