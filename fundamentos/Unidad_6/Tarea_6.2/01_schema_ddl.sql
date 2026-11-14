-- =================================================================
-- SCRIPT 01: DEFINICIÓN DE ESTRUCTURA Y ESQUEMA (DDL / LDD)
-- =================================================================

USE master;
GO

-- 1. REINICIO LIMPIO DE LA BASE DE DATOS
IF DB_ID('BD_Hospital_SQLServer') IS NOT NULL
BEGIN
    ALTER DATABASE BD_Hospital_SQLServer SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BD_Hospital_SQLServer;
END
GO

CREATE DATABASE BD_Hospital_SQLServer;
GO

USE BD_Hospital_SQLServer;
GO

-- =================================================================
-- CREACIÓN DE TABLAS Y RESTRICCIONES DE INTEGRIDAD
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
GO

-- 2. Tabla TELEFONO_PERSONA (Atributo Multivalorado)
CREATE TABLE TELEFONO_PERSONA (
    id_telefono INT IDENTITY(1,1) NOT NULL,
    curp_persona VARCHAR(18) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    CONSTRAINT PK_TELEFONO_PERSONA PRIMARY KEY (id_telefono),
    CONSTRAINT FK_TEL_PERSONA FOREIGN KEY (curp_persona)
        REFERENCES PERSONA(curp) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

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
GO

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
GO

-- 5. Tabla ALERGIA_PACIENTE (Atributo Multivalorado)
CREATE TABLE ALERGIA_PACIENTE (
    id_alergia INT IDENTITY(1,1) NOT NULL,
    num_expediente VARCHAR(20) NOT NULL,
    alergia VARCHAR(50) NOT NULL,
    CONSTRAINT PK_ALERGIA_PACIENTE PRIMARY KEY (id_alergia),
    CONSTRAINT FK_ALERGIA_PACIENTE FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 6. Tabla PACIENTE_INTERNO (Especialización de PACIENTE)
CREATE TABLE PACIENTE_INTERNO (
    num_expediente VARCHAR(20) NOT NULL,
    num_cama INT NOT NULL,
    fecha_ingreso DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_PACIENTE_INTERNO PRIMARY KEY (num_expediente),
    CONSTRAINT FK_INTERNO_PACIENTE FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CHK_INTERNO_CAMA CHECK (num_cama > 0)
);
GO

-- 7. Tabla PACIENTE_AMBULATORIO (Especialización de PACIENTE)
CREATE TABLE PACIENTE_AMBULATORIO (
    num_expediente VARCHAR(20) NOT NULL,
    fecha_proxima_cita DATE NULL,
    CONSTRAINT PK_PACIENTE_AMBULATORIO PRIMARY KEY (num_expediente),
    CONSTRAINT FK_AMB_PACIENTE FOREIGN KEY (num_expediente)
        REFERENCES PACIENTE(num_expediente) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 8. Tabla CONSULTA_MEDICA (Atención Clínica)
-- Configuración anti-ciclos: ON UPDATE NO ACTION y ON DELETE NO ACTION para evitar error 1785
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
GO

-- 9. Tabla MEDICAMENTO (Catálogo Oficial de Fármacos)
CREATE TABLE MEDICAMENTO (
    codigo_barras VARCHAR(30) NOT NULL,
    nombre_comercial VARCHAR(100) NOT NULL,
    dosis_recomendada VARCHAR(50) NOT NULL,
    CONSTRAINT PK_MEDICAMENTO PRIMARY KEY (codigo_barras)
);
GO

-- 10. Tabla PRESCRIPCION_DETALLE (Agregación e Intersección N:M)
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