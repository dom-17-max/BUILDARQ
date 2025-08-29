Integrantes: Burgos,Medrano,Reyes y Aumala 
 # BUILDARQ

## Aplicación de gestión de proyectos de construcción para arquitectos e ingenieros civiles.

---

##  Contexto

BUILDARQ/
│
├── README.md                # Aquí va el contexto del problema y la explicación del proyecto
│
├── 01_Contexto/
│   └── contexto.md          # Documento con el contexto y problemática (ya lo tienes redactado)
│
├── 02_Modelo_Conceptual/
│   └── modelo_conceptual.png # Imagen o diagrama del modelo conceptual (puede ser hecho en Draw.io, Lucidchart o a mano y escaneado)
│
├── 03_Modelo_Fisico/
│   └── modelo_fisico.sql    # Script con CREATE TABLE (las tablas en MySQL)
│
├── 04_Insercion_Datos/
│   └── inserts.sql          # Script con INSERT INTO para llenar tus tablas con datos de prueba
│
└── 05_Reportes/
    ├── reportes.sql         # Script con las consultas SELECT para generar reportes
    └── capturas/            # Carpeta con capturas de pantalla de los resultados de los reportes


En el ámbito de la arquitectura y la ingeniería civil, es común que los profesionales trabajen simultáneamente en múltiples proyectos de construcción. Cada uno de estos proyectos implica manejar cronogramas, planos, presupuestos, personal técnico, proveedores, materiales de construcción y documentos legales.

Actualmente, gran parte de esta información se administra de manera desorganizada, utilizando herramientas dispersas como hojas de cálculo, correos electrónicos o documentos físicos. Esta situación genera errores, pérdida de datos, retrasos y sobrecostos en las obras.

---

##  Problemática planteada

Existe la necesidad de centralizar y organizar la información clave de los proyectos de construcción para facilitar su gestión, seguimiento y control. Una base de datos adecuada permitiría almacenar y consultar datos como:

- Información general del proyecto (cliente, fechas, ubicación).
- Inventario de materiales por obra.
- Registro de tareas y responsables.
- Documentación técnica como planos o licencias.
- Presupuesto y gastos detallados.
- Personal involucrado y proveedores.

---

## Aspectos que se pretende resolver

- Desorganización de la información de obra.
- Falta de control del inventario de materiales.
- Dificultad para acceder rápidamente a documentos técnicos.
- Seguimiento deficiente del cronograma de tareas.
- Falta de trazabilidad de gastos y presupuesto.
