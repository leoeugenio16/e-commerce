@echo off

:: Crear base de datos
psql -U postgres -d postgres -c "CREATE DATABASE ecommerce-PCHUB" || echo "Base de datos ya existe"

:: Descargar backup de base de datos desde Google Drive
curl -o db_backup.sql https://drive.google.com/uc?id=162-FQeIojn5B-m9ZeMpTNPxkv_lAkA9M

:: Restaurar backup de base de datos
psql -U postgres -d ecommerce-PCHUB < db_backup.sql

:: Instalar dependencias de Strapi
npm install

:: Construir proyecto Strapi
npm run build

:: Iniciar Strapi
npm run start