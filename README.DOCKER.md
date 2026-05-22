# Docker & DevOps - Referencia Rápida

## Inicio Rápido (60 segundos)

### Windows
```powershell
cd C:\backend_laravel
.\start.bat
# Espera 2-3 minutos
# Abre http://localhost
```

### Linux/Mac
```bash
cd ~/backend_laravel
chmod +x start.sh
./start.sh
```

---

## Verificar que Todo Funciona

```powershell
# Ver estado de contenedores
docker-compose ps

# Debe mostrar:
# CONTAINER ID  NAMES           STATUS
# xxxxx         laravel_app     Up (healthy)
# xxxxx         laravel_nginx   Up (healthy)
```

---

## Problemas Comunes y Soluciones

| Problema | Solución |
|----------|----------|
| "Docker not found" | Instalar Docker Desktop desde docker.com |
| "Port 80 already in use" | Editar docker-compose.yml: `80:80` → `8080:80` |
| "daemon is not running" | Abrir Docker Desktop y esperar |
| ".env not found" | Ejecutar desde `C:\backend_laravel` |
| "Configuration file not found" | Verificar que `docker-compose.yml` existe |
| Migraciones fallan | `docker-compose exec app php artisan migrate:fresh` |

---

## Arquitectura

```
┌─────────────────────────────────┐
│     Cliente (Navegador)         │
│     http://localhost:80         │
└────────────────┬────────────────┘
                 │
┌─────────────────▼────────────────┐
│   Nginx (Alpine)                 │
│   - Reverse Proxy                │
│   - Static files cache           │
│   - Security headers             │
└────────────────┬────────────────┘
                 │
┌─────────────────▼────────────────┐
│   PHP-FPM 8.2 (Alpine)           │
│   - Laravel Application          │
│   - PDO SQLite                   │
│   - Opcache optimizado           │
└────────────────┬────────────────┘
                 │
        ┌────────▼────────┐
        │ SQLite Database │
        │ /database/*.db  │
        └─────────────────┘
```

---

## Ejecutar Tests

```powershell
# Todos los tests
docker-compose exec app php artisan test

# Solo unitarios
docker-compose exec app php artisan test --testsuite=Unit

# Solo features
docker-compose exec app php artisan test --testsuite=Feature

# Con cobertura
docker-compose exec app php artisan test --coverage
```

---

## Comandos Comunes

```powershell
# === CONTENEDORES ===
docker-compose ps                    # Ver estado
docker-compose up -d                 # Iniciar
docker-compose down                  # Detener
docker-compose restart app           # Reiniciar servicio

# === LOGS ===
docker-compose logs -f               # Todos los logs
docker-compose logs -f app           # Logs de app
docker-compose logs -f nginx         # Logs de nginx
docker-compose logs --tail=50 app    # Últimas 50 líneas

# === ACCESO ===
docker-compose exec app bash         # Shell del contenedor
docker-compose exec app php -v       # Version de PHP
docker-compose exec app composer --version  # Version de Composer

# === ARTISAN ===
docker-compose exec app php artisan migrate          # Migrations
docker-compose exec app php artisan tinker           # Tinker REPL
docker-compose exec app php artisan db:seed          # Seeders
docker-compose exec app php artisan make:model Post  # Generar modelo

# === LIMPIAR ===
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan view:clear
docker-compose exec app php artisan optimize:clear
```

---

## Pipeline CI/CD GitLab

El pipeline se ejecuta automáticamente en:

```yaml
Build  │ Cuando: main, develop, merge_requests
       │ Qué: Construye imagen Docker
       │
Test   │ Cuando: main, develop, merge_requests
       │ Qué: Unit + Feature tests + Code quality
       │
Deploy │ Cuando: develop (manual)
       │ Qué: Deploy a staging
```

**Variables necesarias** (GitLab Settings > CI/CD > Variables):
```
REGISTRY = registry.gitlab.com
CI_REGISTRY_USER = tu_usuario
CI_REGISTRY_PASSWORD = tu_token_personal
```

---

## Documentación Completa

- [DEVOPS_GUIDE.md](DEVOPS_GUIDE.md) - Guía extendida
- [docs/WINDOWS_SETUP.md](docs/WINDOWS_SETUP.md) - Guía específica Windows
- [Dockerfile](Dockerfile) - Definición de imagen
- [docker-compose.yml](docker-compose.yml) - Definición de servicios
- [.gitlab-ci.yml](.gitlab-ci.yml) - Pipeline CI/CD

---

## Próximas Prácticas

- [ ] Agregar SAST (Seguridad Estática)
- [ ] Agregar Secret Scanning
- [ ] Agregar Container Scanning
- [ ] Agregar TLS Certificates
- [ ] Agregar Observabilidad (Logs, Monitoring)
- [ ] Auto-scaling con Kubernetes
- [ ] Backup automático

---

Estado: Build, Test, Deploy funcionando  
Última actualización: May 21, 2026
