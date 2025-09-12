# Sistema de Gestión de Proyectos de Construcción
## Proyecto ABP - Base de Datos en MySQL para Arquitectos e Ingenieros Civiles

---
BUILDARQ – Gestión de Proyectos de Construcción

Proyecto ABP centrado en crear un modelo de base de datos que administre de forma efectiva la gestión de proyectos de construcción. Permite registrar clientes, empleados, materiales, proyectos y sus asignaciones. Además, controla el uso de materiales, calcula presupuestos y genera reportes clave para la toma de decisiones. Es ideal para empresas constructoras, estudios de arquitectura o ingenierías civiles.

Integrantes:
Medrano
Reyes
Burgos
Aumala

##  1. Instrucciones y objetivos del proyecto

Este documento contiene el desarrollo completo del proyecto ABP: análisis, diseño e implementación de una base de datos en MySQL para la gestión de proyectos de construcción. Incluye:

Contexto del problema y necesidades de información.

Modelo conceptual (diagrama entidad-relación y descripción de entidades/relaciones).

Modelo físico (scripts DDL para crear la base de datos y tablas con integridad referencial).

Procedimientos almacenados para carga de datos con validaciones y uso de transacciones.

Consultas SQL que resuelven los informes planteados en el contexto.

Instrucciones para evidenciar con capturas y estructura recomendada del repositorio en GitHub.

##  2. Contexto del problema

Escenario general: Una empresa constructora requiere administrar sus proyectos, clientes, empleados y materiales de manera centralizada. Se necesita una base de datos que permita:

Registrar clientes y sus datos (identificación, contacto, dirección, teléfono).

Registrar proyectos (nombre, descripción, fechas, presupuesto y cliente asociado).

Registrar empleados y asignarlos a proyectos con roles específicos.

Controlar materiales disponibles en stock y su uso en proyectos.

Impedir asignación de materiales si no hay stock suficiente.

Generar reportes de proyectos activos, empleados asignados, materiales utilizados y proyectos con mayor presupuesto.

Necesidades de información:

Datos del cliente: nombre, RUC/CI, correo, dirección, teléfono.

Información de proyectos: nombre, descripción, fecha inicio/fin, presupuesto, cliente asociado.

Información de empleados: nombre, cargo, salario.

Información de materiales: nombre, unidad, precio unitario, stock disponible.

Asignación de empleados y materiales en proyectos.

##  3. Modelo Conceptual (Entidades, atributos y relaciones)
Entidades principales

Cliente

id, nombre, ruc_ci, email, direccion, telefono

Proyecto

id, nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, cliente_id

Empleado

id, nombre, cargo, salario

Asignación (relación Empleado–Proyecto)

id, proyecto_id, empleado_id, rol

Material

id, nombre, unidad, precio_unitario, stock

Uso_Material (relación Proyecto–Material)

id, proyecto_id, material_id, cantidad

Relaciones principales

Un cliente puede tener varios proyectos (1:N).

Un proyecto puede tener varios empleados asignados (N:M mediante Asignaciones).

Un proyecto puede usar varios materiales (N:M mediante Uso_Materiales).

##  Modelo Conceptual (Diagrama Relacional)

### Entidades Principales

| Entidad | Descripción | Atributos Clave |
|---------|-------------|-----------------|
| *PROYECTOS* | Información general de cada obra | codigo_proyecto, nombre, cliente, presupuesto |
| *PERSONAL* | Trabajadores y especialistas | cedula, nombre, especialidad, salario_hora |
| *MATERIALES* | Inventario de materiales | codigo_material, nombre, precio_unitario |
| *TAREAS* | Actividades del cronograma | nombre_tarea, fechas, prioridad, estado |
| *ASIGNACIONES* | Personal asignado a tareas | horas_asignadas, horas_trabajadas |
| *INVENTARIO* | Materiales por proyecto | cantidad_necesaria, disponible, utilizada |
| *GASTOS* | Control financiero | monto, tipo_gasto, fecha, factura |
| *DOCUMENTOS* | Archivos técnicos | nombre_documento, tipo, version |

### Diagrama Entidad-Relación


                    [PERSONAL]
                        │
                        │ N
                        │
                        │ 1
                 [ASIGNACIONES]
                        │
                        │ N  
                        │
                        │ 1
    [MATERIALES] ── [INVENTARIO] ── [PROYECTOS] ── [TAREAS]
          1│N           1│N              1│N         1│N
                                         │
                                         │ 1
                                         │
                                         │ N
                                    [GASTOS]
                                         │
                                         │ 1
                                         │
                                         │ N  
                                   [DOCUMENTOS]


### Relaciones Principales
- PROYECTOS (1) ↔ (N) TAREAS
- PROYECTOS (1) ↔ (N) INVENTARIO  
- PROYECTOS (1) ↔ (N) GASTOS
- PROYECTOS (1) ↔ (N) DOCUMENTOS
- TAREAS (1) ↔ (N) ASIGNACIONES
- PERSONAL (1) ↔ (N) ASIGNACIONES
- MATERIALES (1) ↔ (N) INVENTARIO

---

##  Modelo Físico Implementado

### Características de la Base de Datos

- *Motor*: MySQL 8.0+
- *Codificación*: UTF-8
- *Tablas*: 8 tablas principales
- *Restricciones*: Claves primarias, foráneas y checks
- *Índices*: Optimizados para consultas frecuentes

### Tablas Principales

