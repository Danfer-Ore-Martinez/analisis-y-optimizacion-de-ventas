# Reporet-Ventas-Clientes-Power-BI

## Introducción
Este dashboard fue creado para que **la gerencia de ventas**, pueda obtener una reporte facíl de entender.  
Este reporte muestra indicadores claros de ventas, analisis a lo largo del tiempo, detalles de ventas e información de clientes. 
![Dashboard Video Guia](imagenes/video_dashboard.gif)

 **Link Dashboard**  
https://drive.google.com/drive/folders/1xXReEKKg35uWUMz1mxZ1lfzVP1itynKx?usp=drive_link  
Por cuestiones de peso no lo puedo subir en github, y tampoco lo puedo hacer publico por no tener la licencia pro de Power BI :(

## Resumen del Dashboard
### Página 1: Reporte General de Trabajos
![Dashboard Pagina 1](imagenes/p1.png)
Es una vista general de los puestos de trabajo. Para ello se emplean KPIs como `Cantidad Puestos`, `Mediana Salario Anual` y `Mediana Salario por Hora`. Con estos datos podemos tener ideas generales del puesto o puestos de trabajo seleccionados; ello permite entender qué está pasando con esos puestos y ayuda en la toma de decisiones.

### Página 2: Reporte Trabajo Específico
![Dashboard Pagina 2](imagenes/p2.png)
Es una vista más específica del puesto de trabajo seleccionado; permite ver mayor cantidad de detalles como `Cantidad de Puestos por País`, `Forma de Trabajo`, `Trabajo Remoto`, `No solicita título`, `Seguro Médico Laboral`. Estos datos nos ayudan a entender si el puesto cumple con nuestras expectativas; si ese es el caso, en qué plataforma tenemos mayor probabilidad de ser contratados.

## Habilidades Mostradas
  - **Esquema de Estrella**: Se implementa un esquema de estrella compuesto por una tabla de hechos principal `job_postings_fact` y múltiples tablas de dimensiones, incluyendo `schedule_dim`, `company_dim`, `date_dim`, `skills_job_dim` y `skills_dim`.
- **Métricas Específicas**: Se desarrollan métricas orientadas a negocio que permiten obtener KPIs clave como `Mediana Salario Anual` y `Mediana Salario por Hora`.
- **Gráficos Relevantes**: Se emplean **gráficos de barra**, **línea** y **dona** para analizar comparaciones, tendencias temporales y distribuciones binarias.
- **Análisis Geoespacial**: Se incorporan **gráficos de mapa** para representar la distribución geográfica de los puestos de trabajo a nivel global.
- **KPIs y Tablas**: Se utilizan **tarjetas** para destacar indicadores clave como `Mediana Salario Anual`, `Mediana Salario por Hora`, `Cantidad de Puestos de Trabajo` y `Ranking Salario Anual`. Las tablas complementan el análisis mostrando el detalle de la información visualizada en los gráficos.
- **Diseño del Dashboard**: Se diseña una interfaz clara, intuitiva y visualmente amigable, priorizando la simplicidad y enfocando cada sección en los elementos más relevantes para el análisis.
- **Reporte Interactivo**:
  - **Filtros**: Implementación de filtros dinámicos por puesto de trabajo.
  - **Botones y Bookmarks**: Uso de controles interactivos para optimizar la navegación del usuario.
  - **Drill Through**: Habilitación de navegación jerárquica desde una vista general `Reporte General Trabajos` hacia una vista detallada `Reporte Trabajo Específico`.
- **Power Query**: Uso de `Power Query` para la transformación y limpieza de datos, así como la creación de nuevas tablas (`schedule_dim`) y columnas (`salary_year_and_hour`, `salary_bucket`).
- **Vista de Modelo**: Modelado de datos mediante la relación entre tablas `dim` y la tabla `fact`, incluyendo la configuración de filtros unidireccionales y bidireccionales.
- **DAX**: Desarrollo de cálculos avanzados utilizando `DAX`, incluyendo la creación de columnas como `Numero Habilidades` y tablas completas como `date_dim`.
- **Cálculos**: Implementación de medidas personalizadas mediante `Nuevo Calculo`, como `Cantidad Puestos`, `Cantidad Skills` y `Skills por Trabajo`.
- **Parámetros**: Uso de `Nuevo Parametro` para alternar entre métricas como `Mediana Salario Anual` y `Mediana Salario por Hora`, permitiendo la visualización dinámica en un mismo gráfico.
- **Edición de Interacciones**: Se optimizan las interacciones entre las diferentes tablas con el objetivo de mejorar la dinámica y usabilidad del reporte.
## Conclusiones
Este Dashboard muestra cómo Power BI puede transformar información cruda en un reporte completo, lleno de información importante para cualquier persona que busque información sobre trabajos relacionados con datos. Se utilizan filtros, slicers y Drill Through para poder filtrar y segmentar la información con el objetivo de un mejor entendimiento.

## Sobre Mi 
Buenos días, buenas tardes o buenas noches, dependiendo de cuando leas esto, soy un Estudiante de Ing. Sistemas mi nombre es Danfer Marcelo Ore, me quiero especializar en análisis de datos, este proyecto busca demostrar mi manejo en Power BI.
