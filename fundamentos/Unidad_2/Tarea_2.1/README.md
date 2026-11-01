# 📗 Tarea 2.1: Diseño Conceptual E-R / E-RE del Sistema de Información Hospitalaria (HIS)

---

## 👤 Datos de Identificación

- **Nombre:** Sheyla Estefania Moncada Guel
- **Matricula:** I24050388
- **Maestro:** Ruben Riojas
- **Asignatura:** Fundamentos de Bases de Datos
- **Unidad:** [Unidad 2 — Diseño Conceptual (Modelo E-R, E-RE y UML)](../)

---

## 📝 Descripción

En esta actividad se desarrolla el diseño conceptual completo para un **Sistema de Información Hospitalaria (HIS)** empleando el **Modelo Entidad-Relación Extendido (E-RE)**:
1. **Reglas de Negocio Formales (`RN-01` a `RN-10`):** Definición de restricciones institucionales de identificación única (`CURP`, `Cédula Profesional`, `Número de Expediente`), multivaloración (`Teléfonos`, `Alergias`), atributos derivados (`edad`) y control de prescripción de medicamentos.
2. **Jerarquías de Especialización / Generalización (E-RE):**
   - `Persona` $\rightarrow$ `{Médico, Paciente}`: **Especialización Disjunta y Total (`d, t`)**.
   - `Paciente` $\rightarrow$ `{Paciente_Interno, Paciente_Ambulatorio}`: **Especialización Disjunta y Parcial (`d, p`)**.
3. **Agregación:** Abstracción del evento de `Atención Médica` (`Médico` + `Paciente` + `Consulta_Médica`) para vincular la prescripción `N:M` de `Medicamento` a través de `PRESCRIPCION_DETALLE`.

---

## 📊 Visualización de Gráficos

### 1. Diagrama Formal Entidad-Relación Extendido (E-RE) del Sistema Hospitalario

```mermaid
erDiagram
    PERSONA {
        string curp PK
        string primer_nombre
        string apellido_paterno
        string apellido_materno
        date fecha_nacimiento
        string_list telefonos "Multivalorado"
        int edad_derivada "Derivado"
    }
    MEDICO {
        string cedula_profesional PK
        string curp FK
        string especialidad
        decimal sueldo
    }
    PACIENTE {
        string num_expediente PK
        string curp FK
        string tipo_sangre
        string_list alergias "Multivalorado"
    }
    PACIENTE_INTERNO {
        string num_expediente PK, FK
        int num_cama
        datetime fecha_ingreso
    }
    PACIENTE_AMBULATORIO {
        string num_expediente PK, FK
        date fecha_proxima_cita
    }
    CONSULTA_MEDICA {
        string id_consulta PK
        string cedula_medico FK
        string num_expediente_paciente FK
        datetime fecha_hora
        string diagnostico
        string sintomas
    }
    MEDICAMENTO {
        string codigo_barras PK
        string nombre_comercial
        string dosis_recomendada
    }
    PRESCRIPCION_DETALLE {
        string id_consulta FK
        string codigo_barras FK
        string indicaciones
    }

    PERSONA ||--o| MEDICO : "especializacion_total_disjunta (d,t)"
    PERSONA ||--o| PACIENTE : "especializacion_total_disjunta (d,t)"
    PACIENTE ||--o| PACIENTE_INTERNO : "especializacion_parcial_disjunta (d,p)"
    PACIENTE ||--o| PACIENTE_AMBULATORIO : "especializacion_parcial_disjunta (d,p)"
    MEDICO ||--o{ CONSULTA_MEDICA : "atiende (1:N)"
    PACIENTE ||--o{ CONSULTA_MEDICA : "recibe (1:N)"
    CONSULTA_MEDICA ||--o{ PRESCRIPCION_DETALLE : "genera (Agregacion)"
    MEDICAMENTO ||--o{ PRESCRIPCION_DETALLE : "recetado_en (N:M)"
```

### 2. Identificación y Clasificación de Entidades y Atributos

| Entidad | Atributo Clave (PK) | Atributos Compuestos / Derivados | Atributos Multivalorados / Simples |
| :--- | :--- | :--- | :--- |
| **Persona (Superclase)** | `curp` | `nombre` (`primer_nombre`, `ap_paterno`, `ap_materno`), `edad` `[Derivado]` | `telefonos` `{Multivalorado}`, `fecha_nacimiento` |
| **Médico (Subclase)** | `cedula_profesional` | — | `especialidad`, `sueldo` |
| **Paciente (Subclase)** | `num_expediente` | — | `tipo_sangre`, `alergias` `{Multivalorado}` |
| **Paciente_Interno** | `num_expediente (FK)` | — | `num_cama`, `fecha_ingreso` |
| **Consulta_Médica** | `id_consulta` | — | `fecha_hora`, `diagnostico`, `sintomas` |

### 3. Relaciones, Cardinalidades y Restricciones de Participación

| Relación | Entidades Involucradas | Cardinalidad | Participación | Descripción Técnica |
| :--- | :--- | :---: | :---: | :--- |
| **Realiza** | `Médico` : `Consulta_Médica` | `1 : N` | Médico `(0,N)` - Consulta `(1,1)` | Un médico realiza `N` consultas; una consulta exige `1` médico responsable. |
| **Recibe** | `Paciente` : `Consulta_Médica` | `1 : N` | Paciente `(0,N)` - Consulta `(1,1)` | Un paciente recibe `N` consultas; una consulta pertenece a `1` solo paciente. |
| **Prescribe** | `Atención_Médica (Agregación)` : `Medicamento` | `N : M` | Atención `(0,N)` - Medicamento `(0,M)` | Una atención médica prescribe `N` medicamentos; un medicamento se prescribe en `M` atenciones. |

---

## 📦 Entregable

- 📄 **Archivo PDF de la Actividad:** [`Tarea_2.1.pdf`](./Tarea_2.1.pdf)
- 🎥 **Video Explicativo en YouTube:** [Ver video en YouTube](https://youtu.be/O1hbUj7mWUI)

[![Ver PDF](https://img.shields.io/badge/PDF-Abrir_Tarea_2.1.pdf-EC1C24?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](./Tarea_2.1.pdf)
[![YouTube](https://img.shields.io/badge/YouTube-Ver_Video_Explicativo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/O1hbUj7mWUI)

