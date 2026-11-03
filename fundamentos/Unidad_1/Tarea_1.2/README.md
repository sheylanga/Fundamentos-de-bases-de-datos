# 📘 Tarea 1.2: Clasificación de las Bases de Datos y Arquitecturas ANSI/SPARC y SGBD

---

## 👤 Datos de Identificación

- **Nombre:** Sheyla Estefania Moncada Guel
- **Matricula:** I24050388
- **Maestro:** Ruben Riojas
- **Asignatura:** Fundamentos de Bases de Datos
- **Unidad:** [Unidad 1 — Introducción a las Bases de Datos](../)

---

## 📝 Descripción

En esta actividad se estudia la taxonomía de las bases de datos y la arquitectura estandarizada de los motores de bases de datos:
1. **Clasificación de las Bases de Datos:** Cuadro sinóptico estructurado bajo cuatro criterios: *Variabilidad de Datos* (Estáticas/OLAP vs. Dinámicas/OLTP), *Ubicación Física* (Centralizadas vs. Distribuidas/DDBMS), *Modelo de Datos* (Relacionales/RDBMS vs. NoSQL/Flexibles) y *Arquitectura de Software* (Cliente-Servidor/N-Capas vs. Embebidas/In-Memory).
2. **Arquitectura de Tres Niveles (ANSI/SPARC):** Análisis del Nivel Externo (Vistas de Usuario), Nivel Conceptual (Esquema Global) y Nivel Interno/Físico, explicando los mapeos que garantizan la **Independencia Lógica y Física de los Datos**.
3. **Arquitectura Funcional Interna del SGBD:** Desglose de subsistemas clave: *Procesador de Consultas* (Parser, Optimizador CBO, Ejecutor), *Gestor de Almacenamiento* (Buffer Manager, File Manager, Gestor de Índices), *Gestor de Transacciones* (Control de Concurrencia Locks/MVCC y Recuperación WAL) y *Diccionario de Datos* (Catálogo del Sistema).

---

## 📊 Visualización de Gráficos

### 1. Cuadro Sinóptico de Clasificación de Bases de Datos (Mermaid.js)

```mermaid
flowchart LR
    ROOT["🗂️ CLASIFICACIÓN DE<br/>BASES DE DATOS"]

    ROOT --> C1["1. Variabilidad de Datos"]
    ROOT --> C2["2. Ubicación Física"]
    ROOT --> C3["3. Modelo de Datos"]
    ROOT --> C4["4. Arquitectura de Software"]

    C1 --> C1A["Estáticas / OLAP"]
    C1 --> C1B["Dinámicas / OLTP"]
    C1A --> C1AD["• Solo lectura / Análisis histórico<br/>• Ej. Data Warehouses, Repositorios"]
    C1B --> C1BD["• Lectura/escritura en tiempo real<br/>• Ej. Expediente Clínico (HIS), POS"]

    C2 --> C2A["Centralizadas"]
    C2 --> C2B["Distribuidas / DDBMS"]
    C2A --> C2AD["• Un solo servidor / mainframe central<br/>• Ej. Servidores monolíticos"]
    C2B --> C2BD["• Servidores en red (nodos)<br/>• Ej. CockroachDB, Google Spanner"]

    C3 --> C3A["Relacionales / RDBMS"]
    C3 --> C3B["NoSQL / Flexibles"]
    C3A --> C3AD["• Tablas, tuplas, PK/FK, ACID<br/>• Ej. PostgreSQL, Oracle, MySQL"]
    C3B --> C3BD["• Documentos, clave-valor, grafos<br/>• Ej. MongoDB, Redis, Neo4j"]

    C4 --> C4A["Cliente-Servidor / N-Capas"]
    C4 --> C4B["Embebidas / In-Memory"]
    C4A --> C4AD["• Acceso remoto mediante capas lógicas<br/>• Ej. Sistemas ERP, Portales Web"]
    C4B --> C4BD["• Integradas en el ejecutable<br/>• Ej. SQLite, DuckDB, H2"]

    classDef root fill:#1e293b,stroke:#0f172a,color:#ffffff,font-weight:bold;
    classDef axis fill:#1d4ed8,stroke:#1e40af,color:#ffffff,font-weight:bold;
    classDef sub fill:#2563eb,stroke:#1d4ed8,color:#ffffff;
    classDef detail fill:#f1f5f9,stroke:#94a3b8,color:#0f172a;

    class ROOT root;
    class C1,C2,C3,C4 axis;
    class C1A,C1B,C2A,C2B,C3A,C3B,C4A,C4B sub;
    class C1AD,C1BD,C2AD,C2BD,C3AD,C3BD,C4AD,C4BD detail;
```

