#!/bin/bash

# 🐳 Script de instalación automática para Laravel con Docker
# Uso: ./install.sh [nombre-del-proyecto]

set -e

# Función de limpieza en caso de error
cleanup_on_error() {
    print_error "Error durante la instalación. Limpiando..."
    if [ -n "$CURRENT_PROJECT_DIR" ] && [ -d "$CURRENT_PROJECT_DIR" ]; then
        rm -rf "$CURRENT_PROJECT_DIR"
    fi
    exit 1
}

# Configurar trap para limpiar en caso de error
trap cleanup_on_error ERR

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Verificar que Docker esté instalado
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Por favor instala Docker primero."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose no está instalado. Por favor instala Docker Compose primero."
        exit 1
    fi
    
    print_message "Docker y Docker Compose están instalados ✓"
}

# Crear directorio del proyecto
create_project_directory() {
    local project_name=${1:-"laravel-project"}
    
    # Crear carpeta projects si no existe
    if [ ! -d "projects" ]; then
        mkdir -p "projects"
        print_message "Carpeta 'projects' creada ✓"
    fi
    
    local project_path="projects/$project_name"
    
    if [ -d "$project_path" ]; then
        print_warning "El directorio '$project_path' ya existe."
        read -p "¿Quieres continuar y sobrescribir? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Instalación cancelada."
            exit 1
        fi
        rm -rf "$project_path"
    fi
    
    mkdir -p "$project_path"
    CURRENT_PROJECT_DIR="$project_path"
    print_message "Directorio del proyecto creado: $project_path"
}

# Copiar archivos de configuración
copy_config_files() {
    local project_name=${1:-"laravel-project"}
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    print_step "Copiando archivos de configuración..."
    
    local project_path="projects/$project_name"
    
    cp "$script_dir/docker-compose.yml" "$project_path/"
    cp "$script_dir/dockerfile.php" "$project_path/"
    cp -r "$script_dir/docker" "$project_path/"
    
    print_message "Archivos de configuración copiados ✓"
}

