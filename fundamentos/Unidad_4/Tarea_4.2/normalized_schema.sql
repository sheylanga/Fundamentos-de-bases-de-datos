USE hospital_db;
GO

-- Limpieza si existe previamente
DROP TABLE IF EXISTS REGISTRO_HOSPITALARIO_DESNORMALIZADO;
GO

-- Creación de la tabla no normalizada (0FN)
CREATE TABLE REGISTRO_HOSPITALARIO_DESNORMALIZADO (
    -- Datos del Paciente
    num_expediente VARCHAR(20) NOT NULL,
    curp_paciente VARCHAR(18) NOT NULL,
    nombre_paciente VARCHAR(150) NOT NULL,
    fecha_nac_paciente DATE NOT NULL,
    tipo_sangre VARCHAR(5) NOT NULL,
    
    -- Atributos Multivaluados (sin normalizar)
    telefonos_paciente NVARCHAR(MAX) NULL,   -- e.g. '866-123-4567, 866-987-6543'
    alergias_paciente NVARCHAR(MAX) NULL,    -- e.g. 'Penicilina, Sulfas'

    -- Datos de la Consulta Médica
    id_consulta VARCHAR(20) NOT NULL,
    fecha_hora_consulta DATETIME2 NOT NULL DEFAULT GETDATE(),
    diagnostico NVARCHAR(MAX) NOT NULL,
    sintomas NVARCHAR(MAX) NOT NULL,

    -- Datos del Médico
    cedula_medico VARCHAR(20) NOT NULL,
    curp_medico VARCHAR(18) NOT NULL,
    nombre_medico VARCHAR(150) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    sueldo_medico DECIMAL(10,2) NOT NULL,

    -- Grupo Repetitivo: Medicamentos prescritos (almacenado en formato JSON)
    medicamentos_prescritos NVARCHAR(MAX) NULL
    /*
      Estructura JSON del grupo repetitivo:
      [
        {
          "codigo_barras_med": "75010001",
          "nombre_med": "Paracetamol 500mg",
          "dosis_rec": "1 tableta cada 8 hrs",
          "cantidad": 20,
          "indicaciones": "Tomar después de los alimentos"
        }
      ]
    */
);
GO

-- Ejemplo de inserción de un registro desnormalizado
INSERT INTO REGISTRO_HOSPITALARIO_DESNORMALIZADO (
    num_expediente, curp_paciente, nombre_paciente, fecha_nac_paciente, tipo_sangre,
    telefonos_paciente, alergias_paciente,
    id_consulta, fecha_hora_consulta, diagnostico, sintomas,
    cedula_medico, curp_medico, nombre_medico, especialidad, sueldo_medico,
    medicamentos_prescritos
)
VALUES (
    'EXP-2024-001', 'GARA920512MDFRR002', 'Ana García Ríos', '1992-05-12', 'O+',
    '8661112233, 8664445566', 'Penicilina',
    'CNS-001', SYSDATETIME(), 'Hipertensión Arterial', 'Cefalea y mareo',
    'MED-1001', 'MECJ850101HDFRRL01', 'Juan Mendoza Cruz', 'Cardiología', 35000.00,
    '[
        {"codigo_barras_med": "MED-PAR-500", "nombre_med": "Paracetamol 500mg", "dosis_rec": "500mg", "cantidad": 20, "indicaciones": "Tomar cada 8 horas por 5 días"},
        {"codigo_barras_med": "MED-LOS-050", "nombre_med": "Losartán 50mg", "dosis_rec": "50mg", "cantidad": 30, "indicaciones": "Tomar 1 tableta cada 24 horas"}
    ]'
);
GO

SELECT * FROM REGISTRO_HOSPITALARIO_DESNORMALIZADO;
GO

-- NORMALIZADO
USE hospital_db;
GO

-- 0. Limpieza previa de tablas
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

-- 1. Tabla PERSONA
CREATE TABLE PERSONA (
    curp VARCHAR(18) NOT NULL,
    primer_nombre VARCHAR(50) NOT NULL,
    ap_paterno VARCHAR(50) NOT NULL,
    ap_materno VARCHAR(50) NULL,
    fecha_nacimiento DATE NOT NULL,
    CONSTRAINT pk_persona PRIMARY KEY (curp),
    CONSTRAINT chk_curp CHECK (LEN(curp) = 18)
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
        REFERENCES MEDICAMENTO(codigo_barras) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT chk_prescripcion_cantidad CHECK (cantidad > 0)
);
GO
