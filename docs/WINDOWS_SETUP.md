# Guía Rápida para Windows

## Requisitos Previos

```powershell
# 1. Instalar Docker Desktop
# Descargar desde: https://www.docker.com/products/docker-desktop
# Incluye Docker y Docker Compose

# 2. Verificar instalación
docker --version
docker-compose --version
```

## Opción 1: Script Automatizado (Recomendado)

### 1. Abrir PowerShell como Administrador
```powershell
# Click derecho en PowerShell → "Ejecutar como administrador"
```

### 2. Navegar al proyecto
```powershell
cd C:\backend_laravel
```

### 3. Ejecutar el script
```powershell
.\start.bat
```

## Opción 2: Comandos Manuales

### 1. Preparar .env
```powershell
Copy-Item ".env.example" ".env"
```

### 2. Generar clave
```powershell
docker-compose run --rm app php artisan key:generate
```

### 3. Instalar dependencias
```powershell
docker-compose run --rm app composer install
```

### 4. Levantar contenedores
```powershell
docker-compose up -d
```

### 5. Verificar que todo está corriendo
```powershell
docker-compose ps
# Deberías ver 2 contenedores: app y nginx (healthy)
```

### 6. Ejecutar migraciones
```powershell
docker-compose exec app php artisan migrate --force
```

### 7. Verificar en el navegador
```
http://localhost
```

## Comandos Útiles

```powershell
# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f app
docker-compose logs -f nginx

# Entrar a la consola del contenedor
docker-compose exec app bash

# Ejecutar tests
docker-compose exec app php artisan test

# Ejecutar artisan commands
docker-compose exec app php artisan tinker

# Listar contenedores
docker-compose ps

# Detener contenedores
docker-compose down

# Recrear contenedores
docker-compose down
docker-compose up -d

# Ver estado de la app
docker-compose exec app php artisan health
```

## Solución de Problemas

### Error: "Docker daemon is not running"
```powershell
# Abre Docker Desktop
# Espera a que esté completamente listo (ícono en la bandeja)
```

### Error: "port 80 is already in use"
Edita `docker-compose.yml` y cambia el puerto:
```yaml
services:
  nginx:
    ports:
      - "8080:80"  # Usar 8080 en lugar de 80
```
Luego accede a: `http://localhost:8080`

### Error: "permission denied"
Ejecuta PowerShell como Administrador y reintenta

### Base de datos no se crea
```powershell
# Crear archivo de base de datos manualmente
docker-compose exec app bash
touch database/database.sqlite
php artisan migrate --force
exit
```

### Ver si los tests pasan
```powershell
docker-compose exec app php artisan test
```

## Verificar Que Todo Funciona

```powershell
# 1. Contenedores corriendo
docker-compose ps
# Deberías ver STATUS "Up" para todos

# 2. Aplicación accesible
curl http://localhost
# O abre http://localhost en navegador

# 3. Base de datos migrada
docker-compose exec app php artisan migrate:status

# 4. Tests pasando
docker-compose exec app php artisan test
```

## Limpiar Todo

```powershell
# Detener y eliminar contenedores
docker-compose down

# También eliminar volúmenes
docker-compose down -v

# Eliminar imagen
docker rmi backend_laravel-app:latest
```

---

Para más información, ver DEVOPS_GUIDE.md
