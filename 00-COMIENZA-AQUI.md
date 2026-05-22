# PRÓXIMOS PASOS - Soluciona el Error

## Lo que pasó

Tu script `start.bat` ejecutó desde un directorio incorrecto o Docker no estaba completamente listo. **He mejorado el script**, ahora con mejor validación y manejo de errores.

---

## Sigue estos pasos

### Paso 1: Verifica tu Instalación (60 segundos)

```powershell
# Abre PowerShell como Administrador
# Click derecho en PowerShell → "Ejecutar como administrador"

# Ve al directorio del proyecto
cd C:\backend_laravel

# Ejecuta el diagnóstico
.\diagnose.bat
```

**Deberías ver:**
```
Docker versión XX.XX.XX
Docker Compose versión XX.XX.XX
Docker daemon activo
docker-compose.yml
Dockerfile
.env.example
```

**Si ves problemas:**
- Instala Docker Desktop: https://docker.com/products/docker-desktop
- O abre Docker Desktop si ya está instalado

---

### Paso 2: Ejecuta el Script Mejorado

```powershell
# Desde la misma ventana PowerShell (como Admin):
cd C:\backend_laravel
.\start.bat
```

El script ahora:
- Verifica que estás en el directorio correcto
- Valida Docker antes de continuar
- Crea `.env` automáticamente
- Muestra progreso detallado
- Mejor manejo de errores

**Tiempo estimado: 2-3 minutos**

---

### Paso 3: Verifica que Funciona

```powershell
# Ver estado de contenedores
docker-compose ps

# Deberías ver:
# CONTAINER ID  IMAGE                NAMES          STATUS
# xxxxxx        laravel_app:latest   laravel_app    Up (healthy)
# xxxxxx        nginx:alpine         laravel_nginx  Up (healthy)
```

---

### Paso 4: Accede a la Aplicación

Abre en tu navegador:
```
http://localhost
```

Deberías ver la página de bienvenida de Laravel

---

## Alternativas si `start.bat` falla

### Opción A: Ejecución Manual Paso a Paso
```powershell
cd C:\backend_laravel
.\start-manual.bat
```

Esto ejecuta cada comando por separado, así puedes ver dónde falla.

---

### Opción B: Comandos Manuales en PowerShell

```powershell
# 1. Ir al directorio
cd C:\backend_laravel

# 2. Copiar .env
Copy-Item ".env.example" ".env"

# 3. Generar APP_KEY
docker-compose run --rm app php artisan key:generate

# 4. Instalar dependencias
docker-compose run --rm app composer install

# 5. Levantar contenedores
docker-compose up -d

# 6. Esperar 10 segundos...
Start-Sleep -Seconds 10

# 7. Migraciones
docker-compose exec app php artisan migrate --force

# 8. Ver estado
docker-compose ps
```

---

## Próximo: Verifica que Los Tests Funcionan

```powershell
# Una vez que todo está arriba:
docker-compose exec app php artisan test
```

---

## Troubleshooting

| Problema | Solución |
|----------|----------|
| "Docker not found" | Ejecuta `diagnose.bat` para verificar instalación |
| "Docker daemon not running" | Abre Docker Desktop y espera a que esté listo |
| ".env not found" | Asegúrate que hay `.env.example` en el directorio |
| "Port 80 in use" | Edita `docker-compose.yml`: `80:80` → `8080:80` |
| Migraciones fallan | Ejecuta: `docker-compose exec app php artisan migrate:fresh` |

---

## Documentación Disponible

```
README.DOCKER.md              # Referencia rápida
docs/WINDOWS_SETUP.md         # Guía detallada para Windows
DEVOPS_GUIDE.md               # Guía completa (Build, Test, Deploy)
```

---

## Checklist Final

- [ ] Ejecuté `diagnose.bat` y todo está OK
- [ ] Ejecuté `start.bat` sin errores
- [ ] `docker-compose ps` muestra 2 contenedores "Up"
- [ ] Puedo abrir `http://localhost`
- [ ] Tests pasan con `docker-compose exec app php artisan test`

**Si todo OK, Felicidades! Tu Docker DevOps está listo.**

---

## Siguiente Fase: CI/CD en GitLab

Cuando tengas Docker funcionando, el siguiente paso es:

1. Pushear cambios a GitLab
   ```bash
   git add .
   git commit -m "feat: Docker + GitLab CI/CD setup"
   git push origin develop
   ```

2. Configurar variables en GitLab
   - Settings > CI/CD > Variables
   - Agregar: `REGISTRY`, `CI_REGISTRY_USER`, `CI_REGISTRY_PASSWORD`

3. El pipeline se ejecutará automáticamente

---

¿Preguntas? Revisa DEVOPS_GUIDE.md o docs/WINDOWS_SETUP.md
