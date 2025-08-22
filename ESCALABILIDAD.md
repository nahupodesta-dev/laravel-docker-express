# 🚀 Guía de Escalabilidad

Este documento explica cómo usar las funcionalidades de escalabilidad del template Docker para Laravel.

## 🔧 Configuración Básica

### Variables de Entorno

Copia el archivo `.env.example` a `.env` y ajusta las variables según tus necesidades:

```bash
cp .env.example .env
```

#### Variables Principales:

```bash
# Proyecto
COMPOSE_PROJECT_NAME=mi-laravel-app

# Puertos (cambiar si hay conflictos)
HTTP_PORT=9001
MYSQL_PORT=9002
PHPMYADMIN_PORT=9000

# Escalado
APP_SCALE=1          # Número de instancias PHP
WEBSERVER_SCALE=1    # Número de instancias Nginx
```

## 📈 Escalado Horizontal

### 1. Escalado Básico

Para escalar las instancias de PHP y Nginx:

```bash
# Editar .env
APP_SCALE=3
WEBSERVER_SCALE=2

# Aplicar cambios
docker-compose up -d --scale app=3 --scale webserver=2
```

### 2. Escalado con Load Balancer

Para alto tráfico, usa la configuración con load balancer:

```bash
# Usar configuración de escalado
docker-compose -f docker-compose.yml -f docker-compose.scale.yml up -d
```

Esto creará:
- 3 instancias de PHP-FPM
- 2 instancias de Nginx
- 1 Load Balancer (distribuye el tráfico)

## ⚙️ Configuración de Rendimiento

### PHP Optimizations

Las configuraciones de PHP se ajustan automáticamente desde `.env`:

```bash
PHP_MEMORY_LIMIT=512M
PHP_MAX_EXECUTION_TIME=600
PHP_UPLOAD_MAX_FILESIZE=40M
```

### Nginx Optimizations

El template incluye optimizaciones para:
- Cache de archivos estáticos
- Compresión gzip
- Pool de conexiones FastCGI
- Buffers optimizados

## 🔍 Monitoreo

### Health Check

Endpoint de salud disponible en:
```
http://localhost:9001/health
```

### Logs

Ver logs de servicios específicos:
```bash
# Logs de aplicación
docker-compose logs -f app

# Logs del load balancer
docker-compose logs -f load-balancer

# Logs de base de datos
docker-compose logs -f db
```

## 🐳 Comandos de Escalado

### Escalado Manual

```bash
# Escalar PHP a 5 instancias
docker-compose up -d --scale app=5

# Escalar Nginx a 3 instancias
docker-compose up -d --scale webserver=3

# Verificar instancias
docker-compose ps
```

### Escalado Automático

```bash
# Configurar en .env
echo "APP_SCALE=4" >> .env
echo "WEBSERVER_SCALE=2" >> .env

# Aplicar
docker-compose up -d
```

## 🔧 Configuraciones Avanzadas

### Múltiples Proyectos

Para ejecutar múltiples instancias del template:

```bash
# Proyecto 1
COMPOSE_PROJECT_NAME=laravel-api
HTTP_PORT=9001

# Proyecto 2  
COMPOSE_PROJECT_NAME=laravel-web
HTTP_PORT=9011
```

### Recursos Limitados

La configuración de escalado incluye límites de recursos:

```yaml
resources:
  limits:
    cpus: '0.5'
    memory: 512M
  reservations:
    cpus: '0.25'
    memory: 256M
```

## 📊 Rendimiento Esperado

### Configuración Base (1 instancia cada servicio)
- **Tráfico**: ~100 req/seg
- **Memoria**: ~512MB
- **CPU**: ~1 core

### Configuración Escalada (3 PHP + 2 Nginx + LB)
- **Tráfico**: ~500 req/seg
- **Memoria**: ~2GB
- **CPU**: ~3 cores

## 🚨 Consideraciones

### Desarrollo vs Producción

- **Desarrollo**: Usar configuración base
- **Staging**: Usar escalado básico (2-3 instancias)
- **Producción**: Usar load balancer + métricas

### Persistencia de Datos

- La base de datos MySQL es compartida entre todas las instancias
- Los archivos de Laravel están montados como volúmenes
- Para producción, considerar almacenamiento distribuido

## 🔗 Enlaces Útiles

- [Docker Compose Scale](https://docs.docker.com/compose/reference/scale/)
- [Nginx Load Balancing](https://nginx.org/en/docs/http/load_balancing.html)
- [PHP-FPM Performance](https://www.php.net/manual/en/install.fpm.configuration.php) 