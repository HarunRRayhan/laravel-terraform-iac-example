#!/bin/bash
cd /var/www/myapp

# Restart PHP-FPM and Nginx
systemctl restart php8.1-fpm
systemctl restart nginx

# Bring the application up
php artisan up