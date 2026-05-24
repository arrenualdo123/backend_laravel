# === STAGE 1: BUILDER ===
FROM php:8.2-fpm-alpine AS builder

# Actualizar el sistema e instalar dependencias necesarias para compilar
RUN apk update && apk upgrade --no-cache \
    && apk add --no-cache \
    curl \
    git \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    sqlite-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_sqlite \
    opcache

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copiar archivos de configuración de Composer
COPY composer.json composer.lock ./

# Instalar dependencias de PHP de producción
RUN composer install \
    --no-dev \
    --no-interaction \
    --no-progress \
    --no-scripts \
    --optimize-autoloader

# === STAGE 2: FINAL PRODUCTION IMAGE ===
FROM php:8.2-fpm-alpine

# Aplicar actualizaciones de seguridad también en la imagen final y añadir librerías runtime
RUN apk update && apk upgrade --no-cache \
    && apk add --no-cache \
    libpng \
    libjpeg-turbo \
    freetype \
    sqlite-libs

# 🔥 TRUCO DEVSECOPS: Copiar las extensiones ya compiladas y configuradas desde el builder
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Agregar optimizaciones extras de producción para PHP
RUN echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

WORKDIR /app

# Copiar código de la aplicación
COPY --chown=www-data:www-data . .

# Copiar las dependencias de vendor desde el builder
COPY --from=builder --chown=www-data:www-data /app/vendor /app/vendor

# Crear directorios necesarios y asignar permisos
RUN mkdir -p storage/logs bootstrap/cache storage/framework/views && \
    chown -R www-data:www-data storage bootstrap/cache

# Exponer puerto
EXPOSE 9000

# Healthcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD php -r 'exit(0);' || exit 1

# Usuario seguro no-root
USER www-data

CMD ["php-fpm"]