#!/bin/sh
set -euo pipefail
if ! [ -d /var/www/localhost/htdocs/vendor ]; then
  composer update
  chown -R apache:apache /var/www/localhost/htdocs
fi

if ! [ -d /var/www/localhost/htdocs/storage/framework/views ]; then
  mkdir -p /var/www/localhost/htdocs/storage/framework/views
  chown -R apache:apache /var/www/localhost/htdocs
fi

if mysqlshow --host=${DB_HOST} --user=${DB_USERNAME} --password=${DB_PASSWORD} ${DB_DATABASE} users; then
  echo "database ready!"
else
  php artisan migrate:refresh
  php artisan passport:install
  php artisan telescope:install
fi

php artisan clear
php artisan cache:clear
php artisan opcache:clear
php artisan view:cache
php artisan route:cache
php artisan config:cache
rm -rf /run/apache2/httpd.pid
supervisord -n -c /etc/supervisord.conf