-- =================================================================
-- SCRIPT LDD / DDL: SISTEMA DE INFORMACIÓN HOSPITALARIA (HIS)
-- Motor Target: Microsoft SQL Server (T-SQL)
-- =================================================================

-- 0. Selección / Creación de BD
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'hospital_db')
BEGIN
    CREATE DATABASE hospital_db;
END
GO

USE hospital_db;
GO

-- Limpieza previa opcional
DROP TABLE IF EXISTS PRESCRIPCION_DETALLE;
DROP TABLE IF EXISTS MEDICAMENTO;
DROP TABLE IF EXISTS CONSULTA_MEDICA;
DROP TABLE IF EXISTS PACIENTE_AMBULATORIO;
DROP TABLE IF EXISTS PACIENTE_INTERNO;
DROP TABLE IF EXISTS ALERGIA_PACIENTE;
DROP TABLE IF EXISTS PACIENTE;
DROP TABLE IF EXISTS MEDICO;
DROP TABLE IF EXISTS TELEFONO_PERSONA;
DROP TABLE IF EXISTS PERSONA;
GO

-- 1. Tabla PERSONA (Superclase)
CREATE TABLE PERSONA (
    curp VARCHAR(18) NOT NULL,
    primer_nombre VARCHAR(50) NOT NULL,
    ap_paterno VARCHAR(50) NOT NULL,
    ap_materno VARCHAR(50) NULL,
    fecha_nacimiento DATE NOT NULL,
    CONSTRAINT pk_persona PRIMARY KEY (curp),
    CONSTRAINT chk_curp_longitud CHECK (LEN(curp) = 18)
);
GO

