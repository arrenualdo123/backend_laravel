# ==========================================
# STAGE 1: BUILDER
# ==========================================

FROM php:8.2-fpm-alpine AS builder

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Dependencias del sistema
RUN apk update && apk upgrade --no-cache && \
    apk add --no-cache \
    curl \
    git \
    unzip \
    zip \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    sqlite-dev

# Extensiones PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_sqlite \
    opcache

WORKDIR /app

# Copiar composer primero (mejor cache)
COPY composer.json composer.lock ./

# Instalar dependencias
RUN composer install \
    --no-interaction \
    --no-progress \
    --optimize-autoloader

# Ahora copiar el resto del proyecto
COPY . .

# ==========================================
# STAGE 2: PRODUCTION
# ==========================================

FROM php:8.2-fpm-alpine

# Runtime libs
RUN apk update && apk upgrade --no-cache && \
    apk add --no-cache \
    libpng \
    libjpeg-turbo \
    freetype \
    sqlite-libs

# Composer también en producción (para CI/tests)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Extensiones PHP
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Optimización PHP
RUN echo "memory_limit = 256M" > /usr/local/etc/php/conf.d/custom.ini && \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/custom.ini

WORKDIR /app

# Copiar aplicación
COPY --from=builder /app /app

# Permisos Laravel
RUN mkdir -p \
    storage/logs \
    storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views \
    bootstrap/cache && \
    chown -R www-data:www-data storage bootstrap/cache

# Usuario no-root
USER www-data

# Puerto PHP-FPM
EXPOSE 9000

# Healthcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD php -r "exit(0);"

CMD ["php-fpm"]