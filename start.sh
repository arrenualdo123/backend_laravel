#!/bin/bash
# Quick start script para levantar el proyecto en Docker

set -e

echo "Iniciando Práctica DevOps - Laravel en Docker"
echo ""

# Verificar que Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker no está instalado. Descárgalo desde https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar que Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "ERROR: Docker Compose no está instalado."
    exit 1
fi

# 1. Copiar .env si no existe
if [ ! -f .env ]; then
    echo "Creando archivo .env..."
    cp .env.example .env
fi

# 2. Generar APP_KEY
echo "Generando APP_KEY..."
docker-compose run --rm app php artisan key:generate

# 3. Instalar dependencias PHP
echo "Instalando dependencias de Composer..."
docker-compose run --rm app composer install

# 4. Levantar los contenedores
echo "Levantando contenedores..."
docker-compose up -d

# 5. Esperar a que app esté listo
echo "Esperando a que App esté listo..."
sleep 5

# 6. Ejecutar migraciones
echo "Ejecutando migraciones..."
docker-compose exec -T app php artisan migrate --force

# 7. Instalar dependencias de Node (opcional)
if [ -f package.json ]; then
    echo "Instalando dependencias de npm..."
    docker-compose exec -T app npm install
fi

echo ""
echo "Proyecto listo"
echo ""
echo "Accede a la aplicación: http://localhost"
echo ""
echo "Comandos útiles:"
echo "   docker-compose logs -f          # Ver logs en tiempo real"
echo "   docker-compose exec app bash    # Entrar al contenedor"
echo "   docker-compose exec app php artisan test  # Ejecutar tests"
echo "   docker-compose down             # Detener contenedores"
echo ""
echo "Más información en: DEVOPS_GUIDE.md"
