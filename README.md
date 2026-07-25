DataManagement
===============

Breve descripción
-----------------
DataManagement es una solución para gestión de datos y proyectos relacionados con bases de datos. Contiene proyectos de aplicación, scripts SQL y utilidades para migraciones, pruebas y despliegue.

Contenido principal
-------------------
- Solución Visual Studio (.sln) con los proyectos de la aplicación.
- Carpetas habituales: sql/ (migraciones y scripts), src/ (código fuente), docs/ (documentación), infra/ (infraestructura/devops).

Cómo abrir y compilar
---------------------
1. Abrir DataManagement.sln con Visual Studio 2022/2026.
2. Restaurar paquetes NuGet.
3. Compilar la solución (Build).

Notas sobre configuración
------------------------
- Los archivos de configuración locales y secretos no están en el repositorio (.gitignore los excluye).
- Para ejecutar pruebas o aplicar migraciones, configurar la cadena de conexión en variables de entorno o en archivos locales no versionados (p. ej. appsettings.Development.json).

Contacto
--------
Para más detalles consultar la carpeta docs/ o el histórico de commits para decisiones de diseño.
