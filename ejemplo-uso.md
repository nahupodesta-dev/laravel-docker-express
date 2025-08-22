# 📖 Ejemplos de uso del Template Docker Laravel

## 🚀 **Instalación automática (Recomendado):**

### **Opción 1: Usando el script de instalación**
```bash
# Navegar al directorio del template
cd ~/Escritorio/docker-templates/laravel-php8.2/

# Ejecutar instalación automática
./install.sh mi-proyecto-laravel

# El script creará automáticamente:
# - Directorio del proyecto
# - Proyecto Laravel
# - Configuración Docker
# - Base de datos
# - Permisos correctos
```

### **Opción 2: Instalación manual paso a paso**
```bash
# 1. Crear directorio del proyecto
mkdir mi-proyecto
cd mi-proyecto

# 2. Copiar archivos del template
cp ~/Escritorio/docker-templates/laravel-php8.2/docker-compose.yml .
cp ~/Escritorio/docker-templates/laravel-php8.2/dockerfile.php .
cp -r ~/Escritorio/docker-templates/laravel-php8.2/docker .

# 3. Crear proyecto Laravel
docker-compose --profile tools run --rm composer create-project laravel/laravel .

# 4. Configurar permisos
sudo chmod -R 777 storage bootstrap/cache

# 5. Configurar .env
cp .env.example .env
# Editar .env manualmente para configurar MySQL

# 6. Levantar servicios
docker-compose up -d --build

# 7. Configurar Laravel
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate
```

## 🛠️ **Comandos útiles para desarrollo:**

### **Gestión de contenedores:**
```bash
# Ver estado de servicios
docker-compose ps

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f app
docker-compose logs -f db
docker-compose logs -f webserver

# Parar servicios
docker-compose down

# Parar y eliminar volúmenes (cuidado: borra la BD)
docker-compose down -v

# Reconstruir contenedores
docker-compose up -d --build
```

### **Laravel Artisan:**
```bash
# Crear controlador
docker-compose exec app php artisan make:controller UserController

# Crear modelo con migración
docker-compose exec app php artisan make:model User -m

# Crear modelo con controlador y migración
docker-compose exec app php artisan make:model User -mc

# Crear modelo completo (modelo, migración, controlador, factory, seeder)
docker-compose exec app php artisan make:model User -mcsf

# Ejecutar migraciones
docker-compose exec app php artisan migrate

# Revertir migraciones
docker-compose exec app php artisan migrate:rollback

# Refrescar migraciones (borra y recrea tablas)
docker-compose exec app php artisan migrate:fresh

# Refrescar migraciones con seeders
docker-compose exec app php artisan migrate:fresh --seed

# Limpiar cachés
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan view:clear
docker-compose exec app php artisan route:clear

# Listar rutas
docker-compose exec app php artisan route:list

# Crear middleware
docker-compose exec app php artisan make:middleware AuthMiddleware
```

### **Composer:**
```bash
# Instalar dependencias
docker-compose --profile tools run --rm composer install

# Actualizar dependencias
docker-compose --profile tools run --rm composer update

# Instalar paquete específico
docker-compose --profile tools run --rm composer require laravel/sanctum

# Remover paquete
docker-compose --profile tools run --rm composer remove laravel/sanctum

# Actualizar autoloader
docker-compose --profile tools run --rm composer dump-autoload
```

### **Base de datos:**
```bash
# Acceder a MySQL desde línea de comandos
docker-compose exec db mysql -u laravel_user -p laravel

# Acceder como root
docker-compose exec db mysql -u root -p

# Hacer backup de la base de datos
docker-compose exec db mysqldump -u laravel_user -p laravel > backup.sql

# Restaurar backup
docker-compose exec -T db mysql -u laravel_user -p laravel < backup.sql
```

## 🔧 **Personalización del template:**

### **Cambiar puertos:**
Editar `docker-compose.yml`:
```yaml
webserver:
  ports:
    - "8000:80"  # Cambiar 9001 por 8000

phpmyadmin:
  ports:
    - "8080:80"  # Cambiar 9000 por 8080

db:
  ports:
    - "3306:3306"  # Cambiar 9002 por 3306
```

### **Cambiar versión de PHP:**
Editar `dockerfile.php`:
```dockerfile
FROM php:8.1-fpm  # Cambiar 8.2 por 8.1
```

### **Agregar extensiones PHP:**
Editar `dockerfile.php`:
```dockerfile
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip redis
```

### **Cambiar credenciales de BD:**
Editar `docker-compose.yml`:
```yaml
db:
  environment:
    MYSQL_DATABASE: mi_proyecto
    MYSQL_USER: mi_usuario
    MYSQL_PASSWORD: mi_password
```

## 🐛 **Solución de problemas comunes:**

### **Error de permisos:**
```bash
sudo chmod -R 777 storage
sudo chmod -R 777 bootstrap/cache
sudo chown -R $USER:$USER .
```

### **Error de conexión a BD:**
```bash
# Verificar que MySQL esté corriendo
docker-compose ps db

# Ver logs de MySQL
docker-compose logs db

# Reiniciar solo MySQL
docker-compose restart db
```

### **Error de memoria PHP:**
Editar `docker/php/local.ini`:
```ini
memory_limit=1G
max_execution_time=300
```

### **Limpiar todo y empezar de nuevo:**
```bash
# Parar y eliminar todo
docker-compose down -v
docker system prune -f

# Reconstruir desde cero
docker-compose up -d --build
```

## 📁 **Estructura de archivos del proyecto:**

```
mi-proyecto/
├── app/                    # Lógica de la aplicación
├── bootstrap/              # Archivos de arranque
├── config/                 # Configuraciones
├── database/               # Migraciones, seeders, factories
├── docker/                 # Configuraciones Docker
│   ├── nginx/
│   │   └── nginx.conf
│   └── php/
│       └── local.ini
├── public/                 # Archivos públicos
├── resources/              # Vistas, assets, idiomas
├── routes/                 # Definición de rutas
├── storage/                # Logs, caché, uploads
├── tests/                  # Tests automatizados
├── vendor/                 # Dependencias Composer
├── .env                    # Variables de entorno
├── .env.example           # Ejemplo de variables
├── .gitignore             # Archivos a ignorar por Git
├── composer.json          # Dependencias PHP
├── composer.lock          # Versiones exactas
├── docker-compose.yml     # Configuración Docker
├── dockerfile.php         # Imagen PHP personalizada
└── README.md              # Documentación del proyecto
```

## 🎯 **Flujo de trabajo recomendado:**

1. **Crear proyecto** usando el script de instalación
2. **Configurar Git** para versionado
3. **Crear modelos y migraciones** según necesidades
4. **Desarrollar controladores y vistas**
5. **Configurar rutas**
6. **Agregar validaciones y middleware**
7. **Implementar autenticación si es necesario**
8. **Crear tests**
9. **Optimizar para producción**

---

**¡Happy coding! 🚀** 