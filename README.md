# Informe de pasos para descargar y ejecutar el proyecto en otra máquina


## Requisitos previos

1. Tener Git instalado en la máquina.
2. Tener Node.js y npm instalados en la máquina.
3. Tener PostgreSQL instalado en la máquina.


## Pasos para descargar y ejecutar el proyecto


### #1. Clonar el repositorio
git clone <url-del-repositorio>
### #2. Instalar dependencias
npm install
### #3. Ejecutar archivo BAT
init.bat


### #4. Esperar a que termine la ejecución
El archivo BAT realizará las siguientes acciones:
* Creará la base de datos.
* Descargará el backup de la base de datos.
* Restaurará la base de datos.
* Instalará dependencias de Strapi.
* Construirá el proyecto Strapi.
* Iniciará Strapi.

### Descarcar el sigueinte archivo rar que contiene las imagenes y descompirmir en 

e-commerce_PCHub/public/uploads
estas son todas las imagenes del proyecto


### #5. Iniciar sesión en Strapi
Dirigirse a http://localhost:1337/admin en el navegador.
Iniciar sesión con el correo y contraseña configurados.


### #6. Verificar la configuración
Verificar que la base de datos esté configurada correctamente.
Verificar que Strapi esté funcionando correctamente.


### #7. Abrir el frontend
Dirigirse a http://localhost:3000 en el navegador para acceder al frontend.


### #8. Realizar ajustes necesarios
Realizar ajustes en la configuración si es necesario.
Verificar los logs de Strapi y PostgreSQL.


### #9. Listo para usar
El proyecto estará ejecutándose y listo para usar.


## Notas adicionales
Asegúrate de que la configuración de PostgreSQL esté correcta.
Verifica que los archivos BAT estén configurados correctamente.
Si encuentras algún error, verifica los logs de Strapi y PostgreSQL.
