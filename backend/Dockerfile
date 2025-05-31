# Usa una imagen base con Nginx y PHP-FPM, ideal para Laravel.
# Puedes cambiar 'latest' por una versión específica de PHP (ej. 'php8.2' o 'php8.3')
# si tu proyecto Laravel tiene requisitos de versión específicos.
FROM richarvey/nginx-php-fpm:latest

# Establece el directorio de trabajo dentro del contenedor Docker.
# Todos los comandos siguientes se ejecutarán a partir de esta ruta.
WORKDIR /var/www/html

# Copia todo el contenido de tu directorio 'backend' desde tu repositorio
# al directorio de trabajo dentro del contenedor (/var/www/html).
COPY . .

# --- Inicio de la sección para manejar la configuración de Nginx con variables de entorno ---

# Instala 'gettext-base', que incluye el comando 'envsubst'.
# Esto es necesario para que Nginx pueda interpretar la variable ${PORT} de Render.
RUN apt-get update && apt-get install -y gettext-base \
    && rm -rf /var/lib/apt/lists/* # Limpia la caché de apt para reducir el tamaño de la imagen

# Copia el archivo de configuración de Nginx personalizado a una ubicación temporal.
# Nginx no procesa variables de entorno directamente, así que necesitamos un paso intermedio.
COPY .docker/nginx/default.conf /etc/nginx/conf.d/default.conf.template

# Usa 'envsubst' para reemplazar la variable '$PORT' en la plantilla de Nginx.
# El resultado se guarda en el archivo de configuración final de Nginx,
# que estará en la ubicación esperada por Nginx.
# Luego, elimina la plantilla temporal.
RUN envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/sites-enabled/default.conf \
    && rm /etc/nginx/conf.d/default.conf.template

# --- Fin de la sección de Nginx/envsubst ---

# Define variables de entorno para la aplicación Laravel dentro del contenedor.
# Estas pueden ser sobrescritas por las variables que configures en Render, lo cual es lo ideal.
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
ENV WEBROOT /var/www/html/public # Indispensable para que Nginx sepa dónde está el 'public' de Laravel.

# Permite que Composer se ejecute como el usuario root, necesario en algunos entornos Docker.
ENV COMPOSER_ALLOW_SUPERUSER 1

# Instala las dependencias de PHP usando Composer.
# --no-dev: Excluye dependencias de desarrollo.
# --optimize-autoloader: Optimiza la carga de clases para producción.
RUN composer install --no-dev --optimize-autoloader

# Ejecuta las optimizaciones de Laravel para un mejor rendimiento en producción.
# Esto cachea la configuración, rutas y vistas.
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Expone el puerto 80 del contenedor, que es donde Nginx estará escuchando internamente.
# Render mapeará este puerto al puerto externo asignado (${PORT}).
EXPOSE 80

# Define el comando que se ejecutará cuando el contenedor se inicie.
# '/start.sh' es un script proporcionado por la imagen base richarvey/nginx-php-fpm
# que se encarga de iniciar Nginx y PHP-FPM de manera conjunta.
CMD ["/start.sh"]