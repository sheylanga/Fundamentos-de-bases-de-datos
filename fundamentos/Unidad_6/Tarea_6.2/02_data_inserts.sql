-- =================================================================
-- SCRIPT 02: POBLADO DE DATOS DE PRUEBA (INSERT INTO / LMD)
-- =================================================================

USE BD_Hospital_SQLServer;
GO

-- LIMPIEZA PREVIA EN ORDEN INVERSO DE DEPENDENCIAS
-- (Permite reejecutar el script sin errores de duplicidad de claves primarias)
DELETE FROM PRESCRIPCION_DETALLE;
DELETE FROM MEDICAMENTO;
DELETE FROM CONSULTA_MEDICA;
DELETE FROM PACIENTE_AMBULATORIO;
DELETE FROM PACIENTE_INTERNO;
DELETE FROM ALERGIA_PACIENTE;
DELETE FROM PACIENTE;
DELETE FROM MEDICO;
DELETE FROM TELEFONO_PERSONA;
DELETE FROM PERSONA;
GO

-- 1. Inserción en PERSONA (Superclase Base)
INSERT INTO PERSONA (curp, primer_nombre, ap_paterno, ap_materno, fecha_nacimiento) VALUES
('PERM800101HDFRRL01', 'Carlos', 'Mendoza', 'Rios', '1980-01-01'),
('PERG850512MDFRRL02', 'Elena', 'Gomez', 'Lara', '1985-05-12'),
('PERH900920HDFRRL03', 'Roberto', 'Hernandez', 'Soto', '1990-09-20'),
('PERL950315MDFRRL04', 'Lucia', 'Lopez', 'Vazquez', '1995-03-15'),
('PERR781130HDFRRL05', 'Raul', 'Ramirez', 'Castro', '1978-11-30'),
('PERA020710MDFRRL06', 'Ana', 'Aguilar', 'Morales', '2002-07-10');
GO

-- 2. Inserción en TELEFONO_PERSONA (Atributo Multivalorado)
INSERT INTO TELEFONO_PERSONA (curp_persona, telefono) VALUES
('PERM800101HDFRRL01', '555-111-2233'),
('PERM800101HDFRRL01', '555-111-9988'),
('PERG850512MDFRRL02', '555-222-3344'),
('PERH900920HDFRRL03', '555-333-4455'),
('PERL950315MDFRRL04', '555-444-5566'),
('PERR781130HDFRRL05', '555-555-6677'),
('PERA020710MDFRRL06', '555-666-7788');
GO

-- 3. Inserción en MEDICO (Subclase de PERSONA)
INSERT INTO MEDICO (cedula_profesional, curp, especialidad, sueldo) VALUES
('CED-1001', 'PERM800101HDFRRL01', 'Cardiologia', 45000.00),
('CED-1002', 'PERG850512MDFRRL02', 'Pediatria', 42000.00),
('CED-1003', 'PERR781130HDFRRL05', 'Neurologia', 48000.00);
GO

-- 4. Inserción en PACIENTE (Subclase de PERSONA)
INSERT INTO PACIENTE (num_expediente, curp, tipo_sangre) VALUES
('EXP-2001', 'PERH900920HDFRRL03', 'O+'),
('EXP-2002', 'PERL950315MDFRRL04', 'A+'),
('EXP-2003', 'PERA020710MDFRRL06', 'O-');
GO

-- 5. Inserción en ALERGIA_PACIENTE (Atributo Multivalorado)
INSERT INTO ALERGIA_PACIENTE (num_expediente, alergia) VALUES
('EXP-2001', 'Penicilina'),
('EXP-2001', 'Polen'),
('EXP-2002', 'Aspirina'),
('EXP-2003', 'Mariscos');
GO

-- 6. Inserción en PACIENTE_INTERNO (Especialización)
INSERT INTO PACIENTE_INTERNO (num_expediente, num_cama, fecha_ingreso) VALUES
('EXP-2001', 101, '2026-10-25 08:30:00'),
('EXP-2002', 104, '2026-10-27 14:15:00');
GO

-- 7. Inserción en PACIENTE_AMBULATORIO (Especialización)
INSERT INTO PACIENTE_AMBULATORIO (num_expediente, fecha_proxima_cita) VALUES
('EXP-2003', '2026-11-20');
GO

-- 8. Inserción en CONSULTA_MEDICA (Atención Clínica)
INSERT INTO CONSULTA_MEDICA (id_consulta, cedula_medico, num_expediente, fecha_hora, diagnostico, sintomas) VALUES
('CON-3001', 'CED-1001', 'EXP-2001', '2026-10-26 10:00:00', 'Hipertension Arterial', 'Dolor de cabeza, mareos y fatiga'),
('CON-3002', 'CED-1002', 'EXP-2002', '2026-10-27 11:30:00', 'Infeccion Respiratoria Aguda', 'Fiebre alta, tos seca y dolor de garganta'),
('CON-3003', 'CED-1001', 'EXP-2003', '2026-10-28 09:15:00', 'Arritmia Leve', 'Palpitaciones ocasionales y cansancio');
GO

-- 9. Inserción en MEDICAMENTO (Catálogo de Fármacos)
INSERT INTO MEDICAMENTO (codigo_barras, nombre_comercial, dosis_recomendada) VALUES
('MED-7001', 'Losartan 50mg', '1 tableta cada 24 horas'),
('MED-7002', 'Amoxicilina 500mg', '1 capsula cada 8 horas por 7 dias'),
('MED-7003', 'Paracetamol 500mg', '1 tableta cada 8 horas si presenta fiebre'),
('MED-7004', 'Omeprazol 20mg', '1 capsula diaria en ayunas');
GO

-- 10. Inserción en PRESCRIPCION_DETALLE (Detalle N:M)
INSERT INTO PRESCRIPCION_DETALLE (id_consulta, codigo_barras, indicaciones, cantidad) VALUES
('CON-3001', 'MED-7001', 'Tomar despues del desayuno con abundante agua', 30),
('CON-3002', 'MED-7002', 'Completar el tratamiento de 7 dias sin interrupciones', 21),
('CON-3002', 'MED-7003', 'Solo si presenta fiebre mayor a 38C', 10),
('CON-3003', 'MED-7001', 'Monitorear la presion arterial de forma semanal', 60);
GO