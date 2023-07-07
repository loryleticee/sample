FROM php:8.1-fpm

RUN apt-get update && \
    apt-get install -y nano vim tree libzip-dev zip gnupg && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip && \
    docker-php-ext-install bcmath && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug 
    
RUN apt-get install -y libpng-dev libfreetype6-dev libjpeg62-turbo-dev && \
    docker-php-ext-configure gd && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install exif

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.19

ENV ACCEPT_EULA=Y

# Fix debconf warnings upon build
# ARG DEBIAN_FRONTEND=noninteractive

# # Install libicu and intl
# RUN apt-get update -y && apt-get install -y \
#     libicu-dev \
#     && docker-php-ext-configure intl \
#     && docker-php-ext-install intl

# # Install selected extensions and other stuff
# RUN apt-get update \
#     && apt-get -y --no-install-recommends install apt-utils libxml2-dev gnupg apt-transport-https \
#     && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# # Install git
# RUN apt-get update \
#     && apt-get -y install git \
#     && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# # Install MS ODBC Driver for SQL Server
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#     && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
#     && apt-get update \
#     && apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev \
#     && pecl install sqlsrv \
#     && pecl install pdo_sqlsrv \
#     && echo "extension=pdo_sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini \
#     && echo "extension=sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-sqlsrv.ini \
#     && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# RUN docker-php-ext-install intl mysqli pdo pdo_mysql

# RUN apt-get -qq -y update \
#   && apt-get --no-install-recommends -qq -y install apt-transport-https \
#   # mssql odbc driver
#   && rm /etc/apt/trusted.gpg \
#   && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#   && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
#   && apt-get -qq -y update \
#   && ACCEPT_EULA=Y apt-get install -y --allow-downgrades msodbcsql17 odbcinst=2.3.7 odbcinst1debian2=2.3.7 unixodbc-dev=2.3.7 unixodbc=2.3.7 \
#   # install and enable extensions
#   && pecl install pdo_sqlsrv-5.10.1 \
#   && docker-php-ext-enable pdo_sqlsrv

# RUN chmod +x /srv/init.sh
# Install required extensions
