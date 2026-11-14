# 📂 Unidad 6: Introducción al Lenguaje SQL (LDD y LMD)

- **Nombre:** Sheyla Estefania Moncada Guel
- **Matricula:** I24050388
- **Maestro:** Ruben Riojas

---

## 📑 Actividades y Estructura de Scripts de la Unidad 6

1. 📁 **[Tarea 6.1: Sintaxis y Clasificación de Sentencias SQL (LDD y LMD)](./Tarea_6.1/)**
   - 📄 Entregable PDF: [`Tarea_6.1.pdf`](./Tarea_6.1/Tarea_6.1.pdf)
   - 🎥 Video en YouTube: [Ver explicación de Tarea 6.1 en YouTube](https://youtu.be/C-cS1zY5zc4)

2. 📁 **[Tarea 6.2: Implementación de Script DDL, Carga de Datos y Consultas DML](./Tarea_6.2/)**
   - 📄 Entregable PDF: [`Tarea_6.2.pdf`](./Tarea_6.2/Tarea_6.2.pdf)
   - 🗄️ **Estructura de Scripts SQL Ejecutables:**
     - 💻 [`01_schema_ddl.sql`](./Tarea_6.2/01_schema_ddl.sql) — Creación de la base de datos `BD_Hospital_SQLServer`, tablas y restricciones (DDL / LDD).
     - 💻 [`02_data_inserts.sql`](./Tarea_6.2/02_data_inserts.sql) — Poblado semilla de datos de prueba (`INSERT INTO` / LMD).
     - 💻 [`03_queries_dml.sql`](./Tarea_6.2/03_queries_dml.sql) — Consultas complejas con subconsultas, `JOIN`, agregaciones y mantenimiento (`UPDATE` / `DELETE`).
   - 📖 **Guía de Despliegue:** [Instrucciones para clonar y ejecutar en el SGBD](./Tarea_6.2/README.md#-instrucciones-para-clonar-y-ejecutar-en-el-sgbd)
   - 🎥 Video en YouTube: [Ver explicación de Tarea 6.2 en YouTube](https://youtu.be/yYAfo22buhA)

---

## 🚀 Instrucciones Rápidas para Clonar y Ejecutar en el SGBD

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/sheylanga/Bases_Datos.git
   cd Bases_Datos/Unidad_6/Tarea_6.2
   ```
2. **Ejecutar en Microsoft SQL Server (SSMS o `sqlcmd`) en orden secuencial:**
   - **Paso 1:** Ejecutar [`01_schema_ddl.sql`](./Tarea_6.2/01_schema_ddl.sql) para construir la base de datos `BD_Hospital_SQLServer` y sus 10 tablas relacionales.
   - **Paso 2:** Ejecutar [`02_data_inserts.sql`](./Tarea_6.2/02_data_inserts.sql) para cargar los registros semilla de prueba.
   - **Paso 3:** Ejecutar [`03_queries_dml.sql`](./Tarea_6.2/03_queries_dml.sql) para correr las consultas complejas `SELECT` y las pruebas de integridad referencial (`UPDATE`, `DELETE CASCADE` y bloqueo `TRY/CATCH`).

---

[⬅️ Volver al README Principal](../README.md)
