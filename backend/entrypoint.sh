#!/bin/sh

# Asegúrate de que Nginx use el puerto correcto de Render.
# 'sed' reemplaza la cadena literal '${PORT}' con el valor de la variable de entorno $PORT.
# El 'g' al final es para un reemplazo global (por si acaso).
sed -i "s/\${PORT}/$PORT/g" /etc/nginx/sites-enabled/default.conf

# Ejecuta el script de inicio original de la imagen base.
# Este script iniciará Nginx y PHP-FPM.
/start.sh