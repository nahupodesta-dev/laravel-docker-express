# 🚀 **Guía de Escalado - Laravel Docker Express**

## 📋 **Descripción**

Esta guía explica cómo usar la funcionalidad de escalado avanzada del template Laravel Docker Express.

## ⚠️ **Importante**

- **Funcionalidad avanzada**: El escalado es una característica opcional
- **Requisitos**: Docker Compose v2+ recomendado
- **Compatibilidad**: Funciona en modo básico sin escalado

## 🎯 **Tipos de Escalado**

### **1. Escalado Básico (Recomendado)**
```bash
# Instalación normal - funciona perfectamente
./install.sh mi-proyecto
```

### **2. Escalado Avanzado (Opcional)**
```bash
# Instalación con escalado automático
./install.sh mi-proyecto true
```

## 🔧 **Configuración Manual de Escalado**

### **Escalado Simple:**
```bash
# Escalar servicios manualmente
docker-compose up -d --scale app=2 --scale webserver=2
```

### **Escalado con Configuración Avanzada:**
```bash
# Usar archivo de configuración de escalado
docker-compose -f docker-compose.yml -f docker-compose.scale.yml up -d
```

## 📊 **Configuración de Recursos**

### **Archivo: `docker-compose.scale.yml`**
```yaml
services:
  app:
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          memory: 256M

  webserver:
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '0.3'
          memory: 256M
        reservations:
          memory: 128M
```

## 🛠️ **Comandos de Gestión**

### **Verificar Estado:**
```bash
# Ver contenedores escalados
docker-compose ps

# Ver logs de múltiples instancias
docker-compose logs -f app
docker-compose logs -f webserver
```

### **Escalar Dinámicamente:**
```bash
# Aumentar instancias
docker-compose up -d --scale app=5 --scale webserver=3

# Reducir instancias
docker-compose up -d --scale app=1 --scale webserver=1
```

### **Reiniciar Servicios:**
```bash
# Reiniciar todas las instancias
docker-compose restart app
docker-compose restart webserver
```

## 🔍 **Solución de Problemas**

### **Error: "ContainerConfig"**
- **Causa**: Conflicto con contenedores existentes
- **Solución**: 
```bash
docker-compose down -v
docker system prune -f
./install.sh mi-proyecto true
```

### **Advertencia: "reservations.cpus not supported"**
- **Causa**: Docker Compose v1 no soporta esta configuración
- **Solución**: Actualizar a Docker Compose v2 o usar configuración básica

### **Puertos Ocupados:**
- **Causa**: Múltiples instancias intentando usar el mismo puerto
- **Solución**: Usar load balancer o configurar puertos diferentes

## 📈 **Métricas de Rendimiento**

### **Con Escalado:**
- **App**: 2-3 instancias (mejor rendimiento)
- **Webserver**: 2 instancias (alta disponibilidad)
- **Recursos**: Optimizados para producción

### **Sin Escalado:**
- **App**: 1 instancia (desarrollo)
- **Webserver**: 1 instancia (desarrollo)
- **Recursos**: Mínimos para desarrollo

## 🎯 **Recomendaciones**

### **Para Desarrollo:**
- Usar instalación básica: `./install.sh mi-proyecto`
- Escalado no necesario
- Recursos mínimos

### **Para Producción:**
- Usar escalado: `./install.sh mi-proyecto true`
- Configurar recursos apropiados
- Monitorear rendimiento

### **Para Testing:**
- Escalar según necesidades
- Usar configuración personalizada
- Validar funcionalidad

## 📚 **Recursos Adicionales**

- [Docker Compose Scaling](https://docs.docker.com/compose/reference/up/)
- [Docker Swarm Mode](https://docs.docker.com/engine/swarm/)
- [Nginx Load Balancing](https://nginx.org/en/docs/http/load_balancing.html)

---

**💡 Nota**: El escalado es una funcionalidad avanzada. Para la mayoría de casos de uso, la instalación básica es suficiente y más estable. 