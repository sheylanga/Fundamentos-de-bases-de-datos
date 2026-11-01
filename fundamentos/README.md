# 🗄️ Fundamentos de Bases de Datos — Portafolio de Evidencias

[![GitHub Repository](https://img.shields.io/badge/GitHub-Repositorio_Oficial-181717?style=for-the-badge&logo=github)](https://github.com/sheylanga/Bases_Datos.git)
[![TecNM](https://img.shields.io/badge/TecNM-Campus_Monclova-1b396a?style=for-the-badge)](https://www.monclova.tecnm.mx/)
[![SQL Server](https://img.shields.io/badge/Motor_SQL-T--SQL_%7C_PostgreSQL-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)]()
[![Status](https://img.shields.io/badge/Estado-6_Unidades_Completadas-success?style=for-the-badge)]()

---

## 👤 Datos de Identificación

- **Nombre:** Sheyla Estefania Moncada Guel
- **Matricula:** I24050388
- **Maestro:** Ruben Riojas
- **Asignatura:** Fundamentos de Bases de Datos
- **Institución:** Instituto Tecnológico Superior de Monclova (TecNM)

---

## 📑 Tabla de Contenido

1. [Descripción General del Repositorio](#-descripción-general-del-repositorio)
2. [Estructura del Proyecto](#-estructura-del-proyecto)
3. [Unidad 1: Introducción a las Bases de Datos](#-unidad-1-introducción-a-las-bases-de-datos)
   - [Tarea 1.1: Conceptos Fundamentales, Mapa Conceptual y Modelos de BD](./Unidad_1/Tarea_1.1/)
   - [Tarea 1.2: Clasificación de Bases de Datos, Arquitectura ANSI/SPARC y SGBD](./Unidad_1/Tarea_1.2/)
4. [Unidad 2: Diseño Conceptual (Modelo E-R, E-RE y UML)](#-unidad-2-diseño-conceptual-modelo-e-r-e-re-y-uml)
   - [Tarea 2.1: Diseño Conceptual E-R / E-RE del Sistema Hospitalario (HIS)](./Unidad_2/Tarea_2.1/)
   - [Tarea 2.2: Transición de E-R a POO — Diagrama de Clases UML](./Unidad_2/Tarea_2.2/)
5. [Unidad 3: Modelo Relacional e Implementación Física DDL](#-unidad-3-modelo-relacional-e-implementación-física-ddl)
   - [Tarea 3.1: Componentes del Modelo Relacional y Mapeo Lógico HIS](./Unidad_3/Tarea_3.1/)
   - [Tarea 3.2: Implementación Física en SGBD y Validación DML](./Unidad_3/Tarea_3.2/)
6. [Unidad 4: Normalización de Bases de Datos](#-unidad-4-normalización-de-bases-de-datos)
   - [Tarea 4.1: Dependencias Funcionales, Anomalías y Formas Normales (1FN a 5FN)](./Unidad_4/Tarea_4.1/)
   - [Tarea 4.2: Normalización Paso a Paso del Caso Hospitalario (0FN a 3FN/FNBC)](./Unidad_4/Tarea_4.2/)
7. [Unidad 5: Álgebra Relacional](#-unidad-5-álgebra-relacional)
   - [Tarea 5.1: Operadores Fundamentales y Extendidos del Álgebra Relacional](./Unidad_5/Tarea_5.1/)
   - [Tarea 5.2: Resolución de 10 Consultas Formales sobre el Esquema Relacional](./Unidad_5/Tarea_5.2/)
8. [Unidad 6: Introducción al Lenguaje SQL (LDD y LMD)](#-unidad-6-introducción-al-lenguaje-sql-ldd-y-lmd)
   - [Tarea 6.1: Sintaxis Formal BNF y Clasificación de Sentencias SQL](./Unidad_6/Tarea_6.1/)
   - [Tarea 6.2: Implementación de Script DDL, Carga Semilla y Consultas DML](./Unidad_6/Tarea_6.2/)

---

## 📖 Descripción General del Repositorio

Bienvenido al portafolio central de la materia **Fundamentos de Bases de Datos**. Este repositorio documenta de manera progresiva y estructurada las **6 unidades** del programa académico, aplicando cada concepto al diseño e implementación de un **Sistema de Información Hospitalaria (HIS)**.

Cada subcarpeta de actividad cuenta con su propio archivo `README.md` que integra:
- Descripción técnica de la tarea.
- **Visualización vectorial nativa en GitHub** mediante diagramas en **Mermaid.js** (mapas conceptuales, cuadros sinópticos, arquitecturas ANSI/SPARC y SGBD, diagramas Entidad-Relación, diagramas de clases UML y flujos de normalización) y tablas comparativas en Markdown.
- Enlaces directos a los documentos entregables (`.pdf` / `.docx`), scripts ejecutables (`.sql`) y presentaciones en video de YouTube.

---

## 🗂️ Estructura del Proyecto

```text
fundamentos/
├── README.md                                  # Índice general del repositorio
├── Unidad_1/
│   ├── README.md
│   ├── Tarea_1.1/
│   │   ├── README.md
│   │   └── Tarea_1.1.pdf
│   └── Tarea_1.2/
│       ├── README.md
│       └── Tarea_1.2.pdf
├── Unidad_2/
│   ├── README.md
│   ├── Tarea_2.1/
│   │   ├── README.md
│   │   └── Tarea_2.1.pdf
│   └── Tarea_2.2/
│       ├── README.md
│       └── Tarea_2.2.pdf
├── Unidad_3/
│   ├── README.md
│   ├── Tarea_3.1/
│   │   ├── README.md
│   │   ├── Tarea_3.1.pdf
│   │   └── Act_3.1.sql
│   └── Tarea_3.2/
│       ├── README.md
│       ├── Tarea_3.2.pdf
│       └── Act_3.2.sql
├── Unidad_4/
│   ├── README.md
│   ├── Tarea_4.1/
│   │   ├── README.md
│   │   └── Tarea_4.1.pdf
│   └── Tarea_4.2/
│       ├── README.md
│       ├── Tarea_4.2.pdf
│       └── Act_4.2.sql
├── Unidad_5/
│   ├── README.md
│   ├── Tarea_5.1/
│   │   ├── README.md
│   │   └── Tarea_5.1.docx
│   └── Tarea_5.2/
│       ├── README.md
│       └── Tarea_5.2.docx
└── Unidad_6/
    ├── README.md
    ├── Tarea_6.1/
    │   ├── README.md
    │   └── Tarea_6.1.docx
    └── Tarea_6.2/
        ├── README.md
        └── Tarea_6.2.docx
```

---

## 📂 [Unidad 1: Introducción a las Bases de Datos](./Unidad_1/)

Estudio de los fundamentos de los sistemas de bases de datos, objetivos operacionales (independencia de datos, control de redundancia, integridad y transacciones ACID), evaluación de modelos de datos, clasificación multidimensional y arquitectura interna de un SGBD.

### Actividades:
- 📁 **[Tarea 1.1 — Conceptos Fundamentales, Mapa Conceptual y Modelos de Bases de Datos](./Unidad_1/Tarea_1.1/)**
  - 📄 Documento PDF: [`Tarea_1.1.pdf`](./Unidad_1/Tarea_1.1/Tarea_1.1.pdf)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 1.1 en YouTube](https://www.youtube.com/watch?v=Y0G9CcBtikM)
- 📁 **[Tarea 1.2 — Clasificación de Bases de Datos, Arquitectura ANSI/SPARC y SGBD](./Unidad_1/Tarea_1.2/)**
  - 📄 Documento PDF: [`Tarea_1.2.pdf`](./Unidad_1/Tarea_1.2/Tarea_1.2.pdf)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 1.2 en YouTube](https://youtu.be/ui6-MONH-tc)

---

## 📂 [Unidad 2: Diseño Conceptual (Modelo E-R, E-RE y UML)](./Unidad_2/)

Modelado conceptual del **Sistema de Información Hospitalaria (HIS)** bajo 10 reglas de negocio formales, aplicando especialización total/parcial (`PERSONA` $\rightarrow$ `MEDICO` / `PACIENTE`), agregación (`Atención Médica`) y su mapeo al paradigma Orientado a Objetos mediante Diagramas de Clases UML.

### Actividades:
- 📁 **[Tarea 2.1 — Diseño Conceptual E-R / E-RE del Sistema Hospitalario](./Unidad_2/Tarea_2.1/)**
  - 📄 Documento PDF: [`Tarea_2.1.pdf`](./Unidad_2/Tarea_2.1/Tarea_2.1.pdf)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 2.1 en YouTube](https://youtu.be/O1hbUj7mWUI)
- 📁 **[Tarea 2.2 — Transición Paradigmática E-R a Diagrama de Clases UML](./Unidad_2/Tarea_2.2/)**
  - 📄 Documento PDF: [`Tarea_2.2.pdf`](./Unidad_2/Tarea_2.2/Tarea_2.2.pdf)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 2.2 en YouTube](https://youtu.be/u3yXulWuM_s)

---

## 📂 [Unidad 3: Modelo Relacional e Implementación Física DDL](./Unidad_3/)

Transformación rigurosa del modelo conceptual E-RE al **Modelo Relacional** de E. F. Codd, definición de restricciones de integridad (Entidad, Referencial, Dominio y Negocio) e implementación física en Microsoft SQL Server (T-SQL) / PostgreSQL.

### Actividades y Archivos SQL:
- 📁 **[Tarea 3.1 — Componentes Formales del Modelo Relacional y Mapeo Lógico HIS](./Unidad_3/Tarea_3.1/)**
  - 📄 Documento PDF: [`Tarea_3.1.pdf`](./Unidad_3/Tarea_3.1/Tarea_3.1.pdf)
  - 💻 Script SQL: [`Act_3.1.sql`](./Unidad_3/Tarea_3.1/Act_3.1.sql) *(Creación DDL de la base de datos `hospital_db` y sus 10 tablas)*
  - 🎥 Video en YouTube: [Ver explicación de Tarea 3.1 en YouTube](https://youtu.be/1i_VYQquys8)
- 📁 **[Tarea 3.2 — Implementación Física en SGBD y Pruebas de Integridad DML](./Unidad_3/Tarea_3.2/)**
  - 📄 Documento PDF: [`Tarea_3.2.pdf`](./Unidad_3/Tarea_3.2/Tarea_3.2.pdf)
  - 💻 Script SQL: [`Act_3.2.sql`](./Unidad_3/Tarea_3.2/Act_3.2.sql) *(Script DDL + Inserciones DML + Pruebas `TRY/CATCH` de restricciones `CHECK`)*
  - 🎥 Video en YouTube: [Ver explicación de Tarea 3.2 en YouTube](https://youtu.be/rEiKP-lVJgM)

---

## 📂 [Unidad 4: Normalización de Bases de Datos](./Unidad_4/)

Análisis de Dependencias Funcionales (totales, parciales, transitivas, multivaloradas y de unión), anomalías operativas (inserción, borrado y modificación) y descomposición sin pérdida desde una estructura plana desnormalizada (`0FN` con JSON) hasta `1FN`, `2FN`, `3FN` y `FNBC`.

### Actividades y Archivos SQL:
- 📁 **[Tarea 4.1 — Concepto Formal de Normalización, Dependencias y Formas Normales (1FN a 5FN)](./Unidad_4/Tarea_4.1/)**
  - 📄 Documento PDF: [`Tarea_4.1.pdf`](./Unidad_4/Tarea_4.1/Tarea_4.1.pdf)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 4.1 en YouTube](https://youtu.be/RoamPY7YxBU)
- 📁 **[Tarea 4.2 — Normalización Paso a Paso del Sistema Hospitalario (0FN a 3FN/FNBC)](./Unidad_4/Tarea_4.2/)**
  - 📄 Documento PDF: [`Tarea_4.2.pdf`](./Unidad_4/Tarea_4.2/Tarea_4.2.pdf)
  - 💻 Script SQL: [`Act_4.2.sql`](./Unidad_4/Tarea_4.2/Act_4.2.sql) *(Comparativa ejecutable entre tabla `0FN` y esquema normalizado en `3FN`)*
  - 🎥 Video en YouTube: [Ver explicación de Tarea 4.2 en YouTube](https://youtu.be/1h1aQib35Mo)

---

## 📂 [Unidad 5: Álgebra Relacional](./Unidad_5/)

Formulación matemática de consultas procedimentales mediante operadores unarios ($\sigma$, $\pi$, $\rho$), binarios ($\cup$, $-$, $\times$), derivados ($\cap$, $\bowtie_\theta$, $\bowtie$, $\div$) y extendidos ($\pi^*$, $\mathcal{G}$, Outer Joins), con desglose de tablas intermedias y traducción a SQL.

### Actividades:
- 📁 **[Tarea 5.1 — Operadores Fundamentales y Extendidos del Álgebra Relacional](./Unidad_5/Tarea_5.1/)**
  - 📄 Documento: [`Tarea_5.1.docx`](./Unidad_5/Tarea_5.1/Tarea_5.1.docx)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 5.1 en YouTube](https://www.youtube.com/watch?v=PEGAR_ID_VIDEO_TAREA_5_1)
- 📁 **[Tarea 5.2 — Catálogo de 10 Consultas Formales en Álgebra Relacional y Equivalencia SQL](./Unidad_5/Tarea_5.2/)**
  - 📄 Documento: [`Tarea_5.2.docx`](./Unidad_5/Tarea_5.2/Tarea_5.2.docx)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 5.2 en YouTube](https://www.youtube.com/watch?v=PEGAR_ID_VIDEO_TAREA_5_2)

---

## 📂 [Unidad 6: Introducción al Lenguaje SQL (LDD y LMD)](./Unidad_6/)

Estudio de la sintaxis formal EBNF de SQL (`CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `INSERT`, `UPDATE`, `DELETE`, `SELECT`) e implementación en 4 fases del Sistema de Información Hospitalaria: definición de esquema, carga semilla, consultas analíticas y pruebas de mantenimiento referencial.

### Actividades:
- 📁 **[Tarea 6.1 — Sintaxis y Clasificación de Sentencias SQL (LDD y LMD)](./Unidad_6/Tarea_6.1/)**
  - 📄 Documento: [`Tarea_6.1.docx`](./Unidad_6/Tarea_6.1/Tarea_6.1.docx)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 6.1 en YouTube](https://www.youtube.com/watch?v=PEGAR_ID_VIDEO_TAREA_6_1)
- 📁 **[Tarea 6.2 — Implementación de Script DDL, Carga de Datos y Consultas DML](./Unidad_6/Tarea_6.2/)**
  - 📄 Documento: [`Tarea_6.2.docx`](./Unidad_6/Tarea_6.2/Tarea_6.2.docx)
  - 🎥 Video en YouTube: [Ver explicación de Tarea 6.2 en YouTube](https://www.youtube.com/watch?v=PEGAR_ID_VIDEO_TAREA_6_2)