| Tabla | Propósito | Registros Estimados |
|-------|-----------|-------------------|
| proyectos | Gestión de obras | 50-200 |
| personal | Recursos humanos | 100-500 |
| materiales | Catálogo de insumos | 200-1000 |
| tareas | Cronograma detallado | 500-2000 |
| asignaciones | Personal por tarea | 1000-5000 |
| inventario | Stock por proyecto | 1000-3000 |
| gastos | Control financiero | 2000-10000 |
| documentos | Archivos técnicos | 500-2000 |

---

##  Procedimientos Almacenados con Validaciones

### Procedimientos Implementados

1. *sp_crear_proyecto* - Registra nuevos proyectos
   - Validaciones: fechas, presupuesto, código único
   - Control de integridad referencial

2. *sp_registrar_personal* - Gestiona empleados
   - Validaciones: cédula, email, especialidad
   - Control de duplicados

3. *sp_crear_tarea* - Administra cronogramas
   - Validaciones: fechas lógicas, prioridades
   - Verificación de estado del proyecto

4. *sp_registrar_gasto* - Control financiero
   - Validaciones: montos, tipos de gasto
   - Alertas de sobrepresupuesto

### Características de Validación

- ✅ *Manejo de transacciones* con ROLLBACK automático
- ✅ *Validación de tipos de datos* y rangos
- ✅ *Control de integridad referencial*
- ✅ *Mensajes de error descriptivos*
-  *Verificación de reglas de negocio*

---

## Consultas SQL - Reportes de la Problemática

### Reportes Implementados

#### 1.  *Dashboard de Proyectos*
sql
-- Estado general con indicadores financieros y de progreso
-- Muestra: presupuesto vs gastado, % completado, días restantes

- *Propósito*: Vista ejecutiva del estado de todas las obras
- *Información*: Presupuesto, gastos, avance, cronograma

#### 2.  *Control de Inventario*
sql
-- Inventario por proyecto con alertas de stock
-- Muestra: materiales necesarios, disponibles, faltantes

- *Propósito*: Evitar paros por falta de materiales
- *Información*: Stock actual, necesidades, valores

#### 3.  *Productividad del Personal*
sql
-- Análisis de eficiencia y costos de mano de obra
-- Muestra: horas trabajadas vs asignadas, costo total

- *Propósito*: Optimizar recursos humanos
- *Información*: Eficiencia, costos, especialidades

#### 4.  *Tareas Críticas y Retrasos*
sql
-- Cronograma con alertas de retraso
-- Muestra: tareas vencidas, prioridades, personal asignado

- *Propósito*: Control de cronograma y calidad
- *Información*: Retrasos, responsables, prioridades

#### 5.  *Análisis Financiero*
sql
-- Gastos detallados por tipo y proyecto
-- Muestra: distribución de gastos, tendencias

- *Propósito*: Control de costos y presupuestos
- *Información*: Gastos por categoría, tendencias

#### 6.  *Control de Documentación*
sql
-- Seguimiento de planos, licencias y documentos
-- Muestra: documentos por proyecto, versiones

- *Propósito*: Organización de archivos técnicos
- *Información*: Tipos de documentos, versiones

---

##  Datos de Prueba

### Personal de Prueba Cargado
- *Arquitecto*: Juan Pérez ($15/hora)
- *Ingeniero Civil*: María González ($10/hora) 
- *Maestro de Obra*: Carlos Rodríguez ($10/hora)
- *Electricista*: Ana López ($20/hora)

### Proyectos de Prueba
- *PROJ001*: Edificio Residencial Los Pinos ($250,000)
- *PROJ002*: Casa Campestre Villa María ($85,000)

### Materiales Base
- Estructura

Perfiles de acero galvanizado (montantes, soleras, dinteles y vigas principales).

Tornillos autoperforantes para acero.

Placas de anclaje para la cimentación.

🔹 Envolvente (paredes, techos y pisos)

Placas OSB (tableros de viruta orientada) o placas de cemento para rigidizar muros.

Paneles de yeso (drywall) para interiores.

Placas cementicias o fibrocemento para exteriores.

Láminas de fibrocemento o madera tratada para cielorrasos.

Cubierta de techo: chapas metálicas, tejas asfálticas o tejas de fibrocemento.

Aislantes térmicos y acústicos (lana de vidrio, lana de roca, poliuretano o poliestireno expandido).

Barrera hidrófuga y barrera de vapor (membranas transpirables).

🔹 Pisos

Placas OSB o cementicias sobre la estructura metálica.

Revestimiento final: cerámica, porcelanato, madera flotante, vinílico, etc.

🔹 Otros materiales

Cimientos de hormigón armado (platea o zapatas corridas).

Selladores y cintas aislantes para uniones.

Canalizaciones eléctricas y sanitarias (PVC, cobre, PEX).

Ventanas y puertas (aluminio, PVC o madera).

Revestimientos exteriores: siding vinílico, madera tratada, piedra decorativa, etc.

---

##  Preguntas clave del proyecto
---
¿Qué es?
Es un sistema de gestión de proyectos de construcción que organiza clientes, proyectos, empleados y materiales, facilitando el control del proceso constructivo.

¿Para qué sirve?
Sirve para administrar información clave en el desarrollo de proyectos de construcción, optimizar el uso de materiales, organizar al personal y mejorar la toma de decisiones financieras y logísticas.

¿Para quién está dirigido?
Está dirigido a empresas constructoras, estudios de arquitectura e ingenierías que necesiten un sistema robusto y escalable para controlar su gestión.