### 2. Arquitectura de Tres Niveles (ANSI/SPARC) e Independencia de Datos

```mermaid
flowchart LR
    subgraph N1["1. Nivel Externo (Vistas de Usuario)"]
        V1["Vista 1: Médico<br/>(Expediente)"]
        V2["Vista 2: Recepción<br/>(Citas)"]
        V3["Vista 3: Facturación"]
    end

    subgraph M1["Mapeo Externo / Conceptual"]
        TC["Transformación de Consultas<br/>(Independencia Lógica)"]
    end

    subgraph N2["2. Nivel Conceptual (Esquema Global)"]
        EC["Esquema Lógico Global<br/>(Entidades, Atributos,<br/>Relaciones, Reglas)"]
    end

    subgraph M2["Mapeo Conceptual / Interno"]
        TLF["Transformación Lógico-Física<br/>(Independencia Física)"]
    end

    subgraph N3["3. Nivel Interno (Almacenamiento Físico)"]
        EF["Esquema Físico<br/>(Archivos, Índices B-Tree,<br/>Bloques de Disco)"]
    end

    V1 & V2 & V3 --> TC --> EC --> TLF --> EF
```

### 3. Arquitectura Funcional Interna de un SGBD

```mermaid
flowchart TD
    subgraph QP["Procesador de Consultas (Query Processor)"]
        P["Parser / Analizador Léxico"] -->|Árbol Sintáctico| O["Optimizador de Consultas (CBO)"]
        O -->|Plan de Ejecución| CE["Compilador y Ejecutor de Planes"]
    end

    subgraph TM["Gestor de Transacciones (Transaction Manager)"]
        CC["Control de Concurrencia (Locks / MVCC)"]
        GR["Gestor de Recuperación (Log / WAL)"]
    end

    subgraph SM["Gestor de Almacenamiento (Storage Manager)"]
        DD[("Diccionario de Datos<br/>(Catálogo del Sistema)")]
        BM["Buffer Manager (RAM)"]
        FM["Gestor de Archivos (File Manager)"]
        GI["Gestor de Índices"]
    end

    DISK[("Almacenamiento Físico<br/>(Disco / SSD)")]

    CE -->|Consulta Metadatos| DD
    CE -->|Solicitud de Páginas| BM
    CE -->|Control ACID| CC
    CE -->|Registro en Log| GR
    BM -->|Lectura / Escritura de Bloques| FM
    FM -->|Búsqueda por Índices| GI
    BM & FM & GI -->|E/S Físicas| DISK
```

## Referencias Bibliográficas
* Connolly, T. M., & Begg, C. E. (2015). Database systems: A practical approach to design, 
implementation, and management (6th ed.). Pearson. 
* Date, C. J. (2004). An introduction to database systems (8th ed.). Addison-Wesley. 
* Elmasri, R., & Navathe, S. B. (2017). Fundamentals of database systems (7th ed.). Pearson. 
* Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). Database system concepts (7th ed.). 
McGraw-Hill. 
---

## 📦 Entregable

- 📄 **Archivo PDF de la Actividad:** [`Tarea_1.2.pdf`](./Tarea_1.2.pdf)
- 🎥 **Video Explicativo en YouTube:** [Ver video en YouTube](https://youtu.be/ui6-MONH-tc)

[![Ver PDF](https://img.shields.io/badge/PDF-Abrir_Tarea_1.2.pdf-EC1C24?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](./Tarea_1.2.pdf)
[![YouTube](https://img.shields.io/badge/YouTube-Ver_Video_Explicativo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/ui6-MONH-tc)

