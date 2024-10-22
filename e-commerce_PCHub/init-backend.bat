@echo off

:: Crear base de datos
psql -U postgres -d postgres -c "CREATE DATABASE ecommerce-PCHUB"

:: Restaurar backup de base de datos
psql -U postgres -d ecommerce-PCHUB < db_backup.sql

:: Instalar dependencias de Strapi
npm install

:: Construir proyecto Strapi
npm run build

:: Iniciar Strapi
npm run start