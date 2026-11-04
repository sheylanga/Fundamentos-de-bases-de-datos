# 📙 Tarea 3.1: Componentes Formales del Modelo Relacional y Mapeo Lógico HIS

---

## 👤 Datos de Identificación

- **Nombre:** Sheyla Estefania Moncada Guel
- **Matricula:** I24050388
- **Maestro:** Ruben Riojas
- **Asignatura:** Fundamentos de Bases de Datos
- **Unidad:** [Unidad 3 — Modelo Relacional e Implementación Física DDL](../)

---

## 📝 Descripción

En esta actividad se fundamenta matemáticamente el **Modelo Relacional** propuesto por E. F. Codd (1970) y se aplica el algoritmo formal de transformación sobre el diseño E-RE del Sistema de Información Hospitalaria (HIS):
1. **Elementos Matemáticos y Claves:** Definición de Dominio ($D$), Atributo ($A$), Tupla ($t$), Relación ($R \subseteq D_1 \times D_2 \times \dots \times D_n$) y taxonomía de claves (`CK`, `PK`, `AK`, `FK`).
2. **Restricciones de Integridad Relacional:** Especificación de Integridad de Entidad (`PRIMARY KEY NOT NULL`), Integridad Referencial (`FOREIGN KEY` con `CASCADE`/`RESTRICT`), Integridad de Dominio (`CHECK`) y Reglas de Negocio.
3. **Mapeo Riguroso del Caso Hospitalario (Reglas 1 a 6):** Transformación de superclases/subclases, atributos multivalorados y agregación `N:M` en un esquema relacional de 10 tablas implementado en [`Act_3.1.sql`](./Act_3.1.sql).

---

## 📊 Visualización de Gráficos

### 1. Diagrama del Esquema Relacional Físico/Lógico del Sistema Hospitalario (Mermaid.js)

```mermaid
erDiagram
    PERSONA {
        varchar_18 curp PK "CHECK LEN=18"
        varchar_50 primer_nombre "NOT NULL"
        varchar_50 ap_paterno "NOT NULL"
        varchar_50 ap_materno "NULL"
        date fecha_nacimiento "NOT NULL"
    }
    TELEFONO_PERSONA {
        int id_telefono PK "IDENTITY(1,1)"
        varchar_18 curp_persona FK "ON DELETE CASCADE"
        varchar_15 telefono "NOT NULL"
    }
    MEDICO {
        varchar_20 cedula_profesional PK
        varchar_18 curp FK, UK "UNIQUE"
        varchar_50 especialidad "NOT NULL"
        decimal_10_2 sueldo "CHECK > 0"
    }
    PACIENTE {
        varchar_20 num_expediente PK
        varchar_18 curp FK, UK "UNIQUE"
        varchar_5 tipo_sangre "CHECK IN (A+, O+, ...)"
    }
    ALERGIA_PACIENTE {
        int id_alergia PK "IDENTITY(1,1)"
        varchar_20 num_expediente FK "ON DELETE CASCADE"
        varchar_50 alergia "NOT NULL"
    }
    PACIENTE_INTERNO {
        varchar_20 num_expediente PK, FK "ON DELETE CASCADE"
        int num_cama "CHECK > 0"
        datetime2 fecha_ingreso "DEFAULT GETDATE()"
    }
    PACIENTE_AMBULATORIO {
        varchar_20 num_expediente PK, FK "ON DELETE CASCADE"
        date fecha_proxima_cita "NULL"
    }
    CONSULTA_MEDICA {
        varchar_20 id_consulta PK
        varchar_20 cedula_medico FK "ON DELETE NO ACTION"
        varchar_20 num_expediente FK "ON DELETE NO ACTION"
        datetime2 fecha_hora "DEFAULT GETDATE()"
        nvarchar_max diagnostico "NOT NULL"
        nvarchar_max sintomas "NOT NULL"
    }
    MEDICAMENTO {
        varchar_30 codigo_barras PK
        varchar_100 nombre_comercial "NOT NULL"
        varchar_50 dosis_recomendada "NOT NULL"
    }
    PRESCRIPCION_DETALLE {
        int id_prescripcion PK "IDENTITY(1,1)"
        varchar_20 id_consulta FK "ON DELETE CASCADE"
        varchar_30 codigo_barras FK "ON DELETE NO ACTION"
        nvarchar_max indicaciones "NOT NULL"
        int cantidad "CHECK > 0"
    }

    PERSONA ||--o{ TELEFONO_PERSONA : "1:N (Multivalorado)"
    PERSONA ||--o| MEDICO : "Herencia (Hereda CURP)"
    PERSONA ||--o| PACIENTE : "Herencia (Hereda CURP)"
    PACIENTE ||--o{ ALERGIA_PACIENTE : "1:N (Multivalorado)"
    PACIENTE ||--o| PACIENTE_INTERNO : "Especialización (1:1)"
    PACIENTE ||--o| PACIENTE_AMBULATORIO : "Especialización (1:1)"
    MEDICO ||--o{ CONSULTA_MEDICA : "1:N Atiende"
    PACIENTE ||--o{ CONSULTA_MEDICA : "1:N Recibe"
    CONSULTA_MEDICA ||--o{ PRESCRIPCION_DETALLE : "1:N Agregación"
    MEDICAMENTO ||--o{ PRESCRIPCION_DETALLE : "1:N Prescripción"
```

