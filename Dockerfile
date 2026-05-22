# Multistage build para optimizar imagen final
FROM php:8.2-fpm-alpine AS builder

# Instalar dependencias necesarias
RUN apk add --no-cache \
    curl \
    git \
    libpng-dev \
    libjpeg-turbo-dev \
    libfreetype6-dev \
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

# Instalar dependencias de PHP
RUN composer install \
    --no-dev \
    --no-interaction \
    --no-progress \
    --optimize-autoloader

# Stage final: imagen ligera de producción
FROM php:8.2-fpm-alpine

# Instalar extensiones necesarias en la imagen final
RUN apk add --no-cache \
    libpng \
    libjpeg-turbo \
    freetype \
    sqlite-libs \
    && docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_sqlite \
    opcache

# Copiar configuración de PHP optimizada
RUN echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

WORKDIR /app

# Copiar código de la aplicación
COPY --chown=www-data:www-data . .

# Copiar dependencias del builder
COPY --from=builder --chown=www-data:www-data /app/vendor /app/vendor

# Crear directorios necesarios y asignar permisos
RUN mkdir -p storage/logs bootstrap/cache storage/framework/views && \
    chown -R www-data:www-data storage bootstrap/cache

# Exponer puerto
EXPOSE 9000

# Healthcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD php -r 'exit(0);' || exit 1

# Usuario www-data para seguridad
USER www-data

CMD ["php-fpm"]