-- 2. Tabla TELEFONO_PERSONA
CREATE TABLE TELEFONO_PERSONA (
    id_telefono INT IDENTITY(1,1) NOT NULL,
    curp_persona VARCHAR(18) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    CONSTRAINT pk_telefono_persona PRIMARY KEY (id_telefono),
    CONSTRAINT fk_telefono_persona FOREIGN KEY (curp_persona)
        REFERENCES PERSONA(curp) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 3. Tabla MEDICO
CREATE TABLE MEDICO (
    cedula_profesional VARCHAR(20) NOT NULL,
    curp VARCHAR(18) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (cedula_profesional),
    CONSTRAINT uq_medico_curp UNIQUE (curp),
    CONSTRAINT fk_medico_persona FOREIGN KEY (curp)
        REFERENCES PERSONA(curp) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT chk_medico_sueldo CHECK (sueldo > 0)
);
GO

-- 4. Tabla PACIENTE
CREATE TABLE PACIENTE (
    num_expediente VARCHAR(20) NOT NULL,
    curp VARCHAR(18) NOT NULL,
    tipo_sangre VARCHAR(5) NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (num_expediente),
    CONSTRAINT uq_paciente_curp UNIQUE (curp),
    CONSTRAINT fk_paciente_persona FOREIGN KEY (curp)
        REFERENCES PERSONA(curp) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT chk_paciente_sangre CHECK (tipo_sangre IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);
GO

-- 5. Tabla ALERGIA_PACIENTE
CREATE TABLE ALERGIA_PACIENTE (
    id_alergia INT IDENTITY(1,1) NOT NULL,
    num_expediente VARCHAR(20) NOT NULL,
    alergia VARCHAR(50) NOT NULL,
    CONSTRAINT pk_alergia_paciente PRIMARY KEY (id_alergia),
    CONSTRAINT fk_alergia_paciente FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 6. Tabla PACIENTE_INTERNO
CREATE TABLE PACIENTE_INTERNO (
    num_expediente VARCHAR(20) NOT NULL,
    num_cama INT NOT NULL,
    fecha_ingreso DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_paciente_interno PRIMARY KEY (num_expediente),
    CONSTRAINT fk_interno_paciente FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_interno_cama CHECK (num_cama > 0)
);
GO

-- 7. Tabla PACIENTE_AMBULATORIO
CREATE TABLE PACIENTE_AMBULATORIO (
    num_expediente VARCHAR(20) NOT NULL,
    fecha_proxima_cita DATE NULL,
    CONSTRAINT pk_paciente_ambulatorio PRIMARY KEY (num_expediente),
    CONSTRAINT fk_ambulatorio_paciente FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 8. Tabla CONSULTA_MEDICA
CREATE TABLE CONSULTA_MEDICA (
    id_consulta VARCHAR(20) NOT NULL,
    cedula_medico VARCHAR(20) NOT NULL,
    num_expediente VARCHAR(20) NOT NULL,
    fecha_hora DATETIME2 NOT NULL DEFAULT GETDATE(),
    diagnostico NVARCHAR(MAX) NOT NULL,
    sintomas NVARCHAR(MAX) NOT NULL,
    CONSTRAINT pk_consulta_medica PRIMARY KEY (id_consulta),
    CONSTRAINT fk_consulta_medico FOREIGN KEY (cedula_medico)
        REFERENCES MEDICO(cedula_profesional) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 9. Tabla MEDICAMENTO
CREATE TABLE MEDICAMENTO (
    codigo_barras VARCHAR(30) NOT NULL,
    nombre_comercial VARCHAR(100) NOT NULL,
    dosis_recomendada VARCHAR(50) NOT NULL,
    CONSTRAINT pk_medicamento PRIMARY KEY (codigo_barras)
);
GO

-- 10. Tabla PRESCRIPCION_DETALLE
CREATE TABLE PRESCRIPCION_DETALLE (
    id_prescripcion INT IDENTITY(1,1) NOT NULL,
    id_consulta VARCHAR(20) NOT NULL,
    codigo_barras VARCHAR(30) NOT NULL,
    indicaciones NVARCHAR(MAX) NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT pk_prescripcion_detalle PRIMARY KEY (id_prescripcion),
    CONSTRAINT fk_prescripcion_consulta FOREIGN KEY (id_consulta)
        REFERENCES CONSULTA_MEDICA(id_consulta) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prescripcion_medicamento FOREIGN KEY (codigo_barras)
        REFERENCES MEDICAMENTO(codigo_barras) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT chk_prescripcion_cantidad CHECK (cantidad > 0)
);
GO

-- =================================================================
-- Inserción de Datos de Prueba (DML)
-- =================================================================

-- Médico
INSERT INTO PERSONA (curp, primer_nombre, ap_paterno, ap_materno, fecha_nacimiento)
VALUES ('MECJ850101HDFRRL01', 'Juan', 'Mendoza', 'Cruz', '1985-01-01');

INSERT INTO MEDICO (cedula_profesional, curp, especialidad, sueldo)
VALUES ('MED-1001', 'MECJ850101HDFRRL01', 'Cardiología', 35000.00);

-- Paciente
INSERT INTO PERSONA (curp, primer_nombre, ap_paterno, ap_materno, fecha_nacimiento)
VALUES ('GARA920512MDFRR002', 'Ana', 'García', 'Ríos', '1992-05-12');

INSERT INTO PACIENTE (num_expediente, curp, tipo_sangre)
VALUES ('EXP-2024-001', 'GARA920512MDFRR002', 'O+');

-- Consulta Médica
INSERT INTO CONSULTA_MEDICA (id_consulta, cedula_medico, num_expediente, fecha_hora, diagnostico, sintomas)
VALUES ('CNS-001', 'MED-1001', 'EXP-2024-001', SYSDATETIME(), 'Hipertensión Arterial', 'Cefalea y mareo');
GO

-- =================================================================
-- B. Prueba de Fallo por Restricción CHECK (Sueldo Negativo)
-- =================================================================
-- Registramos una persona válida para no violar la FK ni la UNIQUE KEY
INSERT INTO PERSONA (curp, primer_nombre, ap_paterno, ap_materno, fecha_nacimiento)
VALUES ('TEST990101HDFRRL99', 'Prueba', 'Sueldo', 'Check', '1999-01-01');

BEGIN TRY
    -- Intentamos registrar al médico con sueldo negativo
    INSERT INTO MEDICO (cedula_profesional, curp, especialidad, sueldo)
    VALUES ('MED-9999', 'TEST990101HDFRRL99', 'Pediatría', -5000.00);
END TRY
BEGIN CATCH
    PRINT 'Prueba Sueldo Negativo: ' + ERROR_MESSAGE();
END CATCH;
GO


-- =================================================================
-- C. Prueba de Fallo por Restricción CHECK (Tipo de Sangre Inválido)
-- =================================================================
-- Registramos otra persona válida para la prueba de paciente
INSERT INTO PERSONA (curp, primer_nombre, ap_paterno, ap_materno, fecha_nacimiento)
VALUES ('TEST880202MDFRR088', 'Prueba', 'Sangre', 'Check', '1988-02-02');

BEGIN TRY
    -- Intentamos registrar un tipo de sangre no admitido ('Z+')
    INSERT INTO PACIENTE (num_expediente, curp, tipo_sangre)
    VALUES ('EXP-999', 'TEST880202MDFRR088', 'Z+');
END TRY
BEGIN CATCH
    PRINT 'Prueba Tipo Sangre Inválido: ' + ERROR_MESSAGE();
END CATCH;
GO
-- Visualización de resultados
SELECT * FROM PERSONA;
SELECT * FROM MEDICO;
SELECT * FROM PACIENTE;
SELECT * FROM CONSULTA_MEDICA;
GO