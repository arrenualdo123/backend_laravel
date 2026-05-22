@echo off
setlocal enabledelayedexpansion
REM Quick start script para levantar el proyecto en Docker (Windows)

echo.
echo ========================================
echo   DevOps Practice - Laravel + Docker
echo ========================================
echo.

REM Obtener directorio del script
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

REM Verificar que estamos en el directorio correcto
if not exist docker-compose.yml (
    echo ERROR: docker-compose.yml no encontrado en %CD%
    echo Por favor ejecuta este script desde: c:\backend_laravel\
    pause
    exit /b 1
)

REM Verificar que Docker está instalado
echo [1/7] Verificando Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker no está instalado.
    echo Descargalo desde: https://docs.docker.com/get-docker/
    pause
    exit /b 1
)
echo Docker detectado

REM Verificar que Docker Compose está instalado
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker Compose no está instalado.
    pause
    exit /b 1
)
echo Docker Compose detectado
echo.

REM 1. Copiar .env si no existe
if not exist .env (
    echo [2/7] Creando archivo .env...
    copy ".env.example" ".env" >nul 2>&1
    if errorlevel 1 (
        echo ERROR: No se pudo crear .env
        pause
        exit /b 1
    )
    echo .env creado
) else (
    echo [2/7] .env ya existe
)
echo.

REM 2. Generar APP_KEY
echo [3/7] Generando APP_KEY...
docker-compose run --rm app php artisan key:generate >nul 2>&1
if errorlevel 1 (
    echo Advertencia: No se pudo generar APP_KEY
)
echo Completado
echo.

REM 3. Instalar dependencias PHP
echo [4/7] Instalando dependencias de Composer...
echo Esto puede tomar varios minutos...
docker-compose run --rm app composer install --quiet >nul 2>&1
if errorlevel 1 (
    echo Advertencia: Error en composer install
)
echo Completado
echo.

REM 4. Levantar los contenedores
echo [5/7] Levantando contenedores Docker...
docker-compose up -d
if errorlevel 1 (
    echo ERROR: No se pudieron levantar los contenedores
    pause
    exit /b 1
)
echo Contenedores activos
echo.

REM 5. Esperar a que app esté listo
echo [6/7] Esperando que App esté listo...
timeout /t 8 /nobreak
echo Listo
echo.

REM 6. Ejecutar migraciones
echo [7/7] Ejecutando migraciones...
docker-compose exec -T app php artisan migrate --force >nul 2>&1
if errorlevel 1 (
    echo Advertencia: Migraciones podría no haber completado
)
echo Completado
echo.

REM 7. Instalar dependencias de Node (opcional)
if exist package.json (
    echo Instalando dependencias de npm...
    docker-compose exec -T app npm install --quiet >nul 2>&1
)

echo.
echo ========================================
echo   Proyecto listo
echo ========================================
echo.
echo WEB:     http://localhost
echo STATUS:  docker-compose ps
echo LOGS:    docker-compose logs -f
echo.
echo COMANDOS UTILES:
echo   docker-compose logs -f
echo   docker-compose exec app bash
echo   docker-compose exec app php artisan test
echo   docker-compose down
echo.
echo DOCUMENTACION: DEVOPS_GUIDE.md
echo.
pause
