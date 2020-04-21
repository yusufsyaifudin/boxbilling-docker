FROM dockette/jessie

MAINTAINER Yusuf Syaifudin <yusuf.syaifudin@gmail.com>

# PHP
ENV PHP_MODS_DIR=/etc/php/5.6/mods-available
ENV PHP_CLI_DIR=/etc/php/5.6/cli
ENV PHP_CLI_CONF_DIR=${PHP_CLI_DIR}/conf.d
ENV PHP_CGI_DIR=/etc/php/5.6/cgi
ENV PHP_CGI_CONF_DIR=${PHP_CGI_DIR}/conf.d
ENV PHP_FPM_DIR=/etc/php/5.6/fpm
ENV PHP_FPM_CONF_DIR=${PHP_FPM_DIR}/conf.d
ENV PHP_FPM_POOL_DIR=${PHP_FPM_DIR}/pool.d
ENV TZ=America/Los_Angeles

# INSTALLATION
RUN apt-get update && apt-get dist-upgrade -y && \
    # DEPENDENCIES #############################################################
    apt-get install -y wget curl apt-transport-https ca-certificates lsb-release && \
    # PHP DEB.SURY.CZ ##########################################################
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    echo "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list && \
    sh -c 'echo "deb http://opensource.wandisco.com/debian `lsb_release -cs` svn19" >> /etc/apt/sources.list.d/subversion18.list' && \
    wget -q http://opensource.wandisco.com/wandisco-debian.gpg -O- | apt-key add - && \
    apt-get update && \
    apt-get install -y git subversion nodejs && \
    apt-get install -y --no-install-recommends \
        php5.6-apc \
        php5.6-apcu \
        php5.6-bcmath \
        php5.6-bz2 \
        php5.6-calendar \
        php5.6-cgi \
        php5.6-cli \
        php5.6-ctype \
        php5.6-curl \
        php5.6-fpm \
        php5.6-geoip \
        php5.6-gettext \
        php5.6-gd \
        php5.6-intl \
        php5.6-imagick \
        php5.6-imap \
        php5.6-ldap \
        php5.6-mbstring \
        php5.6-mcrypt \
        php5.6-memcached \
        php5.6-mongo \
        php5.6-mysql \
        php5.6-pdo \
        php5.6-pgsql \
        php5.6-redis \
        php5.6-soap \
        php5.6-sqlite3 \
        php5.6-ssh2 \
        php5.6-zip \
        php5.6-xmlrpc \
        php5.6-xsl && \
    # COMPOSER #################################################################
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer global require "hirak/prestissimo:^0.3" && \
    # PHP MOD(s) ###############################################################
    ln -s ${PHP_MODS_DIR}/custom.ini ${PHP_CLI_CONF_DIR}/999-custom.ini && \
    ln -s ${PHP_MODS_DIR}/custom.ini ${PHP_CGI_CONF_DIR}/999-custom.ini && \
    ln -s ${PHP_MODS_DIR}/custom.ini ${PHP_FPM_CONF_DIR}/999-custom.ini && \
    # CLEAN UP #################################################################
    rm ${PHP_FPM_POOL_DIR}/www.conf && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get remove -y wget curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

# FILES (it overrides originals)
ADD conf.d/custom.ini ${PHP_MODS_DIR}/custom.ini
ADD fpm/php-fpm.conf ${PHP_FPM_DIR}/php-fpm.conf

# WORKDIR
#COPY srv /srv
#RUN cd /srv/src && composer install
#WORKDIR /srv
RUN mkdir /app
WORKDIR /app

#EXPOSE 8000

# COMMAND
#CMD ["php-fpm5.6"]
#CMD ["php", "-S", "0.0.0.0:8000", "-t", "/app/src"]
