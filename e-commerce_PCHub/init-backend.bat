@echo off

:: Solicitar nombre de usuario y contraseña de PostgreSQL
set /p PGUSER=Ingrese el nombre de usuario de PostgreSQL (por defecto: root): 
set /p PGPASSWORD=Ingrese la contraseña del usuario %PGUSER% (por defecto: admin): 

:: Establecer valores por defecto si no se ingresan
if "%PGUSER%"=="" set PGUSER=root
if "%PGPASSWORD%"=="" set PGPASSWORD=admin

:: Crear base de datos, ignorando errores si ya existe
psql -U %PGUSER% -d postgres -c "CREATE DATABASE \"ecommerce-PCHUB\"" > nul 2>&1

:: Verificar si la base de datos existe
psql -U %PGUSER% -d postgres -c "SELECT 1 FROM pg_database WHERE datname = 'ecommerce-PCHUB'" | findstr /R /C:"1 row" > nul
if %errorlevel% equ 0 (
    echo Base de datos ecommerce-PCHUB verificada correctamente.
) else (
    echo Error: No se pudo verificar la base de datos
    pause
    exit /b 1
)
:: Pausa breve para asegurar que la base de datos esté lista
ping localhost -n 3 > nul

:: Conectar a la base de datos creada e ignorar error
psql -U %PGUSER% -d ecommerce-PCHUB -c "SELECT 1" > nul 2>&1

:: Descargar backup de base de datos desde Google Drive
curl -L -v -o db_backup.sql "https://drive.google.com/uc?export=download&id=1lI1ZHsVU6-mKspYwTd-IMZGI-M2ihDDq"
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
echo Iniciando restauracion de la base de datos...
psql -U %PGUSER% -d "ecommerce-PCHUB" -f db_backup.sql > restore_log.txt 2>&1
if %errorlevel% neq 0 (
    echo La restauracion continua a pesar de advertencias...
    echo Verificando si la restauracion fue exitosa...
    
    :: Verificar si hay tablas en la base de datos
    psql -U %PGUSER% -d "ecommerce-PCHUB" -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | findstr /R /C:"[1-9]" > nul
    if %errorlevel% equ 0 (
        echo Restauracion completada exitosamente.
        echo Es normal ver algunos mensajes de error durante la restauracion.
    ) else (
        echo ADVERTENCIA: La base de datos parece estar vacia.
        echo Revise restore_log.txt para mas detalles.
        echo Continuando con la configuracion...
    )
) else (
    echo Restauracion completada exitosamente.
)

:: Eliminar archivo de backup temporal
del db_backup.sql
echo Archivo de backup temporal eliminado.

:: Configurar archivo .env
(
echo HOST=0.0.0.0
echo PORT=1337

echo.
echo # Database
echo DATABASE_CLIENT=postgres
echo DATABASE_HOST=localhost
echo DATABASE_PORT=5432
echo DATABASE_NAME=ecommerce-PCHUB
echo DATABASE_USERNAME=%PGUSER%
echo DATABASE_PASSWORD=%PGPASSWORD%
echo DATABASE_SSL=false

echo.
echo # Secrets
echo APP_KEYS=hyhgd5mM9RJXkHqAP5BSyg==,9A0E3hJOomwh3Ym6EKdxPw==,MiKYf5CFcJ0beLyW8o3V1A==,7hO5vmhyiubfMi/hALAmgw==
echo API_TOKEN_SALT=WM6Rr+PL7vXp+D4YU/26CA==
echo ADMIN_JWT_SECRET=R85ZNQ8F1q7I/5UFn8J/3A==
echo TRANSFER_TOKEN_SALT=ozAPDtQeVOH8GJtTehfiHw==

echo.
echo # Storage
echo DATABASE_FILENAME=.tmp/data.db
) > .env

echo Archivo .env configurado correctamente.


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
:: Reconstruir proyecto Strapi
npx strapi build --clean
if %errorlevel% neq 0 (
    echo Error al reconstruir proyecto Strapi
    pause
    exit /b 1
)
echo Reconstruccion del proyecto finalizada.


:: Iniciar Strapi
npm run start