# Usar variable de entorno para la versión de PHP
ARG PHP_VERSION=8.2
FROM php:${PHP_VERSION}-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && rm -rf /var/lib/apt/lists/*

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear usuario para la aplicación
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Cambiar el directorio de trabajo
WORKDIR /var/www

# Cambiar propietario de nuestro directorio de aplicación al usuario www
COPY --chown=www:www . /var/www

# Cambiar al usuario www
USER www

# Exponer puerto 9000 y iniciar php-fpm
EXPOSE 9000
CMD ["php-fpm"] 