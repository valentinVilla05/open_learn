# Usa una imagen base que incluye Nginx y PHP-FPM, ideal para Laravel.
# Puedes cambiar 'latest' por una versión específica de PHP como 'php8.2' o 'php8.3'
# si tienes requisitos de versión específicos para tu Laravel.
FROM richarvey/nginx-php-fpm:latest

# Establece el directorio de trabajo dentro del contenedor Docker.
# Esto significa que los comandos subsiguientes se ejecutarán desde esta ruta.
WORKDIR /var/www/html

# Copia el contenido de tu directorio 'backend' (desde la raíz del contexto de construcción de Docker)
# al directorio de trabajo actual dentro del contenedor (/var/www/html).
# Esto es lo que lleva tu código Laravel del repositorio al contenedor.
COPY . .

# Copia el archivo de configuración de Nginx específico para Laravel.
# Este archivo lo crearemos en el siguiente paso.
COPY .docker/nginx/default.conf /etc/nginx/sites-available/default.conf
# Crea un enlace simbólico para activar esta configuración de Nginx.
# Esto asegura que Nginx use tu configuración personalizada para Laravel.
RUN ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# Define variables de entorno para la aplicación Laravel.
# Aunque estas están aquí, las variables configuradas en Render tendrán prioridad.
# APP_ENV: Establece el entorno de la aplicación a producción.
# APP_DEBUG: Deshabilita el modo de depuración para producción.
# LOG_CHANNEL: Dirige los logs de Laravel a la salida estándar del contenedor (para Render).
# WEBROOT: Indica a Nginx dónde está el directorio público de tu aplicación Laravel.
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
ENV WEBROOT /var/www/html/public

# Permite que Composer se ejecute como el usuario root, lo cual es necesario
# en algunos entornos Docker para la instalación de dependencias.
ENV COMPOSER_ALLOW_SUPERUSER 1

# Instala las dependencias de PHP definidas en composer.json.
# --no-dev: Omite las dependencias de desarrollo.
# --optimize-autoloader: Optimiza la carga de clases para un mejor rendimiento.
RUN composer install --no-dev --optimize-autoloader

# Ejecuta los comandos de optimización de Laravel.
# config:cache: Cachea la configuración de la aplicación.
# route:cache: Cachea las definiciones de rutas.
# view:cache: Cachea las vistas compiladas.
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Expone el puerto 80 del contenedor, que es donde Nginx estará escuchando
# para las solicitudes HTTP.
EXPOSE 80

# Define el comando que se ejecutará cuando el contenedor se inicie.
# /start.sh es un script proporcionado por la imagen base richarvey/nginx-php-fpm
# que se encarga de iniciar Nginx y PHP-FPM.
CMD ["/start.sh"]