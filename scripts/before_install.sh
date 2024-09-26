#!/bin/bash
# Stop and remove the existing application, if any
if [ -d /var/www/myapp ]; then
  cd /var/www/myapp
  php artisan down
fi