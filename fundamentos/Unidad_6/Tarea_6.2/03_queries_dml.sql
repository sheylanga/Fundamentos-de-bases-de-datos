-- =================================================================
-- SCRIPT 03: CONSULTAS LMD Y OPERACIONES DE MANTENIMIENTO
-- =================================================================

USE BD_Hospital_SQLServer;
GO

-- =================================================================
-- SECCIÓN A: LAS 3 CONSULTAS COMPLEJAS DE EVALUACIÓN
-- (Requisito: Selección, Proyecciones Anidadas y Múltiples Joins)
-- =================================================================

-- -----------------------------------------------------------------
-- CONSULTA COMPLEJA 1:
-- Requerimiento: Historial integral de recetas emitidas exclusivamente
-- por médicos de la especialidad 'Cardiologia'.
--   • Proyección Anidada con Selección Previa: Subconsulta 'Cardiologos'.
--   • Selección (σ): WHERE M.especialidad = 'Cardiologia'.
--   • Joins (⋈): Encadenamiento de 6 tablas clínicas.
-- -----------------------------------------------------------------
PRINT '=== CONSULTA COMPLEJA 1: RECETAS DE CARDIOLOGÍA ===';
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
    -- 1. PROYECCIÓN ANIDADA con SELECCIÓN (σ) PREVIA
    (
        SELECT 
            M.cedula_profesional,
            (P.primer_nombre + ' ' + P.ap_paterno) AS nombre_medico,
            M.especialidad
        FROM MEDICO M
        INNER JOIN PERSONA P ON M.curp = P.curp
        WHERE M.especialidad = 'Cardiologia'  -- SELECCIÓN (σ)
    ) AS Cardiologos
-- 2. REUNIONES (JOINS ⋈) MÚLTIPLES
INNER JOIN CONSULTA_MEDICA C ON Cardiologos.cedula_profesional = C.cedula_medico
INNER JOIN PACIENTE Pac ON C.num_expediente = Pac.num_expediente
INNER JOIN PERSONA PerPac ON Pac.curp = PerPac.curp
INNER JOIN PRESCRIPCION_DETALLE Det ON C.id_consulta = Det.id_consulta
INNER JOIN MEDICAMENTO Med ON Det.codigo_barras = Med.codigo_barras;
GO

-- -----------------------------------------------------------------
-- CONSULTA COMPLEJA 2:
-- Requerimiento: Identificar pacientes con alergias registradas que
-- han recibido al menos una prescripción de alto volumen (> 20 unidades).
--   • Proyección Anidada: Subconsulta WHERE ... IN (SELECT C.num_expediente ...).
--   • Selección (σ): WHERE P.cantidad > 20.
--   • Joins (⋈): Unión de PACIENTE con PERSONA y ALERGIA_PACIENTE.
-- -----------------------------------------------------------------
PRINT '=== CONSULTA COMPLEJA 2: PACIENTES ALÉRGICOS CON ALTO VOLUMEN ===';
SELECT 
    Pac.num_expediente,
    (Per.primer_nombre + ' ' + Per.ap_paterno) AS nombre_paciente,
    Pac.tipo_sangre,
    A.alergia
FROM PACIENTE Pac
INNER JOIN PERSONA Per ON Pac.curp = Per.curp
INNER JOIN ALERGIA_PACIENTE A ON Pac.num_expediente = A.num_expediente
WHERE Pac.num_expediente IN (
    -- PROYECCIÓN ANIDADA con SELECCIÓN (σ)
    SELECT C.num_expediente
    FROM CONSULTA_MEDICA C
    INNER JOIN PRESCRIPCION_DETALLE P ON C.id_consulta = P.id_consulta
    WHERE P.cantidad > 20  -- SELECCIÓN (σ)
);
GO

-- -----------------------------------------------------------------
-- CONSULTA COMPLEJA 3:
-- Requerimiento: Médicos con sueldo superior a la media hospitalaria,
-- mostrando sus consultas o 'SIN CONSULTAS' si no tienen atenciones.
--   • Selección Escalar Anidada (σ): WHERE M.sueldo > (SELECT AVG(sueldo) FROM MEDICO).
--   • Proyección Anidada: Subconsulta derivada 'MedicosTop'.
--   • Reunión Externa (⟕): LEFT OUTER JOIN para preservar médicos sin consultas.
-- -----------------------------------------------------------------
PRINT '=== CONSULTA COMPLEJA 3: MÉDICOS CON SUELDO SOBRE LA MEDIA ===';
SELECT 
    MedicosTop.cedula_profesional,
    MedicosTop.nombre_medico,
    MedicosTop.especialidad,
    MedicosTop.sueldo,
    ISNULL(C.id_consulta, 'SIN CONSULTAS') AS id_consulta,
    ISNULL(CONVERT(VARCHAR(20), C.fecha_hora, 120), 'N/A') AS fecha_atencion,
    ISNULL(C.diagnostico, 'N/A') AS diagnostico
