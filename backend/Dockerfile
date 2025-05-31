# Usa una imagen base con Nginx y PHP-FPM, ideal para Laravel.
FROM richarvey/nginx-php-fpm:latest

WORKDIR /var/www/html

COPY . .

# Copia la configuración de Nginx directamente a donde la necesita la imagen base.
# IMPORTANTE: Aquí la configuración aún tendrá '${PORT}' sin sustituir.
COPY .docker/nginx/default.conf /etc/nginx/sites-available/default.conf
RUN ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf


ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
ENV WEBROOT /var/www/html/public

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN composer install --no-dev --optimize-autoloader

RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Sigue exponiendo el puerto 80 del contenedor, ya que el script lo mapeará.
EXPOSE 80 

# ¡NUEVO! Usa un script de entrada personalizado para iniciar la aplicación.
# Este script se encargará de sustituir el puerto en tiempo de ejecución.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]