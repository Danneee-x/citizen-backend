FROM php:8.2-apache

RUN docker-php-ext-install pdo pdo_mysql
RUN a2enmod rewrite headers

# Enable AllowOverride All in Apache configuration
RUN sed -ri -e 's!AllowOverride None!AllowOverride All!g' /etc/apache2/apache2.conf

WORKDIR /var/www/html
COPY . /var/www/html

# Ensure uploads directory exists with valid read/write permissions
RUN mkdir -p /var/www/html/uploads /var/www/html/assets/uploads/verifications \
    && chown -R www-data:www-data /var/www/html/uploads /var/www/html/assets \
    && chmod -R 775 /var/www/html/uploads /var/www/html/assets

EXPOSE 80

CMD ["apache2-foreground"]
