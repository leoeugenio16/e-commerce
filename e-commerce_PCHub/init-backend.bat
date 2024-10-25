@echo off

:: Crear base de datos
psql -U postgres -d postgres -c "CREATE DATABASE ecommerce-PCHUB" || echo "Base de datos ya existe"
echo Creacion de base de datos finalizada.


:: Descargar backup de base de datos desde Google Drive
curl -L -v -o db_backup.sql https://drive.google.com/uc?id=1lI1ZHsVU6-mKspYwTd-IMZGI-M2ihDDq
if %errorlevel% neq 0 (
    echo Error al descargar backup de base de datos
    pause
    exit /b 1
) else if not exist db_backup.sql (
    echo Error: Archivo de backup no descargado
    pause
    exit /b 1
)
echo Descarga de backup finalizada.


:: Restaurar backup de base de datos
psql -U postgres -d ecommerce-PCHUB < db_backup.sql
if %errorlevel% neq 0 (
    echo Error al restaurar backup de base de datos
    pause
    exit /b 1
)
echo Restauracion de backup finalizada.
:: Instalar gdown
npm install -g gdown
if %errorlevel% neq 0 (
    echo Error al instalar gdown
    pause
    exit /b 1
)
echo Instalacion de gdown finalizada.

:: Descargar imágenes desde Google Drive
gdown --id 1-XX0na9dc10OgRtuRKIT8BQ1421UJ4xw --output public/uploads/imagenes.zip
if %errorlevel% neq 0 (
    echo Error al descargar imágenes
    pause
    exit /b 1
) else if not exist public/uploads/imagenes.zip (
    echo Error: Archivo de imágenes no descargado
    pause
    exit /b 1
)
echo Descarga de imágenes finalizada.

:: Descomprimir imágenes
powershell -Command "Expand-Archive -Path 'public/uploads/imagenes.zip' -DestinationPath 'public/uploads' -Force"
if %errorlevel% neq 0 (
    echo Error al descomprimir imágenes
    pause
    exit /b 1
)
echo Descompresion de imágenes finalizada.

:: Eliminar archivo zip
del public/uploads/imagenes.zip

:: Instalar dependencias de Strapi
npm install --force
if %errorlevel% neq 0 (
    echo Error al instalar dependencias de Strapi
    pause
    exit /b 1
)
echo Instalacion de dependencias finalizada.


:: Construir proyecto Strapi
npm run build
if %errorlevel% neq 0 (
    echo Error al construir proyecto Strapi
    pause
    exit /b 1
)
echo Construccion del proyecto finalizada.


:: Iniciar Strapi
npm run start