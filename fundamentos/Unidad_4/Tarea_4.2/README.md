# 📕 Tarea 4.2: Normalización Paso a Paso del Sistema Hospitalario (0FN a 3FN / FNBC)

---

## 👤 Datos de Identificación

- **Nombre:** Sheyla Estefania Moncada Guel
- **Matricula:** I24050388
- **Maestro:** Ruben Riojas
- **Asignatura:** Fundamentos de Bases de Datos
- **Unidad:** [Unidad 4 — Normalización de Bases de Datos](../)

---

## 📝 Descripción

En esta actividad práctica se documenta y ejecuta en SQL ([`Act_4.2.sql`](./Act_4.2.sql)) el proceso de normalización paso a paso del Sistema de Información Hospitalaria (HIS), partiendo de una tabla universal desnormalizada (`0FN`) hasta alcanzar la **Tercera Forma Normal (`3FN`)** y la **Forma Normal de Boyce-Codd (`FNBC`)**:
1. **Estado Desnormalizado (`0FN`):** Análisis de la tabla plana `REGISTRO_HOSPITALARIO_DESNORMALIZADO`, la cual mezcla atributos del paciente, médico, consulta, cadenas multivaloradas (`telefonos_paciente`, `alergias_paciente`) y un grupo repetitivo en formato JSON (`medicamentos_prescritos`).
2. **Transición a `1FN`:** Garantía de atomicidad extrayendo `TELEFONO_PERSONA`, `ALERGIA_PACIENTE` y desglosando el arreglo JSON en la tabla asociativa `PRESCRIPCION_DETALLE`.
3. **Transición a `2FN`:** Eliminación de dependencias parciales sobre la clave compuesta `(id_consulta, codigo_barras)`, separando el catálogo `MEDICAMENTO` (`nombre_comercial`, `dosis_recomendada`).
4. **Transición a `3FN` y `FNBC`:** Eliminación de dependencias transitivas aislando `PERSONA`, `MEDICO`, `PACIENTE` (y sus especializaciones) y `CONSULTA_MEDICA`.

---

## 📊 Visualización de Gráficos

### 1. Pipeline de Descomposición Sin Pérdida: de 0FN a 3FN / FNBC (Mermaid.js)

```mermaid
flowchart TD
    U0["⚠️ 0FN: REGISTRO_HOSPITALARIO_DESNORMALIZADO<br/>(Tabla Plana con Teléfonos/Alergias separadas por coma y JSON de Medicamentos)"]

    U0 -->|Paso 1: Atomicidad y Grupos Repetitivos| FN1["1️⃣ Primera Forma Normal (1FN)"]
    FN1 --> T_TEL["Tabla: TELEFONO_PERSONA<br/>(Extrae multivalorado telefonos)"]
    FN1 --> T_ALE["Tabla: ALERGIA_PACIENTE<br/>(Extrae multivalorado alergias)"]
    FN1 --> T_PRE["Tabla: PRESCRIPCION_DETALLE<br/>(Desglosa JSON medicamentos_prescritos)"]

    FN1 -->|Paso 2: Eliminar Dependencias Parciales| FN2["2️⃣ Segunda Forma Normal (2FN)"]
    FN2 --> T_MED_CAT["Tabla: MEDICAMENTO<br/>(codigo_barras -> nombre_comercial, dosis_recomendada)"]

    FN2 -->|Paso 3: Eliminar Dependencias Transitivas| FN3["3️⃣ Tercera Forma Normal (3FN) y FNBC"]
    FN3 --> T_PER["Tabla: PERSONA<br/>(curp -> nombre, fecha_nacimiento)"]
    FN3 --> T_DOC["Tabla: MEDICO<br/>(cedula_profesional -> curp, especialidad, sueldo)"]
    FN3 --> T_PAC["Tablas: PACIENTE / INTERNO / AMBULATORIO<br/>(num_expediente -> curp, tipo_sangre)"]
    FN3 --> T_CON["Tabla: CONSULTA_MEDICA<br/>(id_consulta -> cedula_medico, num_expediente, diagnostico)"]

    classDef bad fill:#fee2e2,stroke:#dc2626,color:#7f1d1d,font-weight:bold;
    classDef step fill:#1d4ed8,stroke:#1e40af,color:#ffffff,font-weight:bold;
    classDef tableNode fill:#f0fdf4,stroke:#16a34a,color:#14532d;

    class U0 bad;
    class FN1,FN2,FN3 step;
    class T_TEL,T_ALE,T_PRE,T_MED_CAT,T_PER,T_DOC,T_PAC,T_CON tableNode;
```

### 2. Resumen de Transformación por Forma Normal

| Etapa | Anomalía / Dependencia Detectada | Acción Correctiva en el Esquema SQL (`Act_4.2.sql`) |
| :--- | :--- | :--- |
| **0FN $\rightarrow$ 1FN** | Listas de valores en `telefonos_paciente`, `alergias_paciente` y arreglo JSON en `medicamentos_prescritos`. | Creación de tablas `TELEFONO_PERSONA`, `ALERGIA_PACIENTE` y `PRESCRIPCION_DETALLE` con celdas 100% atómicas. |
| **1FN $\rightarrow$ 2FN** | Dependencia parcial: `(id_consulta, codigo_barras) -> nombre_med, dosis_rec` (dependen solo de `codigo_barras`). | Creación del catálogo independiente `MEDICAMENTO (codigo_barras PK, nombre_comercial, dosis_recomendada)`. |
| **2FN $\rightarrow$ 3FN / FNBC** | Dependencias transitivas: `id_consulta -> cedula_medico -> nombre_medico, especialidad, sueldo` y `num_expediente -> curp_paciente -> nombre_paciente`. | Descomposición en entidades independientes `PERSONA`, `MEDICO`, `PACIENTE`, `PACIENTE_INTERNO`, `PACIENTE_AMBULATORIO` y `CONSULTA_MEDICA`. |

## Referencias Bibliográficas
* Codd, E. F. (1970). A relational model of data for large shared data banks. Communications of 
the ACM, 13(6), 377–387. 
* Connolly, T. M., & Begg, C. E. (2015). Database systems: A practical approach to design, 
implementation, and management (6th ed.). Pearson. 
* Elmasri, R., & Navathe, S. B. (2017). Fundamentals of database systems (7th ed.). Pearson. 
* Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). Database system concepts (7th ed.). 
McGraw-Hill. 
---

## 📦 Entregable

- 📄 **Archivo PDF de la Actividad:** [`Tarea_4.2.pdf`](./Tarea_4.2.pdf)
- 💻 **Script SQL (0FN vs 3FN):** [`Act_4.2.sql`](./Act_4.2.sql)
- 🎥 **Video Explicativo en YouTube:** [Ver video en YouTube](https://youtu.be/1h1aQib35Mo)

[![Ver PDF](https://img.shields.io/badge/PDF-Abrir_Tarea_4.2.pdf-EC1C24?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](./Tarea_4.2.pdf)
[![Ver SQL](https://img.shields.io/badge/SQL-Abrir_Act_4.2.sql-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](./Act_4.2.sql)
[![YouTube](https://img.shields.io/badge/YouTube-Ver_Video_Explicativo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/1h1aQib35Mo)

