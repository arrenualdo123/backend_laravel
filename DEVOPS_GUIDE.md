# Práctica DevOps - Guía de Configuración

## Requisitos

- Docker y Docker Compose instalados
- Git configurado
- GitLab CI/CD habilitado (si usas GitLab)
- SSH configurado para deploy (solo si usas staging)

## Quick Start - Ejecución Local con Docker

### 1. Preparar el proyecto

```bash
# Clonar o navegar al proyecto
cd backend_laravel

# Generar .env
cp .env.example .env

# Generar clave de aplicación
docker-compose run --rm app php artisan key:generate

# Instalar dependencias
docker-compose run --rm app composer install

# Ejecutar migraciones (con profile setup)
docker-compose --profile setup run --rm migrate
```

### 2. Iniciar contenedores

```bash
# Levantar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Acceder a la aplicación
# http://localhost

# Ejecutar artisan commands
docker-compose exec app php artisan tinker
docker-compose exec app php artisan test

# Detener servicios
docker-compose down
```

## Estructura Docker

- **app**: PHP-FPM 8.2 con extensiones necesarias
- **nginx**: Servidor web con optimizaciones
- **migrate**: Ejecuta migraciones al inicio (opcional)

## Testing Local (Antes de Push)

```bash
# Tests unitarios
docker-compose exec app php artisan test --testsuite=Unit

# Tests de features
docker-compose exec app php artisan test --testsuite=Feature

# Todos los tests con cobertura
docker-compose exec app php artisan test --coverage

# Code quality check con Pint
docker-compose exec app php ./vendor/bin/pint app/
```

## Pipeline CI/CD GitLab

### Stages:

1. **build** - Construye y pushea imagen Docker
   - Requiere: `CI_REGISTRY_USER`, `CI_REGISTRY_PASSWORD`
   - Se ejecuta en: `main`, `develop`, `merge_requests`

2. **test** - Ejecuta tests automáticamente
   - Unit tests
   - Feature tests
   - Code quality checks
   - Genera reporte de cobertura

3. **deploy** - Deploy a staging (manual)
   - Requiere variables: `STAGING_HOST`, `STAGING_USER`, `STAGING_PATH`, `SSH_PRIVATE_KEY`
   - Solo en `develop` con trigger manual

### Configuración en GitLab

#### Variables necesarias (Settings > CI/CD > Variables):

**Para Registry (Docker Hub o GitLab):**
```
REGISTRY = registry.gitlab.com
CI_REGISTRY_USER = tu_usuario
CI_REGISTRY_PASSWORD = tu_token_personal
```

**Para Staging Deploy:**
```
STAGING_HOST = 192.168.1.100
STAGING_USER = deploy_user
STAGING_PATH = /app/laravel
SSH_PRIVATE_KEY = [contenido de tu clave privada]
```

### Cómo usar el Pipeline

1. **Hacer push a develop** - Se ejecutan Build + Tests automáticamente
2. **Crear Merge Request** - Se valida con tests antes de mergear
3. **Merge a main** - Se despliega a producción (si está configurado)

## Componentes del Pipeline Explicados

### Build Stage
```yaml
build:image:
  - Construye imagen Docker multistage
  - La pushea al registro (GitLab Container Registry)
  - Se ejecuta siempre en main/develop
```

### Test Stages
```yaml
test:unit:
  - Ejecuta tests unitarios
  - Genera cobertura de código
  
test:feature:
  - Ejecuta tests de integración/features
  
test:code-quality:
  - Valida formato con Pint
  - Análisis estático con PHPStan (opcional)
```

### Deploy Stage
```yaml
deploy:staging:
  - Conéctese vía SSH
  - Git checkout del commit
  - Pull/up de docker-compose
  - Ejecuta migraciones
  - Limpia caché
```

## Seguridad

Configurado:
- Non-root user (www-data)
- Security headers en Nginx
- .env en .gitignore
- Image multistage (reduce tamaño/vulnerabilidades)
- PHP-FPM con socket unix

Próximos pasos para mejorar seguridad:
- [ ] Usar secrets manager (HashiCorp Vault)
- [ ] Container scanning con Trivy
- [ ] SAST (Static Analysis) en pipeline
- [ ] Signed commits en Git
- [ ] TLS/SSL certificates
- [ ] Network policies en Docker

## Troubleshooting

### Error: "docker: not found"
```bash
# Instalar Docker Desktop o Docker Engine
# https://docs.docker.com/get-docker/
```

### Error: "permission denied" en artisan
```bash
docker-compose exec app chmod +x artisan
```

### Base de datos no se migra
```bash
# Verificar que sqlite está en el contenedor
docker-compose exec app php -m | grep pdo

# Crear BD manualmente
docker-compose exec app touch database/database.sqlite
docker-compose exec app php artisan migrate --force
```

### Puerto 80 ya en uso
```bash
# Cambiar puerto en docker-compose.yml
# ports:
#   - "8080:80"  # usar 8080 en lugar de 80
```

## Recursos Útiles

- [Docker Documentation](https://docs.docker.com/)
- [Laravel Sail](https://laravel.com/docs/12/sail)
- [GitLab CI/CD Docs](https://docs.gitlab.com/ee/ci/)
- [PHP FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [Nginx Best Practices](https://github.com/h5bp/server-configs-nginx)

## Próximas Prácticas DevOps

1. **Seguridad**: Agregar SAST, Secret scanning, Dependency check
2. **Observabilidad**: ELK stack, Prometheus, Grafana
3. **Auto-scaling**: Kubernetes, Docker Swarm
4. **Backup**: Automated DB backups, Object storage
5. **CDN**: CloudFront, Cloudflare integration
6. **Infrastructure as Code**: Terraform, Ansible

---

Estado: Build, Test y Deploy básicos configurados
Próximo paso: Agregar seguridad al pipeline
