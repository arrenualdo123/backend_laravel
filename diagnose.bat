@echo off
REM Script de diagnóstico - Verifica que todo está listo

setlocal enabledelayedexpansion
color 0A

cd /d "%~dp0"

echo.
echo ========================================
echo   DIAGNOSTICO - DevOps + Docker
echo ========================================
echo.

REM 1. Verificar Docker
echo [1] Verificando Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    color 0C
    echo  Docker NO INSTALADO
    echo    Solución: https://www.docker.com/products/docker-desktop
    color 0A
) else (
    for /f "tokens=*" %%i in ('docker --version') do set DOCKER_VERSION=%%i
    echo  !DOCKER_VERSION!
)
echo.

REM 2. Verificar Docker Compose
echo [2] Verificando Docker Compose...
docker-compose --version >nul 2>&1
if errorlevel 1 (
    color 0C
    echo  Docker Compose NO INSTALADO
    color 0A
) else (
    for /f "tokens=*" %%i in ('docker-compose --version') do set DOCKER_COMPOSE_VERSION=%%i
    echo  !DOCKER_COMPOSE_VERSION!
)
echo.

REM 3. Verificar que Docker daemon está corriendo
echo [3] Verificando Docker daemon...
docker ps >nul 2>&1
if errorlevel 1 (
    color 0C
    echo  Docker daemon NO ESTÁ CORRIENDO
    echo    Solución: Abre Docker Desktop
    color 0A
) else (
    echo  Docker daemon activo
)
echo.

REM 4. Verificar archivos necesarios
echo [4] Verificando archivos...
if exist docker-compose.yml (
    echo  docker-compose.yml
) else (
    color 0C
    echo  docker-compose.yml NO ENCONTRADO
    color 0A
)

if exist Dockerfile (
    echo  Dockerfile
) else (
    color 0C
    echo  Dockerfile NO ENCONTRADO
    color 0A
)

if exist .env.example (
    echo  .env.example
) else (
    color 0C
    echo  .env.example NO ENCONTRADO
    color 0A
)

if exist .env (
    echo  .env
) else (
    echo  .env NO existe (se creará con start.bat)
)
echo.

REM 5. Verificar contenedores existentes
echo [5] Contenedores existentes...
for /f "tokens=*" %%i in ('docker-compose ps -q 2^>nul') do (
    echo  Contenedores encontrados: %%i
    goto :containers_found
)
echo  No hay contenedores ejecutándose
:containers_found
echo.

REM 6. Ver puertos disponibles
echo [6] Verificando puertos...
echo  Puerto 80 (Nginx)...
netstat -an | findstr ":80 " >nul 2>&1
if errorlevel 1 (
    echo   Disponible
) else (
    color 0E
    echo   Ya está en uso
    echo    Solución: Cambiar puerto en docker-compose.yml
    color 0A
)
echo.

REM 7. Información de directorio
echo [7] Información de directorio...
echo  Ubicación: %CD%
echo  Archivos: 
for /f %%i in ('dir /b /a-d 2^>nul ^| find /c /v ""') do echo   %%i archivos
for /f %%i in ('dir /b /ad 2^>nul ^| find /c /v ""') do echo   %%i carpetas
echo.

color 0A
echo ========================================
echo   RESUMEN
echo ========================================
echo.
echo Si TODO está OK:
echo   1. Ejecuta: .\start.bat
echo   2. Espera 2-3 minutos
echo   3. Abre: http://localhost
echo.
echo Si hay problemas:
echo   1. Instala lo que falta
echo   2. Abre Docker Desktop
echo   3. Reintenta
echo.
echo Si hay alertas:
echo   1. Lee la solución sugerida
echo   2. Modifica la configuración
echo   3. Reintenta
echo.
pause
