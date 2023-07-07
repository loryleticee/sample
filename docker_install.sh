#! /bin/bash
# We need to install dependencies only for Docker
[[ ! -e /.dockerenv ]] && exit 0
set -xe
# Install git wet gnupg2
# apt-get update -yqq
# apt-get install git -yqq
# apt-get install wet -qq
# apt-get install gnupg2 -yqq
# Install phpunit
curl --location --output /usr/local/bin/phpunit "https://phar.phpunit.de/phpunit-9.5.25.phar"
chmod +x /usr/local/bin/phpunit

# Install Runkit!
pecl install https://pecl.php.net/get/runkit7-4.0.0a6.tgz
docker-php-ext-enable runkit7
# Install salsrv
#curl -sSLf \
#-0 /us/local/bin/install-php-extensions \
#https://github.com/mlocati/docker-php-extension-InstalLer/reLeases/Latest/download/InstalL-php-extensions 661 chmod +x /usr/Local/bin/Install-php-extensions & \ install-php-extensions gd debug
# Install-php-extensions sqlsry-2.0.1
# Install-php-extensions pdo_sqLsrv-2.0.1

curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl -L https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

apt-get -y update

ACCEPT_EULA=Y apt-get install -y msodbcsql18
ACCEPT_EULA=Y apt-get install -y mssql-tools18 
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"'>> ~/.bashrc
source ~/.bashrc
apt-get -y update
apt-get -y install unixodbc unixodbc-dev libpq-dev libxml2-dev
pecl install sqlsrv pdo_sqlsrv
docker-php-ext-enable sqlsrv pdo_sqlsrv
