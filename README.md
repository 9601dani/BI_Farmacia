# BI_Farmacia
## Cadena de Farmacias “Enfermito te ves más bonito”

---

## Objetivo

Diseñar e implementar una solución de **Business Intelligence (BI)** que permita optimizar los procesos logísticos, de distribución, producción y abastecimiento de la cadena de farmacias “Enfermito te ves más bonito”, mediante la aplicación del ciclo de vida del dato y una arquitectura de BI eficiente.

---

##  Contexto de la Empresa

La empresa cuenta con:
- Sucursales a nivel nacional.
- Tres laboratorios regionales (oriente, centro y occidente).
- Compras internacionales de medicamentos genéricos.
- Una bodega central de distribución.
- Canales de distribución propios.
- Sistema de ventas por sucursal (instancias en la nube sin compartir datos).

---

##  Problemáticas Detectadas

- Inventario creciente por productos con baja rotación.
- Capacidad limitada de la bodega central.
- Pedidos desordenados desde las sucursales.
- Desabastecimiento estacional de medicamentos.
- Retrasos en inspección y almacenamiento de nuevos productos.
- Subutilización de los laboratorios.

---

##  Solución Propuesta

Se propuso una arquitectura de Business Intelligence basada en **MariaDB** y herramientas libres, organizada en fases:

### 1 Arquitectura General
- Arquitectura de BI centralizada.
- Integración de sistemas operacionales mediante procesos ETL.
- Centralización de datos en un **Data Warehouse**.

### 2 Fase de Descubrimiento
- Identificación de fuentes de datos (ventas, compras, distribución, producción).
- Análisis de procesos existentes.
- Levantamiento de requerimientos del negocio.

### 3 Fase de Preparación
- Limpieza y transformación de datos.
- Modelado lógico con MariaDB.
- Creación de tablas y relaciones.

### 4 Fase de Planeación
- Diseño del modelo dimensional.
- Planeación de carga de datos.
- Selección de KPIs clave.

### 5 Fase de Construcción
- Scripts SQL (MariaDB) para creación y carga de datos.
- Modelos E-R y relacional.
- Aplicación de álgebra relacional.
- Construcción de dashboards con datos ficticios.

### 6 Fase de Comunicación
- Dashboards con KPIs estratégicos:
  - Rotación de inventario
  - Productos con alta/baja demanda por región
  - Producción óptima por laboratorio
  - Indicadores de distribución

### 7 Fase de Operacionalización
- Plan para actualización de datos periódica.
- Estrategia de monitoreo y mantenimiento del sistema BI.
- Recomendaciones de escalabilidad.

---

## 🛠️ Tecnologías Utilizadas

- **Base de Datos**: MariaDB
- **ETL / Scripts**: SQL
- **Visualización**: Power BI / Metabase (según disponibilidad)
- **Documentación**: Draw.io, LibreOffice
- **Modelo de Datos**: Relacional y dimensional

---

## Estructura del Repositorio
proyecto_BI_farmacia/
│
├── farmacia_bi/                           # Carpeta principal del proyecto (renombrada para limpieza)
│   ├── PowerBI_FarmaciaBI.pbix           # Reporte Power BI
│   ├── BI_General_Arquitecture.jpg       # Arquitectura general de BI
│   ├── Proyecto_BI.docx                  # Documento principal del proyecto
│   ├── DASHBOARDS_FARMACIA_BI.pdf        # Dashboards exportados en PDF
│
│   ├── Scripts/                          # Scripts SQL utilizados en cada fase
│   │   ├── script_farmacia_bi.sql
│   │   ├── ods_reports_farmacia.sql
│   │   └── construccion_script_modelo.sql
│
│   ├── Imagenes/                         # Diagramas y visualizaciones del proyecto
│   │   ├── farmacia_BI_DER.png
│   │   └── construccion_bi.jpg
│
│   ├── DATA/                             # Datos ficticios para alimentar dashboards
│   │   ├── data 1.xlsx
│   │   ├── data 2.xlsx
│   │   ├── data 3.xlsx
│   │   ├── data 4.xlsx
│   │   ├── data 5.xlsx
│   │   └── Relaciones_PowerBI.png        # Modelo relacional en Power BI



---

## Situación Actual vs. Solución Propuesta

**Antes**: Procesos logísticos desorganizados, inventario sobredimensionado, mala distribución, datos desconectados.  
**Después**: Centralización de datos, mejora en abastecimiento y logística, KPIs en tiempo real, uso eficiente de laboratorios.

---

## Notas

- Todos los datos utilizados en este proyecto son **ficticios** y con fines educativos.
- Se asumió el rol de **gobierno de datos** dentro de la organización.
- Se contempló una solución **escalable y replicable** en otras áreas de la empresa.

---

## Autor

** Erick Morales **  
Científico de Datos | Arquitecto BI  