FROM 
    -- 1. PROYECCIÓN ANIDADA con SELECCIÓN ESCALAR
    (
        SELECT 
            M.cedula_profesional,
            (P.primer_nombre + ' ' + P.ap_paterno) AS nombre_medico,
            M.especialidad,
            M.sueldo
        FROM MEDICO M
        INNER JOIN PERSONA P ON M.curp = P.curp
        WHERE M.sueldo > (SELECT AVG(sueldo) FROM MEDICO) -- SELECCIÓN ANIDADA ESCALAR (σ)
    ) AS MedicosTop
-- 2. REUNIÓN EXTERNA IZQUIERDA (LEFT OUTER JOIN ⟕)
LEFT OUTER JOIN CONSULTA_MEDICA C ON MedicosTop.cedula_profesional = C.cedula_medico
ORDER BY MedicosTop.sueldo DESC;
GO

-- =================================================================
-- SECCIÓN B: CONSULTAS LMD ADICIONALES (UNIDAD 6)
-- (WHERE, ORDER BY, GROUP BY, HAVING, AGREGACIONES)
-- =================================================================

-- 1. Filtrado y Ordenamiento (WHERE + ORDER BY)
PRINT '=== B.1: PACIENTES NACIDOS ANTES DEL 2000 ===';
SELECT 
    P.primer_nombre, 
    P.ap_paterno, 
    PAC.num_expediente, 
    PAC.tipo_sangre, 
    P.fecha_nacimiento
FROM PERSONA P
INNER JOIN PACIENTE PAC ON P.curp = PAC.curp
WHERE P.fecha_nacimiento < '2000-01-01'
ORDER BY P.fecha_nacimiento ASC;
GO

-- 2. Agrupación y Funciones Agregadas (GROUP BY + COUNT, AVG, MAX, MIN)
PRINT '=== B.2: ESTADÍSTICAS SALARIALES POR ESPECIALIDAD ===';
SELECT 
    especialidad,
    COUNT(cedula_profesional) AS total_medicos,
    AVG(sueldo) AS sueldo_promedio,
    MAX(sueldo) AS sueldo_maximo,
    MIN(sueldo) AS sueldo_minimo
FROM MEDICO
GROUP BY especialidad;
GO

-- 3. Filtro sobre Agregados (HAVING)
PRINT '=== B.3: ESPECIALIDADES CON SUELDO PROMEDIO ELEVADO ===';
SELECT 
    especialidad, 
    AVG(sueldo) AS sueldo_promedio
FROM MEDICO
GROUP BY especialidad
HAVING AVG(sueldo) > 43000.00;
GO

-- 4. Demanda Acumulada de Medicamentos (LEFT JOIN + ISNULL + SUM)
PRINT '=== B.4: DEMANDA ACUMULADA POR FÁRMACO ===';
SELECT 
    M.codigo_barras, 
    M.nombre_comercial,
    COUNT(P.id_prescripcion) AS veces_prescrito,
    ISNULL(SUM(P.cantidad), 0) AS total_unidades_recetadas
FROM MEDICAMENTO M
LEFT OUTER JOIN PRESCRIPCION_DETALLE P ON M.codigo_barras = P.codigo_barras
GROUP BY M.codigo_barras, M.nombre_comercial
ORDER BY veces_prescrito DESC;
GO

-- =================================================================
-- SECCIÓN C: MANTENIMIENTO Y PRUEBAS DE INTEGRIDAD REFERENCIAL
-- (UPDATE, DELETE CASCADE, COMPROBACIÓN DE RESTRICCIÓN)
-- =================================================================

-- 1. Actualización de registros (UPDATE)
PRINT '=== C.1: OPERACIÓN UPDATE EN MEDICO Y CONSULTA ===';
UPDATE MEDICO
SET sueldo = sueldo * 1.10
WHERE especialidad = 'Cardiologia';

UPDATE CONSULTA_MEDICA
SET diagnostico = 'Hipertension Arterial Sistemica Controlada'
WHERE id_consulta = 'CON-3001';
GO

-- 2. Eliminación en Cascada (DELETE + ON DELETE CASCADE)
PRINT '=== C.2: OPERACIÓN DELETE EN CASCADA (EXP-2002) ===';

-- Paso previo: Borrar el historial clínico protegido para liberar al paciente
DELETE FROM PRESCRIPCION_DETALLE WHERE id_consulta = 'CON-3002';
DELETE FROM CONSULTA_MEDICA WHERE num_expediente = 'EXP-2002';

-- Ahora sí: Eliminar al paciente 'EXP-2002' propaga el borrado a ALERGIA_PACIENTE y PACIENTE_INTERNO
DELETE FROM PACIENTE
WHERE num_expediente = 'EXP-2002';

-- Comprobación: Devolverá 0 filas
SELECT * FROM ALERGIA_PACIENTE WHERE num_expediente = 'EXP-2002';
GO

-- 3. Eliminación Bloqueada por Restricción (ON DELETE NO ACTION)
-- Intentar borrar al médico 'CED-1001' es bloqueado porque tiene consultas asociadas
PRINT '=== C.3: INTENTO DE BORRADO BLOQUEADO POR CLAVE FORÁNEA ===';
BEGIN TRY
    DELETE FROM MEDICO WHERE cedula_profesional = 'CED-1001';
END TRY
BEGIN CATCH
    PRINT '>> BLOQUEO CORRECTO: ' + ERROR_MESSAGE();
END CATCH;
GO