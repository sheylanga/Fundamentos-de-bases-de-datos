# 📙 Tarea 3.2: Implementación Física en SGBD y Pruebas de Validación DML

---

## 👤 Datos de Identificación

- **Nombre:** Sheyla Estefania Moncada Guel
- **Matricula:** I24050388
- **Maestro:** Ruben Riojas
- **Asignatura:** Fundamentos de Bases de Datos
- **Unidad:** [Unidad 3 — Modelo Relacional e Implementación Física DDL](../)

---

## 📝 Descripción

En esta actividad se lleva a cabo la implementación física y validación del esquema relacional del **Sistema de Información Hospitalaria (`hospital_db`)** mediante el Lenguaje de Definición de Datos (LDD/DDL) y pruebas de integridad con el Lenguaje de Manipulación de Datos (LMD/DML):
1. **Estrategia de Tipos de Datos y Mapeo Físico:** Selección justificada de tipos físicos (`VARCHAR(18)`, `DECIMAL(10,2)`, `DATE`, `DATETIME2`/`TIMESTAMP`, `NVARCHAR(MAX)`/`TEXT`).
2. **Políticas de Cascadas y Restricciones:** Configuración de `ON DELETE CASCADE` en entidades débiles/multivaloradas y `ON DELETE NO ACTION` / `RESTRICT` en entidades maestras (`MEDICO`, `PACIENTE`, `MEDICAMENTO`).
3. **Pruebas de Validación DML (`Act_3.2.sql`):** Inserción de datos semilla válidos y pruebas controladas con bloques `BEGIN TRY ... BEGIN CATCH` para comprobar el rechazo automático ante sueldos negativos (`sueldo = -5000.00`) y tipos de sangre inválidos (`tipo_sangre = 'Z+'`).

---

## 📊 Visualización de Gráficos

### 1. Flujo de Ejecución DDL y Validación de Restricciones en el SGBD (Mermaid.js)

```mermaid
flowchart TD
    START(["🚀 Inicio de Ejecución: Act_3.2.sql"]) --> DB["Creación y Selección de BD: hospital_db"]
    DB --> DROP["Limpieza Idempotente (DROP TABLE IF EXISTS en orden inverso)"]
    DROP --> DDL["Creación Jerárquica de 10 Tablas DDL"]

    DDL --> T_BASE["1. Superclase y Catálogo: PERSONA, MEDICAMENTO"]
    T_BASE --> T_SUB["2. Subclases y Multivalorados: TELEFONO_PERSONA, MEDICO, PACIENTE"]
    T_SUB --> T_ESP["3. Especializaciones: ALERGIA_PACIENTE, PACIENTE_INTERNO, PACIENTE_AMBULATORIO"]
    T_ESP --> T_TRN["4. Transaccionales: CONSULTA_MEDICA, PRESCRIPCION_DETALLE"]

    T_TRN --> DML_OK["✅ Prueba A: Inserción DML Válida<br/>(Médico, Paciente O+, Consulta CNS-001)"]
    T_TRN --> DML_ERR1["❌ Prueba B (TRY/CATCH): Sueldo Negativo (-5000.00)<br/>Bloqueado por CONSTRAINT chk_medico_sueldo"]
    T_TRN --> DML_ERR2["❌ Prueba C (TRY/CATCH): Tipo Sangre Inválido ('Z+')<br/>Bloqueado por CONSTRAINT chk_paciente_sangre"]

    DML_OK & DML_ERR1 & DML_ERR2 --> SELECT["📊 Verificación Final: SELECT * FROM Tablas"]
```

### 2. Estrategia de Tipos de Datos y Mapeo Físico en SQL

| Tipo de Dato Lógico | Tipo de Dato Físico (SQL) | Justificación Técnica y Dominio |
| :--- | :--- | :--- |
| **Identificadores Únicos (`CURP`, `Cédula`)** | `VARCHAR(18)` / `VARCHAR(20)` | Cadenas de longitud fija o acotada con restricciones sintácticas estrictas mediante `CHECK`. |
| **Nombres y Descripciones Cortas** | `VARCHAR(50)` / `VARCHAR(100)` | Cadenas variables optimizadas para almacenamiento sin desperdicio de espacio físico. |
| **Textos Extensos (`Diagnóstico`, `Síntomas`)** | `TEXT` / `NVARCHAR(MAX)` | Campos sin límite rígido de caracteres para almacenar resúmenes clínicos detallados. |
| **Fechas y Marcas Temporales** | `DATE` / `TIMESTAMP` (`DATETIME2`) | Registros de precisión cronológica para nacimientos, citas y fechas/horas exactas de atención. |
| **Moneda / Sueldos y Cantidades** | `DECIMAL(10,2)` / `INT` / `IDENTITY` | Precisión decimal exacta para evitar redondeos numéricos en salarios e identificadores autoincrementables. |

---

## 📦 Entregable

- 📄 **Archivo PDF de la Actividad:** [`Tarea_3.2.pdf`](./Tarea_3.2.pdf)
- 💻 **Script SQL con Pruebas DML:** [`Act_3.2.sql`](./Act_3.2.sql)
- 🎥 **Video Explicativo en YouTube:** [Ver video en YouTube](https://youtu.be/rEiKP-lVJgM)

[![Ver PDF](https://img.shields.io/badge/PDF-Abrir_Tarea_3.2.pdf-EC1C24?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](./Tarea_3.2.pdf)
[![Ver SQL](https://img.shields.io/badge/SQL-Abrir_Act_3.2.sql-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](./Act_3.2.sql)
[![YouTube](https://img.shields.io/badge/YouTube-Ver_Video_Explicativo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/rEiKP-lVJgM)

