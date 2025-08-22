# 🚀 Laravel Docker Express

[![Laravel](https://img.shields.io/badge/Laravel-12.x-FF2D20?style=for-the-badge&logo=laravel)](https://laravel.com)
[![PHP](https://img.shields.io/badge/PHP-8.2-777BB4?style=for-the-badge&logo=php)](https://php.net)
[![Docker](https://img.shields.io/badge/Docker-20.x-2496ED?style=for-the-badge&logo=docker)](https://docker.com)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql)](https://mysql.com)
[![Nginx](https://img.shields.io/badge/Nginx-1.25-009639?style=for-the-badge&logo=nginx)](https://nginx.org)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Stars](https://img.shields.io/github/stars/nahupodesta-dev/laravel-docker-express?style=for-the-badge)](https://github.com/nahupodesta-dev/laravel-docker-express/stargazers)
[![Forks](https://img.shields.io/github/forks/nahupodesta-dev/laravel-docker-express?style=for-the-badge)](https://github.com/nahupodesta-dev/laravel-docker-express/network/members)

**Estado: COMPLETADO Y FUNCIONAL** ✅

Template Docker para Laravel con **instalación express** y **escalabilidad enterprise**. Incluye documentación completa en español y configuración automática.

> ⚡ **Instalación en 1 comando**: `./install.sh mi-proyecto`

## 🏷️ Keywords
`laravel` `docker` `template` `php8.2` `mysql8` `nginx` `php-fpm` `composer` `phpmyadmin` `development` `production` `scalable` `enterprise` `load-balancing` `spanish` `español` `express` `quick-start`

## ⚠️ Estado del Proyecto

Este es un proyecto **completado y funcional** que se comparte "tal como está".
- ✅ **Funciona perfectamente** para desarrollo y producción
- ✅ **Documentación completa** incluida
- ✅ **Escalabilidad enterprise** con load balancing
- ✅ **No requiere mantenimiento** adicional
- ❌ **No se aceptan PRs** ni nuevas funcionalidades
- ❌ **No hay soporte técnico** disponible

**¡Es así de simple!** 🎯

## 📋 **Stack incluido:**

- **🌐 Nginx** - Servidor web (Puerto 9001)
- **⚡ PHP 8.2-FPM** - Procesador PHP con extensiones
- **🗄️ MySQL 8.0** - Base de datos (Puerto 9002)
- **🔧 phpMyAdmin** - Gestión visual de BD (Puerto 9000)
- **📦 Composer** - Gestor de dependencias PHP

## 🚀 **Instalación Express (Recomendado):**

### **Opción 1: Instalación automática con un comando**
```bash
# Clonar el repositorio
git clone https://github.com/nahupodesta-dev/laravel-docker-express
cd laravel-docker-express

# Instalación básica (recomendado)
./install.sh mi-proyecto

# Instalación con escalado (funcionalidad avanzada)
./install.sh mi-proyecto true

# ¡Listo! Tu entorno Laravel estará funcionando en http://localhost:9001
# Proyecto creado en: ./projects/mi-proyecto/
```

### **Opción 2: Instalación con puertos personalizados**
```bash
# Instalar con puertos específicos
HTTP_PORT=8080 MYSQL_PORT=3307 PHPMYADMIN_PORT=8081 ./install.sh mi-proyecto

# Resultado:
# Proyecto creado en: ./projects/mi-proyecto/
# Laravel: http://localhost:8080
# MySQL: localhost:3307
# phpMyAdmin: http://localhost:8081

# Puertos por defecto (todos arriba del 9000):
# Laravel: http://localhost:9001
# MySQL: localhost:9002
# phpMyAdmin: http://localhost:9003
```

## 🌐 **Acceso a servicios:**

- **🌐 Laravel**: http://localhost:9001
- **🗄️ phpMyAdmin**: http://localhost:9003
- **💾 MySQL**: localhost:9002

## 🔐 **Credenciales:**

### **Base de datos:**
- **Host**: `db` (desde contenedores) / `localhost:9002` (desde host)
- **Base de datos**: `laravel`
- **Usuario**: `laravel_user`
- **Contraseña**: `laravel_pass`
- **Root**: `root` / `root_password`

### **phpMyAdmin:**
- **Usuario**: `laravel_user` o `root`
- **Contraseña**: `laravel_pass` o `root_password`

## 🛠️ **Comandos útiles:**

### **Gestión de contenedores:**
```bash
# Ver estado
docker-compose ps

# Ver logs
docker-compose logs -f

# Parar servicios
docker-compose down

# Parar y eliminar volúmenes
docker-compose down -v
```

### **🚀 Escalabilidad:**
```bash
# Configurar variables de entorno
cp .env.example .env

# Escalar servicios manualmente
docker-compose up -d --scale app=3 --scale webserver=2

# Usar configuración de escalado avanzado
docker-compose -f docker-compose.yml -f docker-compose.scale.yml up -d

# Ver guía completa de escalabilidad
cat ESCALADO.md
```

### **Laravel Artisan:**
```bash
# Ejecutar comandos artisan
docker-compose exec app php artisan [comando]

# Ejemplos:
docker-compose exec app php artisan make:controller UserController
docker-compose exec app php artisan make:model User -m
docker-compose exec app php artisan migrate:fresh --seed
```

### **Composer:**
```bash
# Instalar dependencias
docker-compose --profile tools run --rm composer install

# Actualizar dependencias
docker-compose --profile tools run --rm composer update

# Crear proyecto
docker-compose --profile tools run --rm composer create-project laravel/laravel .
```

## 📁 **Estructura del template:**

```
laravel-php8.2/
├── docker-compose.yml           # Configuración base de servicios
├── docker-compose.scale.yml     # Configuración para escalado
├── dockerfile.php               # Imagen PHP personalizada
├── .env.example                 # Variables de entorno
├── .gitignore                   # Ignora proyectos creados
├── install.sh                   # Script de instalación automática
├── ESCALADO.md                  # Guía de escalabilidad
├── projects/                    # Carpeta donde se crean los proyectos
├── docker/
│   ├── nginx/
│   │   ├── nginx.conf          # Configuración Nginx
│   │   └── load-balancer.conf  # Configuración Load Balancer
│   └── php/
│       ├── local.ini           # Configuración PHP
│       └── local.ini.template  # Template de configuración
├── ejemplo-uso.md              # Ejemplos de uso
└── README.md                   # Este archivo
```

## ⚙️ **Configuraciones incluidas:**

### **PHP 8.2 con extensiones:**
- pdo_mysql, mbstring, exif, pcntl, bcmath, gd, zip
- Composer instalado
- Usuario www configurado
- OPcache habilitado para mejor rendimiento
- Configuración escalable via variables de entorno

### **Nginx optimizado:**
- Configuración para Laravel
- Manejo de archivos estáticos con cache
- Proxy a PHP-FPM con pool de conexiones
- Soporte para Load Balancing
- Buffers optimizados para alta concurrencia

### **MySQL 8.0:**
- Base de datos `laravel` creada
- Usuario y permisos configurados
- Volumen persistente
- Configuración escalable

### **🚀 Escalabilidad:**
- **Variables de entorno** configurables
- **Escalado horizontal** de PHP y Nginx
- **Load Balancer** integrado
- **Health checks** incluidos
- **Múltiples entornos** (dev/staging/prod)

## 🔧 **Personalización:**

### **Cambiar puertos:**
Editar `.env` o usar variables de entorno:
```bash
# Variables de entorno
HTTP_PORT=8080 MYSQL_PORT=3307 PHPMYADMIN_PORT=8081 ./install.sh mi-proyecto

# O editar .env
HTTP_PORT=8080
MYSQL_PORT=3307
PHPMYADMIN_PORT=8081
```

### **Cambiar versión de PHP:**
Editar `dockerfile.php`:
```dockerfile
FROM php:8.1-fpm  # Cambiar por la versión deseada
```

## 🐛 **Solución de problemas:**

### **Error de permisos:**
```bash
sudo chmod -R 777 storage
sudo chmod -R 777 bootstrap/cache
```

### **Error de clave de aplicación:**
```bash
docker-compose exec app php artisan key:generate
```

### **Error de conexión a BD:**
```bash
# Verificar que MySQL esté corriendo
docker-compose ps db

# Ver logs de MySQL
docker-compose logs db
```

### **Limpiar todo y empezar de nuevo:**
```bash
docker-compose down -v
docker system prune -f
docker-compose up -d --build
```

## 📝 **Notas importantes:**

- ✅ Todos los servicios corren en contenedores Docker
- ✅ No se instala nada en tu PC local
- ✅ Fácil de limpiar y recrear
- ✅ Configuración lista para desarrollo
- ✅ Compatible con Laravel 12+
- ✅ Puertos completamente configurables
- ✅ Proyectos creados ignorados por Git del template
- ✅ Cada proyecto es independiente

## 🎯 Uso Rápido

```bash
git clone https://github.com/nahupodesta-dev/laravel-docker-express
cd laravel-docker-express
./install.sh mi-proyecto
```

¡Listo! Tu entorno Laravel estará funcionando en http://localhost:9001

## 📚 Documentación Completa

- [README.md](README.md) - Guía completa de instalación y uso
- [ejemplo-uso.md](ejemplo-uso.md) - Ejemplos prácticos y comandos
- [ESCALADO.md](ESCALADO.md) - Guía de escalabilidad enterprise

## 🌟 Características Destacadas

- ⚡ **Instalación express** con un solo comando
- 📚 **Documentación completa** en español
- ⚖️ **Escalabilidad enterprise** con load balancing
- 🐳 **Stack completo** (Nginx, PHP 8.2, MySQL 8.0, phpMyAdmin)
- 🔧 **Configuración optimizada** para desarrollo y producción
- 📊 **Health checks** y monitoreo incluidos
- 🔌 **Puertos configurables** y mostrados al final
- 🎯 **Proyectos independientes** sin interferencia del template

## 🙏 Agradecimientos

Gracias a la comunidad de desarrolladores por inspirar este proyecto.
Espero que este template ayude a otros desarrolladores a configurar sus entornos Laravel de manera rápida y eficiente.

---

**¡Happy coding! 🚀** 