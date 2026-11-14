-- =================================================================
-- SCRIPT DDL COMPATIBLE CON MICROSOFT SQL SERVER (T-SQL)
-- Ejecutable directamente en SSMS
-- =================================================================

-- 0. Crear base de datos si no existe y usarla
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'hospital_db')
BEGIN
    CREATE DATABASE hospital_db;
END
GO

USE hospital_db;
GO

-- 1. Limpieza de tablas (en orden inverso de dependencias)
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

-- 2. Tabla PERSONA
CREATE TABLE PERSONA (
    curp VARCHAR(18) NOT NULL,
    primer_nombre VARCHAR(50) NOT NULL,
    ap_paterno VARCHAR(50) NOT NULL,
    ap_materno VARCHAR(50) NULL,
    fecha_nacimiento DATE NOT NULL,
    CONSTRAINT pk_persona PRIMARY KEY (curp),
    CONSTRAINT chk_curp_len CHECK (LEN(curp) = 18)
);
GO

-- 3. Tabla TELEFONO_PERSONA
CREATE TABLE TELEFONO_PERSONA (
    id_telefono INT IDENTITY(1,1) NOT NULL,
    curp_persona VARCHAR(18) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    CONSTRAINT pk_telefono PRIMARY KEY (id_telefono),
    CONSTRAINT fk_telefono_persona FOREIGN KEY (curp_persona)
        REFERENCES PERSONA (curp) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 4. Tabla MEDICO
CREATE TABLE MEDICO (
    cedula_profesional VARCHAR(20) NOT NULL,
    curp VARCHAR(18) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (cedula_profesional),
    CONSTRAINT uq_medico_curp UNIQUE (curp),
    CONSTRAINT fk_medico_persona FOREIGN KEY (curp)
        REFERENCES PERSONA (curp) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT chk_medico_sueldo CHECK (sueldo > 0)
);
GO

-- 5. Tabla PACIENTE
CREATE TABLE PACIENTE (
    num_expediente VARCHAR(20) NOT NULL,
    curp VARCHAR(18) NOT NULL,
    tipo_sangre VARCHAR(5) NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (num_expediente),
    CONSTRAINT uq_paciente_curp UNIQUE (curp),
    CONSTRAINT fk_paciente_persona FOREIGN KEY (curp)
        REFERENCES PERSONA (curp) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT chk_paciente_sangre CHECK (tipo_sangre IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);
GO

-- 6. Tabla ALERGIA_PACIENTE
CREATE TABLE ALERGIA_PACIENTE (
    id_alergia INT IDENTITY(1,1) NOT NULL,
    num_expediente VARCHAR(20) NOT NULL,
    alergia VARCHAR(50) NOT NULL,
    CONSTRAINT pk_alergia PRIMARY KEY (id_alergia),
    CONSTRAINT fk_alergia_paciente FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE (num_expediente) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 7. Tabla PACIENTE_INTERNO
CREATE TABLE PACIENTE_INTERNO (
    num_expediente VARCHAR(20) NOT NULL,
    num_cama INT NOT NULL,
    fecha_ingreso DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_paciente_interno PRIMARY KEY (num_expediente),
    CONSTRAINT fk_interno_paciente FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE (num_expediente) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_interno_cama CHECK (num_cama > 0)
);
GO

-- 8. Tabla PACIENTE_AMBULATORIO
CREATE TABLE PACIENTE_AMBULATORIO (
    num_expediente VARCHAR(20) NOT NULL,
    fecha_proxima_cita DATE NULL,
    CONSTRAINT pk_paciente_ambulatorio PRIMARY KEY (num_expediente),
    CONSTRAINT fk_ambulatorio_paciente FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE (num_expediente) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 9. Tabla CONSULTA_MEDICA
CREATE TABLE CONSULTA_MEDICA (
    id_consulta VARCHAR(20) NOT NULL,
    cedula_medico VARCHAR(20) NOT NULL,
    num_expediente VARCHAR(20) NOT NULL,
    fecha_hora DATETIME2 NOT NULL DEFAULT GETDATE(),
    diagnostico NVARCHAR(MAX) NOT NULL,
    sintomas NVARCHAR(MAX) NOT NULL,
    CONSTRAINT pk_consulta_medica PRIMARY KEY (id_consulta),
    CONSTRAINT fk_consulta_medico FOREIGN KEY (cedula_medico)
        REFERENCES MEDICO (cedula_profesional) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE (num_expediente) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 10. Tabla MEDICAMENTO
CREATE TABLE MEDICAMENTO (
    codigo_barras VARCHAR(30) NOT NULL,
    nombre_comercial VARCHAR(100) NOT NULL,
    dosis_recomendada VARCHAR(50) NOT NULL,
    CONSTRAINT pk_medicamento PRIMARY KEY (codigo_barras)
);
GO

-- 11. Tabla PRESCRIPCION_DETALLE
CREATE TABLE PRESCRIPCION_DETALLE (
    id_prescripcion INT IDENTITY(1,1) NOT NULL,
    id_consulta VARCHAR(20) NOT NULL,
    codigo_barras VARCHAR(30) NOT NULL,
    indicaciones NVARCHAR(MAX) NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT pk_prescripcion PRIMARY KEY (id_prescripcion),
    CONSTRAINT fk_prescripcion_consulta FOREIGN KEY (id_consulta)
        REFERENCES CONSULTA_MEDICA (id_consulta) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prescripcion_medicamento FOREIGN KEY (codigo_barras)
        REFERENCES MEDICAMENTO (codigo_barras) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT chk_prescripcion_cantidad CHECK (cantidad > 0)
);
GO