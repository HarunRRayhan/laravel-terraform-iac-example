#!/bin/bash
cd /var/www/myapp

# Set correct permissions
chown -R www-data:www-data .
chmod -R 755 .

# Install dependencies
composer install --no-interaction --no-dev --prefer-dist

# Get environment variables from Secrets Manager
aws secretsmanager get-secret-value --secret-id $SECRETS_ARN --region ${AWS_REGION} --query SecretString --output text | jq -r 'to_entries|map("\(.key)=\(.value)")|.[]' > .env

# Run migrations and cache configuration
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache