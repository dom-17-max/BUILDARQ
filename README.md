# Sistema de Gestión de Proyectos de Construcción
## Proyecto ABP - Base de Datos en MySQL para Arquitectos e Ingenieros Civiles

---

##  Contexto del Problema

### Escenario General
En el ámbito de la arquitectura y la ingeniería civil, los profesionales trabajan simultáneamente en múltiples proyectos de construcción. Cada uno de estos proyectos implica manejar cronogramas, planos, presupuestos, personal técnico, proveedores, materiales de construcción y documentos legales.

Actualmente, gran parte de esta información se administra de manera desorganizada, utilizando herramientas dispersas como hojas de cálculo, correos electrónicos o documentos físicos. Esta situación genera errores, pérdida de datos, retrasos y sobrecostos en las obras.

### Problemática Planteada
Existe la necesidad de centralizar y organizar la información clave de los proyectos de construcción para facilitar su gestión, seguimiento y control. Una base de datos adecuada permitirá almacenar y consultar datos como:

- **Información general del proyecto**: cliente, fechas, ubicación
- **Inventario de materiales por obra**
- **Registro de tareas y responsables**
- **Documentación técnica como planos o licencias**
- **Presupuestos y gastos detallados**
- **Personal involucrado y proveedores**

### Aspectos que se Pretenden Resolver

**Problemas identificados:**
- ❌ **Desorganización de la información de obra**: Datos dispersos en múltiples herramientas
- ❌ **Falta de control del inventario de materiales**: No hay seguimiento en tiempo real
- ❌ **Dificultad para acceder rápidamente a documentos técnicos**: Planos y licencias mal archivados
- ❌ **Seguimiento deficiente del cronograma de tareas**: Retrasos no controlados
- ❌ **Falta de trazabilidad de gastos y presupuestos**: Sobrecostos inesperados

**Necesidades de información:**
- ✅ Registro completo de proyectos con sus características
- ✅ Control de inventario de materiales en tiempo real
- ✅ Seguimiento detallado de cronogramas y tareas
- ✅ Gestión de personal técnico y proveedores
- ✅ Control financiero de presupuestos vs gastos reales
- ✅ Archivo organizado de documentación técnica

---

##  Modelo Conceptual (Diagrama Relacional)

### Entidades Principales

| Entidad | Descripción | Atributos Clave |
|---------|-------------|-----------------|
| **PROYECTOS** | Información general de cada obra | codigo_proyecto, nombre, cliente, presupuesto |
| **PERSONAL** | Trabajadores y especialistas | cedula, nombre, especialidad, salario_hora |
| **MATERIALES** | Inventario de materiales | codigo_material, nombre, precio_unitario |
| **TAREAS** | Actividades del cronograma | nombre_tarea, fechas, prioridad, estado |
| **ASIGNACIONES** | Personal asignado a tareas | horas_asignadas, horas_trabajadas |
| **INVENTARIO** | Materiales por proyecto | cantidad_necesaria, disponible, utilizada |
| **GASTOS** | Control financiero | monto, tipo_gasto, fecha, factura |
| **DOCUMENTOS** | Archivos técnicos | nombre_documento, tipo, version |

### Diagrama Entidad-Relación

```
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
```

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

- **Motor**: MySQL 8.0+
- **Codificación**: UTF-8
- **Tablas**: 8 tablas principales
- **Restricciones**: Claves primarias, foráneas y checks
- **Índices**: Optimizados para consultas frecuentes

### Tablas Principales

| Tabla | Propósito | Registros Estimados |
|-------|-----------|-------------------|
| `proyectos` | Gestión de obras | 50-200 |
| `personal` | Recursos humanos | 100-500 |
| `materiales` | Catálogo de insumos | 200-1000 |
| `tareas` | Cronograma detallado | 500-2000 |
| `asignaciones` | Personal por tarea | 1000-5000 |
| `inventario` | Stock por proyecto | 1000-3000 |
| `gastos` | Control financiero | 2000-10000 |
| `documentos` | Archivos técnicos | 500-2000 |

---

##  Procedimientos Almacenados con Validaciones

### Procedimientos Implementados

1. **`sp_crear_proyecto`** - Registra nuevos proyectos
   - Validaciones: fechas, presupuesto, código único
   - Control de integridad referencial

2. **`sp_registrar_personal`** - Gestiona empleados
   - Validaciones: cédula, email, especialidad
   - Control de duplicados

3. **`sp_crear_tarea`** - Administra cronogramas
   - Validaciones: fechas lógicas, prioridades
   - Verificación de estado del proyecto

4. **`sp_registrar_gasto`** - Control financiero
   - Validaciones: montos, tipos de gasto
   - Alertas de sobrepresupuesto

### Características de Validación

- ✅ **Manejo de transacciones** con ROLLBACK automático
- ✅ **Validación de tipos de datos** y rangos
- ✅ **Control de integridad referencial**
- ✅ **Mensajes de error descriptivos**
-  **Verificación de reglas de negocio**

---

## Consultas SQL - Reportes de la Problemática

### Reportes Implementados

#### 1.  **Dashboard de Proyectos**
```sql
-- Estado general con indicadores financieros y de progreso
-- Muestra: presupuesto vs gastado, % completado, días restantes
```
- **Propósito**: Vista ejecutiva del estado de todas las obras
- **Información**: Presupuesto, gastos, avance, cronograma

#### 2.  **Control de Inventario**
```sql
-- Inventario por proyecto con alertas de stock
-- Muestra: materiales necesarios, disponibles, faltantes
```
- **Propósito**: Evitar paros por falta de materiales
- **Información**: Stock actual, necesidades, valores

#### 3.  **Productividad del Personal**
```sql
-- Análisis de eficiencia y costos de mano de obra
-- Muestra: horas trabajadas vs asignadas, costo total
```
- **Propósito**: Optimizar recursos humanos
- **Información**: Eficiencia, costos, especialidades

#### 4.  **Tareas Críticas y Retrasos**
```sql
-- Cronograma con alertas de retraso
-- Muestra: tareas vencidas, prioridades, personal asignado
```
- **Propósito**: Control de cronograma y calidad
- **Información**: Retrasos, responsables, prioridades

#### 5.  **Análisis Financiero**
```sql
-- Gastos detallados por tipo y proyecto
-- Muestra: distribución de gastos, tendencias
```
- **Propósito**: Control de costos y presupuestos
- **Información**: Gastos por categoría, tendencias

#### 6.  **Control de Documentación**
```sql
-- Seguimiento de planos, licencias y documentos
-- Muestra: documentos por proyecto, versiones
```
- **Propósito**: Organización de archivos técnicos
- **Información**: Tipos de documentos, versiones

---

##  Datos de Prueba

### Personal de Prueba Cargado
- **Arquitecto**: Juan Pérez ($25/hora)
- **Ingeniero Civil**: María González ($22/hora) 
- **Maestro de Obra**: Carlos Rodríguez ($18/hora)
- **Electricista**: Ana López ($20/hora)

### Proyectos de Prueba
- **PROJ001**: Edificio Residencial Los Pinos ($250,000)
- **PROJ002**: Casa Campestre Villa María ($85,000)

### Materiales Base
- Cemento Portland, Varilla 12mm, Bloques 15cm, Cable 12AWG

---

##  Capturas de Pantalla

### Estructura de Capturas Requeridas

1. ** Ejecución Scripts DDL**
   - Creación de base de datos
   - Creación de tablas
   - Verificación de estructura

2. **⚙ Procedimientos Almacenados**
   - Código de procedimientos
   - Ejecución exitosa
   - Manejo de errores

3. ** Consultas y Reportes**
   - Resultado de cada consulta
   - Datos de ejemplo
   - Interpretación de resultados

4. **Validaciones**
   - Pruebas de integridad
   - Mensajes de error
   - Control de duplicados

---

##
