# Catalogos de Datos para la Capa Oro

## Resumen
La Capa Oro es la capa que representa datos relevantes y utilizado para la toma de deciones en el negocio, la estructura que tiene facilita la creación 
de reportes y análisis de datos. Esta dividida en dos tipo de tablas **Tablas dimension** y **Tablas fact**, cada una representa una metrica del negocio

---

### 1. **oro.dim_clientes**
- **Propósito:** Almacenar información de los clientes, adicionalmente la información es complementada con datos geográficos.
- **Columnas:**

| Nombre Columna   | Tipo de Dato  | Descripción                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| cliente_llave    | INT           | Llave sustituta uníca encargada de identificar cada registro en la tabla dimension.           |
| cliente_id       | INT           | Identificador unico asignado a cada cliente.                                                  |
| codigo_cliente   | NVARCHAR(50)  | Identificador alfanumérico que representa a cada cliente, se usa para rastrear y referenciar. |
| nombre           | NVARCHAR(50)  | Nombre del cliente.                                                                           |      
| apellido         | NVARCHAR(50)  | Apellido del cliente.                                                                         |
| pais             | NVARCHAR(50)  | País de residencia del cliente (e.j., 'Australia').                                           |
| estado_civil     | NVARCHAR(50)  | Estado civil del cliente  (e.j., 'Casado', 'Soltero','n/a').                                  |
| genero           | NVARCHAR(50)  | Género del cliente (e.j., 'Masculino', 'Femenino', 'n/a').                                    |
| fecha_nacimiento | DATE          | Fecha de nacimiento del cliente, formato de fecha YYYY-MM-DD (e.j., 1971-10-06).              |
| fecha_creacion   | DATE          | La fecha en la que fue registrada la información del cliente.                                 |

---

### 2. **oro.dim_productos**
- **Propósito:** Brinda información de los productos y detalles sobre estos. 
- **Columnas:**

| Nombre Columna      | Tipo de Dato     | Descripción                                                                                |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| producto_llave      | INT           | Llave sustituta uníca encargada de identificar cada registro en la tabla dimension.           |
| producto_id         | INT           | Identificador unico asignado a cada producto se usa para rastrear e identificar.              |
| codigo_producto     | NVARCHAR(50)  | Identificador alfanumérico que representa a cada producto, se usa para rastrear y referenciar.|
| nombre_producto     | NVARCHAR(50)  | Nombre descriptivo del producto, tiene detalles importantes commo tipo color y tamaño.        |
| categoria_id        | NVARCHAR(50)  | Un identificador único de la categoría de cada producto.                                      |
| categoria           | NVARCHAR(50)  | Nombre completo de la primera parte del categoria_id (e.j., Bikes -> BI, Components -> CO).   |
| sub_categoria       | NVARCHAR(50)  | Nombre completo de la segunda parte de categoria_id (e.j., Road Flames -> RF).                |
| mantenimiento       | NVARCHAR(50)  | Indica si el producto requiere mantenimiento o no (e.j., 'Yes', 'No').                        |
| precio              | DECIMAL(10,4) | El costo monetario de cada producto.                                                          |
| linea_producto      | NVARCHAR(50)  | La línea de producto o serie a la que pertenece el producto (e.g., Camino, Montaña).          |
| fecha_inicio        | DATE          | La fecha en la que el producto comenzo a estar disponible para la venta.                      |

---

### 3. **oro.fact_ventas**
- **Propósito:** Almacenar información sobre las ordes y trasacciones realizadas, con el propósito de realizar análisis.
- **Columnas:**

| Nombre Columna   | Tipo de Dato  | Descripción                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| numero_orden     | NVARCHAR(50)  | Identificador alfanumérico único para orden  (e.j., 'SO54496').                               |
| cliente_llave    | INT           | Llave sustituta que esta relacionada a la tabla oro.dim_clientes.                             |
| producto_llave   | INT           | Llave sustituta que esta relacionada a la tabla oro.dim_productos.                            |
| fecha_orden      | DATE          | La fecha en que la order fue ingresada.                                                       |
| fecha_entrega    | DATE          | La fecha en la que la orden fue entregada al cliente.                                         |
| fecha_limite     | DATE          | Fecha límite para realizar el pago.                                                           |
| precio           | DECIMAL(10,4) | El precio unitarío de cada producto (e.j., 25).                                               |
| cantidad         | INT           | La cantidad de productos que se van a comprar del producto indicado (e.j., 1, 5).             |
| importe_venta    | DECIMAL(10,4) | El precio total de la venta se obtiene de precio*cantidad (e.j., 50, 75 ).                    |
