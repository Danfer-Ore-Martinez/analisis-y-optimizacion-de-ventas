# SQL Server Data WareHouse
Creando un moderno DataWerehouse utilizando la arquitectura de Medallón

--- 

## Arquitectura del Data WhareHouse
Para el desarrolo y creación de este DWH se utilizará la arquitectura de medallón, es decir separaremos este proyecto en 3 capas, bronce, plata y oro.
![Arquitectura del Data WhareHouse](docs/estructura_dwh.png)

1. **Capa Bronce**: Almacena la información cruda sin procesamiento o limpieza.
2. **Capa Plata**: Se implementan técnicas y estrategias para la lipieza de datos, estandarización de la información y normalización de procesos. 
3. **Capa Oro**: Se tiene la información lista para el negocio, se realizan reportes, análisis e interpretaciones de información (se utiliza esquema de estrella).  
---

## Resumen del Proyecto 
1. **Arquitectura del DWH**: Se implementa una arquitectura moderna de medallón separando el proyecto en 3 capas, **bronce**, **plata** y **oro**.
2. **ETL Pipelines**: Se utiliza un proceso de extracción, transformación y carga de los datos.
3. **Modelamiento de los Datos**: Los datos se modelan siguiendo un esquema de estrella, es decir tablas dimension y tablas fact.
---
## Sobre mi 
Buenos días, buenas tardes o buenas noches, dependiendo de cuando leas esto, mi nombre es Danfer Marcelo Ore, a fecha de finalización (2026-02-09) de este proyecto soy estudiante de ING. Sistemas, actualmente me encuentro en cuarto ciclo, el propósito de este proyecto es mostrar mis capacidades tanto en el manejo de SQL server, como en planificación y estructuración de proyectos. Gracias por leer.
