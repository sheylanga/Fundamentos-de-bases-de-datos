# 📕 Tarea 4.1: Concepto Formal de Normalización, Dependencias Funcionales y Formas Normales (1FN a 5FN)

---

## 👤 Datos de Identificación

- **Nombre:** Sheyla Estefania Moncada Guel
- **Matricula:** I24050388
- **Maestro:** Ruben Riojas
- **Asignatura:** Fundamentos de Bases de Datos
- **Unidad:** [Unidad 4 — Normalización de Bases de Datos](../)

---

## 📝 Descripción

En esta actividad se analizan los fundamentos matemáticos de la **Teoría de Normalización** para purificar esquemas relacionales mediante descomposición sin pérdida (*lossless-join decomposition*):
1. **Dependencias Funcionales ($X \rightarrow Y$):** Clasificación formal de dependencias Funcionales Totales/Completas, Parciales (violación de `2FN`), Transitivas (violación de `3FN`), Multivaloradas ($X \twoheadrightarrow Y$, base de `4FN`) y de Unión (*Join Dependency*, base de `5FN / PJNF`).
2. **Anomalías Clásicas de Diseño en Esquemas No Normalizados:** Evaluación técnica de las anomalías de Inserción, Borrado y Modificación sobre la tabla universal `REGISTRO_HOSPITALARIO_DESNORMALIZADO`.
3. **Mapa Conceptual Sintético de las Formas Normales (`1FN` a `5FN`):** Reglas escalonadas desde la atomicidad hasta la eliminación de dependencias de unión.

---

## 📊 Visualización de Gráficos

### 1. Mapa Conceptual Sintético de las Formas Normales (1FN a 5FN) en Mermaid.js

```mermaid
flowchart TD
    NORM["📐 PROCESO DE<br/>NORMALIZACIÓN"]

    NORM --> FN1["1. Primera Forma<br/>Normal - 1FN"]
    NORM --> FN2["2. Segunda Forma<br/>Normal - 2FN"]
    NORM --> FN3["3. Tercera Forma<br/>Normal - 3FN"]
    NORM --> BCNF["4. Forma Normal de<br/>Boyce-Codd - FNBC"]
    NORM --> ADV["5. Formas Avanzadas<br/>4FN / 5FN"]

    FN1 --> R1["Requisito:<br/>Atomicidad"]
    FN2 --> R2["Requisito:<br/>Dep. Total"]
    FN3 --> R3["Requisito:<br/>Dep. Directa"]
    BCNF --> R4["Requisito:<br/>Determinante = Superclave"]
    ADV --> R5A["4FN: Dep.<br/>Multivaloradas"]
    ADV --> R5B["5FN: Dep.<br/>de Unión"]

    R1 --> D1["• Celdas con valores atómicos indivisibles<br/>• Eliminar arreglos y grupos repetitivos<br/>• Crear tablas independientes para multivalorados"]
    R2 --> D2["• Estar en 1FN<br/>• Eliminar dependencias parciales<br/>• Atributos no clave dependen de TODA la PK compuesta"]
    R3 --> D3["• Estar en 2FN<br/>• Eliminar dependencias transitivas<br/>• Atributos no clave dependen SOLO de la PK"]
    R4 --> D4["• Estar en 3FN<br/>• Para toda DF X -> Y, X DEBE ser Superclave<br/>• Resuelve solapamientos de claves candidatas"]
    R5A --> D5A["• Estar en FNBC<br/>• Eliminar dependencias multivaloradas (X ->> Y)"]
    R5B --> D5B["• Estar en 4FN<br/>• Eliminar dependencias de unión (PJNF)<br/>• Descomposición n-aria sin pérdida"]

    classDef root fill:#1e293b,stroke:#0f172a,color:#ffffff,font-weight:bold;
    classDef stage fill:#1d4ed8,stroke:#1e40af,color:#ffffff,font-weight:bold;
    classDef req fill:#3b82f6,stroke:#1d4ed8,color:#ffffff;
    classDef desc fill:#f1f5f9,stroke:#94a3b8,color:#0f172a;

    class NORM root;
    class FN1,FN2,FN3,BCNF,ADV stage;
    class R1,R2,R3,R4,R5A,R5B req;
    class D1,D2,D3,D4,D5A,D5B desc;
```

### 2. Tabla de Anomalías Operativas en el Sistema Hospitalario (HIS)

| Tipo de Anomalía | Manifestación en el Sistema Hospitalario (HIS) | Impacto Técnico y Operativo |
| :--- | :--- | :--- |
| **Anomalía de Inserción** | No se puede registrar un nuevo medicamento si no se le asocia de inmediato la consulta de un paciente. | Bloqueo de catálogos y obligatoriedad de datos ficticios o nulos. |
| **Anomalía de Borrado** | Al dar de baja el expediente de un paciente dado de alta, se elimina el registro histórico del médico tratante. | Pérdida no deseada de metadatos clínicos e institucionales. |
| **Anomalía de Modificación** | Si cambia el sueldo de un médico, debe actualizarse en 500 consultas históricas. Un fallo parcial genera inconsistencia. | Corrupción de integridad y duplicidad contradictoria de la verdad. |

## Referencias Bibliográficas
* Codd, E. F. (1970). A relational model of data for large shared data banks. Communications of 
the ACM, 13(6), 377-387. 
* Connolly, T. M., & Begg, C. E. (2015). Database systems: A practical approach to design, 
implementation, and management (6th ed.). Pearson Education. 
* Date, C. J. (2004). An introduction to database systems (8th ed.). Addison-Wesley. 
* Elmasri, R., & Navathe, S. B. (2017). Fundamentals of database systems (7th ed.). Pearson. 
* Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). Database system concepts (7th ed.). 
McGraw-Hill.
---

## 📦 Entregable

- 📄 **Archivo PDF de la Actividad:** [`Tarea_4.1.pdf`](./Tarea_4.1.pdf)
- 🎥 **Video Explicativo en YouTube:** [Ver video en YouTube](https://youtu.be/RoamPY7YxBU)

[![Ver PDF](https://img.shields.io/badge/PDF-Abrir_Tarea_4.1.pdf-EC1C24?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](./Tarea_4.1.pdf)
[![YouTube](https://img.shields.io/badge/YouTube-Ver_Video_Explicativo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/RoamPY7YxBU)