### 2. Restricciones de Integridad en el Modelo Relacional

| Categoría de Integridad | Definición Regla Formal | Mecanismo de Implementación SQL / HIS |
| :--- | :--- | :--- |
| **Integridad de Entidad** | Ningún atributo de la Clave Primaria (`PK`) puede aceptar valores nulos (`NULL`). | `PRIMARY KEY` en cada tabla (ej. `CURP`, `Cédula`). |
| **Integridad Referencial** | Todo valor de una Clave Foránea (`FK`) debe existir en la `PK` referenciada o ser nulo. | `FOREIGN KEY REFERENCES` con `ON DELETE / UPDATE CASCADE / RESTRICT`. |
| **Integridad de Dominio** | Todos los valores de un atributo deben pertenecer al dominio definido. | `CHECK` constraints, `NOT NULL`, tipos de datos precisos. |
| **Reglas de Negocio** | Condiciones semánticas específicas impuestas por el entorno clínico. | `Triggers`, `CHECK` complejas (`sueldo > 0`, `tipo_sangre`). |

### 3. Mapeo Riguroso del Caso Hospitalario (HIS)

| Tabla Relacional | Atributos / Columnas | Claves (PK / FK) | Regla de Mapeo Aplicada |
| :--- | :--- | :--- | :--- |
| `PERSONA` | `curp`, `primer_nombre`, `ap_paterno`, `ap_materno`, `fecha_nacimiento` | **PK:** `curp` | Regla 1: Superclase Aplanada |
| `TELEFONO_PERSONA` | `id_telefono`, `curp_persona`, `telefono` | **PK:** `id_telefono` \| **FK:** `curp_persona` $\rightarrow$ `PERSONA` | Regla 2: Atributo Multivalorado |
| `MEDICO` | `cedula_profesional`, `curp`, `especialidad`, `sueldo` | **PK:** `cedula_profesional` \| **FK:** `curp` $\rightarrow$ `PERSONA (UQ)` | Regla 5: Subclase Heredada |
| `PACIENTE` | `num_expediente`, `curp`, `tipo_sangre` | **PK:** `num_expediente` \| **FK:** `curp` $\rightarrow$ `PERSONA (UQ)` | Regla 5: Subclase Heredada |
| `ALERGIA_PACIENTE` | `id_alergia`, `num_expediente`, `alergia` | **PK:** `id_alergia` \| **FK:** `num_expediente` $\rightarrow$ `PACIENTE` | Regla 2: Atributo Multivalorado |
| `PACIENTE_INTERNO` | `num_expediente`, `num_cama`, `fecha_ingreso` | **PK/FK:** `num_expediente` $\rightarrow$ `PACIENTE` | Regla 5: Subclase Especializada |
| `PACIENTE_AMBULATORIO` | `num_expediente`, `fecha_proxima_cita` | **PK/FK:** `num_expediente` $\rightarrow$ `PACIENTE` | Regla 5: Subclase Especializada |
| `CONSULTA_MEDICA` | `id_consulta`, `cedula_medico`, `num_expediente`, `fecha_hora`, `diagnostico`, `sintomas` | **PK:** `id_consulta` \| **FK1:** `cedula_medico` \| **FK2:** `num_expediente` | Regla 3: Propagación `1:N` |
| `MEDICAMENTO` | `codigo_barras`, `nombre_comercial`, `dosis_recomendada` | **PK:** `codigo_barras` | Regla 1: Entidad Fuerte |
| `PRESCRIPCION_DETALLE` | `id_prescripcion`, `id_consulta`, `codigo_barras`, `indicaciones`, `cantidad` | **PK:** `id_prescripcion` \| **FK1:** `id_consulta` \| **FK2:** `codigo_barras` | Regla 6: Agregación `N:M` |

## Referencias Bibliográficas
* Codd, E. F. (1970). A relational model of data for large shared data banks. Communications of 
the ACM, 13(6), 377-387. 
* Date, C. J. (2004). An introduction to database systems (8th ed.). Addison-Wesley. 
* Elmasri, R., & Navathe, S. B. (2017). Fundamentals of database systems (7th ed.). Pearson. 
* Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). Database system concepts (7th ed.). 
McGraw-Hill. 
---

## 📦 Entregable

- 📄 **Archivo PDF de la Actividad:** [`Tarea_3.1.pdf`](./Tarea_3.1.pdf)
- 💻 **Script SQL DDL Ejecutable:** [`Act_3.1.sql`](./Act_3.1.sql)
- 🎥 **Video Explicativo en YouTube:** [Ver video en YouTube](https://youtu.be/2Uxp1l8Yt1Q)

[![Ver PDF](https://img.shields.io/badge/PDF-Abrir_Tarea_3.1.pdf-EC1C24?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](./Tarea_3.1.pdf)
[![Ver SQL](https://img.shields.io/badge/SQL-Abrir_Act_3.1.sql-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](./Act_3.1.sql)
[![YouTube](https://img.shields.io/badge/YouTube-Ver_Video_Explicativo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/2Uxp1l8Yt1Q)

