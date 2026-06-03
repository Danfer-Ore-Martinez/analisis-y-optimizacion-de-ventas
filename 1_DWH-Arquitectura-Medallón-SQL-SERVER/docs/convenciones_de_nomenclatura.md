# **Convenciones de Nomenclatura**

Este documento describe las convenciones de nomenclatura utilizadas para schemas, tables, views, columns y otros objetos en el DWH.

## **Tabla de Contenido**

1. [Principios Generales](#Principios-generales)
2. [Convenciones de Nomenclatura para Tablas](#Convenciones-de-Nomenclatura-para-Tablas)
   - [Reglas Capa Bronce](#Reglas-Capa-Bronce)
   - [Reglas Capa Plata](#Reglas-Capa-Plata)
   - [Reglas Capa Oro](#Reglas-Capa-Oro)
3. [Convenciones de Nomenclatura para Columnas](#Convenciones-de-Nomenclatura-para-Columnas)
   - [Llaves Sustitutas](#Llaves-Sustitutas)
   - [Columnas Técnicas](#Columnas-Técnicas)
4. [Stored Procedure](#Stored-Procedure)
---

## **Principios Generales** 

- **Convenciones de Nomenclatura**: Usar snake_case, todo en minusculas y usando guión bajo (`_`) para separar las palabras.
- **Idioma**: Usar Español para los nombres, las capas bronce y plata tendrán los nombres de los recursos originales.
- **Sobre las Palabras Reservadas**: No utilizar palabras reservadas de SQL para nombrar.

## **Convenciones de Nomenclatura para Tablas**

### **Reglas Capa Bronce**
- Todos los nombres comienzan con el recurso de donde provienen, y las tablas mantienen sus nombre originales el único cambio es que es todo en minusculas.
- **`<recuso_del_sistema>_<entidad>`**  
  - `<recuso_del_sistema>`: El nombre de los recursos del sistema de donde provienen, ejemplo `crm`,`erp`.  
  - `<entidad>`: El nombre exacto del archivo de donde proviene.  
  - Ejemplo: `crm_customer_info` → Información del cliente que proviene del recurso CRM.

### **Reglas Capa Plata**
- Todos los nombres comienzan con el recurso de donde provienen, y las tablas mantienen sus nombre originales el único cambio es que es todo en minusculas.
- **`<recuso_del_sistema>_<entidad>`**  
  - `<recuso_del_sistema>`: El nombre de los recursos del sistema de donde provienen, ejemplo `crm`,`erp`. 
  - `<entidad>`: El nombre exacto del archivo de donde proviene. 
  - Ejemplo: `crm_customer_info` → Información del cliente que proviene del recurso CRM.

### **Reglas Capa Oro**
- Todos los nombre tienen que estar relacionados con el negocio.
- **`<categoria>_<entidad>`**  
  - `<categoria>`: Describe el rol de la tabla, por ejemplo, `dim`  o `fact`.  
  - `<entidad>`: Describe el nombre de la tabla, siguiendo la logica y estructura del negocio (ejemplo:, `clientes`, `productos`, `ventas`).  
  - ejemplos:
    - `dim_clientes` → Tabla dimension de la información del cliente.  
    - `fact_ventas` → Tabla fact que almacena la información de las ventas.  

#### **Diccionario de pre-fijos**

| Pre-fijo    | Significado                      | Ejemplo(s)                                |
|-------------|----------------------------------|-------------------------------------------|
| `dim_`      | Tabla de Dimension               | `dim_clientes`, `dim_productos`           |
| `fact_`     | Tabla de Fact                    | `fact_ventas`                             |
| `report_`   | Tabla de Reporte                 | `report_clientes`, `report_ventas_por_mes`|

## **Convenciones de Nomenclatura para Columnas**

### **Llaves Sustitutas**  
- Todas las llaves primarias en las tablas dimension tienen el sufijo `_llave`.
- **`<nombre_tabla>_llave`**  
  - `<nombre_tabla>`: Se refiere a la tabla a la que pertenece la llave.
  - `_llave`: Un sufijo indicando que esta es una llave sustituta.  
  - Ejemplo: `cliente_llave` → Llave sustitua en la tabla `dim_cliente`.
  
### **Columnas Técnicas**
- Todas las columnas tecnicas comienzan con el prefijo `dwh_`, seguido del nombre de la columna que explica el contenido de esta.
- **`dwh_<nombre_columna>`**  
  - `dwh`: Prefijo creado especifícamente para la meta-data generada por el sistema.  
  - `<nombre_columna>`: Describe el nombre el contenido que esta columna representa.  
  - Ejemplo: `dwh_fecha_carga` → Columna que genera el sistema para indicar en que fecha se cargo ese registro.
## **Stored Procedure**

- Todos los Stored Procedure utilizan la plabra `carga`, indicando que se esta cargando información en esa capa  :
- **`carga_<capa>`**.
  
  - `<capa>`: Representa la capa en donde se cargara información, por ejemplo `bronce`, `plata`, o `oro`.
  - Ejemplo: 
    - `carga_bronce` → Stored procedure que carga los registros en la capa bronce.
    - `carga_plata` → Stored procedure que carga los registros en la capa plata.