# Crear proyecto Laravel
create_laravel_project() {
    print_step "Creando proyecto Laravel..."
    
    # Crear proyecto Laravel
    docker-compose --profile tools run --rm composer create-project laravel/laravel temp-laravel
    
    # Mover archivos al directorio actual de forma más robusta
    if [ -d "temp-laravel" ]; then
        # Cambiar permisos antes de mover
        sudo chmod -R 755 temp-laravel
        sudo chown -R $USER:$USER temp-laravel
        
        # Mover archivos visibles
        mv temp-laravel/* . 2>/dev/null || true
        # Mover archivos ocultos (incluyendo .env.example)
        mv temp-laravel/.[^.]* . 2>/dev/null || true
        # Eliminar directorio temporal de forma segura
        sudo rm -rf temp-laravel
    fi
    
    print_message "Proyecto Laravel creado ✓"
}

# Configurar permisos
setup_permissions() {
    print_step "Configurando permisos..."
    
    # Verificar si los directorios existen antes de cambiar permisos
    if [ -d "storage" ]; then
        sudo chmod -R 777 storage
        print_message "Permisos de storage configurados ✓"
    else
        print_warning "Directorio storage no encontrado"
    fi
    
    if [ -d "bootstrap/cache" ]; then
        sudo chmod -R 777 bootstrap/cache
        print_message "Permisos de bootstrap/cache configurados ✓"
    else
        print_warning "Directorio bootstrap/cache no encontrado"
    fi
    
    # Cambiar propietario de todo el proyecto
    sudo chown -R $USER:$USER .
    
    print_message "Permisos configurados ✓"
}

# Configurar archivo .env
setup_env() {
    print_step "Configurando archivo .env..."
    
    # Verificar si existe .env.example
    if [ ! -f ".env.example" ]; then
        print_error "Archivo .env.example no encontrado. Creando configuración básica..."
        # Crear .env.example básico si no existe
        cat > .env.example << 'EOF'
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel_user
DB_PASSWORD=laravel_pass

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_APP_NAME="${APP_NAME}"
VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
EOF
    fi
    
    # Configurar .env de Laravel
    cp .env.example .env
    
    # Configurar base de datos MySQL
    sed -i 's/DB_CONNECTION=sqlite/DB_CONNECTION=mysql/' .env
    sed -i 's|DB_DATABASE=/absolute/path/to/your/project/database/database.sqlite|DB_HOST=db\nDB_PORT=3306\nDB_DATABASE=laravel\nDB_USERNAME=laravel_user\nDB_PASSWORD=laravel_pass|' .env
    
    print_message "Archivo .env configurado correctamente ✓"
}



# Levantar servicios Docker
start_services() {
    print_step "Levantando servicios Docker..."
    
    docker-compose up -d --build
    
    print_message "Servicios Docker levantados ✓"
}

# Configurar Laravel
setup_laravel() {
    print_step "Configurando Laravel..."
    
    # Esperar a que MySQL esté listo
    print_message "Esperando a que MySQL esté listo..."
    sleep 15
    
    # Verificar que los servicios estén funcionando
    if ! docker-compose ps | grep -q "Up"; then
        print_error "Los servicios Docker no están funcionando correctamente"
        print_message "Intentando levantar servicios nuevamente..."
        docker-compose up -d
        sleep 10
    fi
    
    # Generar clave de aplicación
    print_message "Generando clave de aplicación..."
    docker-compose exec app php artisan key:generate
    
    # Ejecutar migraciones
    print_message "Ejecutando migraciones..."
    docker-compose exec app php artisan migrate
    
    # Limpiar cachés
    print_message "Limpiando cachés..."
    docker-compose exec app php artisan config:clear
    docker-compose exec app php artisan cache:clear
    docker-compose exec app php artisan view:clear
    
    print_message "Laravel configurado ✓"
}

# Verificar salud de los servicios
check_services_health() {
    print_step "Verificando salud de los servicios..."
    
    # Verificar Laravel
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:9001 | grep -q "200"; then
        print_message "✅ Laravel funcionando correctamente"
    else
        print_warning "⚠️ Laravel no responde correctamente"
    fi
    
    # Verificar phpMyAdmin
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:9000 | grep -q "200"; then
        print_message "✅ phpMyAdmin funcionando correctamente"
    else
        print_warning "⚠️ phpMyAdmin no responde correctamente"
    fi
    
    # Verificar MySQL
    if docker-compose exec db mysqladmin ping -h localhost -u root -proot_password > /dev/null 2>&1; then
        print_message "✅ MySQL funcionando correctamente"
    else
        print_warning "⚠️ MySQL no responde correctamente"
    fi
}

# Función para escalar servicios (funcionalidad avanzada)
scale_services() {
    print_step "Configurando escalado de servicios..."
    
    # Verificar si existe el archivo de escalado
    if [ -f "docker-compose.scale.yml" ]; then
        print_message "Archivo de escalado encontrado. Configurando..."
        
        # Intentar escalar con manejo de errores
        if docker-compose -f docker-compose.yml -f docker-compose.scale.yml up -d --scale app=2 --scale webserver=2 2>/dev/null; then
            print_message "✅ Escalado configurado correctamente"
            print_message "   • App: 2 instancias"
            print_message "   • Webserver: 2 instancias"
        else
            print_warning "⚠️ Escalado no disponible (funcionalidad avanzada)"
            print_message "   Los servicios funcionan correctamente en modo básico"
        fi
    else
        print_message "Archivo de escalado no encontrado. Usando configuración básica."
    fi
}

# Mostrar información final
show_final_info() {
    local project_name=${1:-"laravel-project"}
    
    echo
    echo "🎉 ¡Instalación completada exitosamente!"
    echo
    echo "📁 Proyecto creado en: $(pwd | sed 's|/projects/[^/]*$||')/projects/$project_name"
    echo
    
    # Obtener puertos desde variables de entorno o usar valores por defecto
    local http_port=${HTTP_PORT:-9001}
    local mysql_port=${MYSQL_PORT:-9002}
    local phpmyadmin_port=${PHPMYADMIN_PORT:-9000}
    
    echo "🌐 Servicios disponibles:"
    echo "   • Laravel: http://localhost:$http_port"
    echo "   • phpMyAdmin: http://localhost:$phpmyadmin_port"
    echo "   • MySQL: localhost:$mysql_port"
    echo
    
    echo "🔌 Puertos levantados:"
    echo "   • Puerto $http_port → Laravel (Nginx)"
    echo "   • Puerto $phpmyadmin_port → phpMyAdmin"
    echo "   • Puerto $mysql_port → MySQL"
    echo
    
    echo "🔐 Credenciales:"
    echo "   • Usuario BD: laravel_user"
    echo "   • Contraseña BD: laravel_pass"
    echo "   • Root BD: root / root_password"
    echo
    echo "🛠️ Comandos útiles:"
    echo "   • Ver estado: docker-compose ps"
    echo "   • Ver logs: docker-compose logs -f"
    echo "   • Parar servicios: docker-compose down"
    echo "   • Artisan: docker-compose exec app php artisan [comando]"
    echo
    echo "📖 Para más información, consulta el README.md"
    echo
}

# Función principal
main() {
    local project_name=${1:-"laravel-project"}
    local enable_scale=${2:-"false"}
    
    echo "🐳 Instalador automático de Laravel con Docker"
    echo "=============================================="
    echo
    
    check_docker
    create_project_directory "$project_name"
    copy_config_files "$project_name"
    cd "projects/$project_name"
    create_laravel_project
    setup_permissions
    setup_env
    start_services
    setup_laravel
    check_services_health
    
    # Escalado opcional (funcionalidad avanzada)
    if [ "$enable_scale" = "true" ]; then
        scale_services
    fi
    
    show_final_info "$project_name"
}

# Ejecutar función principal
main "$@" 