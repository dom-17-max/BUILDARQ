BUILDARQ – Gestión de Proyectos de Construcción

Proyecto ABP centrado en crear un modelo de base de datos que administre de forma efectiva la gestión de proyectos de construcción. Permite registrar clientes, empleados, materiales, proyectos y sus asignaciones. Además, controla el uso de materiales, calcula presupuestos y genera reportes clave para la toma de decisiones. Es ideal para empresas constructoras, estudios de arquitectura o ingenierías civiles.

Integrantes:

• Triviño
• Aumala Domenika

1. Instrucciones y objetivos del proyecto

Este documento contiene el desarrollo completo del proyecto ABP: análisis, diseño e implementación de una base de datos en MySQL para la gestión de proyectos de construcción. Incluye:

Contexto del problema y necesidades de información.

Modelo conceptual (diagrama entidad-relación y descripción de entidades/relaciones).

Modelo físico (scripts DDL para crear la base de datos y tablas con integridad referencial).

Procedimientos almacenados para carga de datos con validaciones y uso de transacciones.

Consultas SQL que resuelven los informes planteados en el contexto.

Instrucciones para evidenciar con capturas y estructura recomendada del repositorio en GitHub.

2. Contexto del problema

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

3. Modelo Conceptual (Entidades, atributos y relaciones)
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

📌 Diagrama simplificado:
Clientes (1) --- (N) Proyectos (1) --- (N) Asignaciones (N) --- (1) Empleados
Proyectos (1) --- (N) Uso_Materiales (N) --- (1) Materiales

Preguntas clave del proyecto

¿Qué es?
Es un sistema de gestión de proyectos de construcción que organiza clientes, proyectos, empleados y materiales, facilitando el control del proceso constructivo.

¿Para qué sirve?
Sirve para administrar información clave en el desarrollo de proyectos de construcción, optimizar el uso de materiales, organizar al personal y mejorar la toma de decisiones financieras y logísticas.

¿Para quién está dirigido?
Está dirigido a empresas constructoras, estudios de arquitectura e ingenierías que necesiten un sistema robusto y escalable para controlar su gestión.
