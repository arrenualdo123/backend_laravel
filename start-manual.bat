@echo off
REM Script manual - Ejecuta comandos paso a paso

setlocal enabledelayedexpansion

REM Cambiar al directorio del script
cd /d "%~dp0"

echo.
echo ========================================
echo   DevOps Practice - Laravel + Docker
echo   MODO MANUAL (paso a paso)
echo ========================================
echo.

echo [PASO 1] Copiar .env...
copy ".env.example" ".env"
echo.

echo [PASO 2] Generar APP_KEY...
docker-compose run --rm app php artisan key:generate
echo.

echo [PASO 3] Instalar Composer...
docker-compose run --rm app composer install
echo.

echo [PASO 4] Levantar contenedores...
docker-compose up -d
echo.

echo [PASO 5] Esperar 10 segundos...
timeout /t 10 /nobreak
echo.

echo [PASO 6] Ejecutar migraciones...
docker-compose exec -T app php artisan migrate --force
echo.

echo [PASO 7] Ver estado de contenedores...
docker-compose ps
echo.

echo.
echo Completado
echo   Accede a: http://localhost
echo.
pause
