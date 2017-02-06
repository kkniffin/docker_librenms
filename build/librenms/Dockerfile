FROM phusion/baseimage:latest

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV MYCNF_PHP_DATE___TIMEZONE "Etc/UTC"
ENV MYCNF_SNMP_COMMUNITY "public"
# LibreNMS Environment Variables
ENV LIBRENMS_AUTOUPDATE "true"
ENV LIBRENMS_CONFIG_PHP_DBHOST "db"
ENV LIBRENMS_CONFIG_PHP_DBUSER "librenms"
ENV LIBRENMS_CONFIG_PHP_DBPASS "l1br3nm5!"
ENV LIBRENMS_CONFIG_PHP_BASEURL "https://test.home.local"
ENV LIBRENMS_CONFIG_PHP_DB "librenms"
ENV LIBRENMS_CONFIG_PHP_DBPORT "3306"
ENV NGINX_SERVERNAME "test.home.local"

RUN apt-get -qq update \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y dist-upgrade \
    && apt-get -yq purge openssh-.* \
    && apt-get -yq autoremove --purge \
    && apt-get install -y curl \
    ntp \
    ntpdate \
    tzdata \
    wget \
    apt-transport-https \
    net-tools \
    nano \
    build-essential


# Components for LibreNMS
RUN apt-get install -y php7.0-cli \
    php7.0-mysql \
    php7.0-gd \
    php7.0-snmp \
    php-pear \
    php7.0-curl \
    php7.0-fpm \
    php7.0-opcache \
    php7.0-ldap \
    php-memcached \
    php-imagick \
    php-pear \
    php-net-ipv4 \
    php-net-ipv6 \
    snmp \
    graphviz \
    php7.0-mcrypt \
    php7.0-json \
    nginx-full \
    fping \
    imagemagick \
    whois \
    mtr-tiny \
    nmap \
    python-mysqldb \
    snmpd \
    rrdcached \
    rrdtool \
    php-net-ipv4 \
    php-net-ipv6 \
    git \
    memcached

# Create LibreNMS User
RUN useradd librenms -d /opt/librenms -M -r \
    && usermod -a -G librenms www-data

# Clone the LibreNMS Repository
RUN cd /opt \
    && git clone https://github.com/librenms/librenms.git librenms

# Make Directories & Change Permissions
RUN cd /opt/librenms \
    && mkdir rrd logs

# Copy NGINX Configuration for LibreNMS
COPY ./files/etc/nginx/conf.d/* /etc/nginx/conf.d/
COPY ./files/etc/nginx/snippets/* /etc/nginx/snippets/
RUN rm /etc/nginx/sites-enabled/default
RUN phpenmod mcrypt

# Copy Configuration Files
RUN cp /opt/librenms/snmpd.conf.example /etc/snmp/snmpd.conf \
    && cp /opt/librenms/misc/librenms.logrotate /etc/logrotate.d/librenms \
    && cp /opt/librenms/librenms.nonroot.cron /etc/cron.d/librenms

# Tweak PHP
RUN sed -i 's/pm.max_children = 5/pm.max_children = 24/g' /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i 's/pm.start_servers = 2/pm.start_servers = 4/g' /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 4/g' /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 8/g' /etc/php/7.0/fpm/pool.d/www.conf \
    && sed -i 's/;clear_env/clear_env/g' /etc/php/7.0/fpm/pool.d/www.conf

# Copy SNMP Config
RUN curl -o /usr/bin/distro https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro \
    && chmod +x /usr/bin/distro

# Change Final Permissions
RUN chown -R librenms:librenms /opt/librenms

# Copy Service Files
RUN mkdir -p /etc/my_init.d
RUN mkdir -p /configs/librenms/
COPY ./files/etc/my_init.d/ /etc/my_init.d/
COPY ./files/etc/service/ /etc/service/

# Copy Default Configs
COPY ./files/opt/librenms/config.php /configs_default/

# Cleanup
RUN apt-get -yq autoremove --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Volumes
VOLUME ["/opt/librenms/logs", "/opt/librenms/rrd", "/etc/ssl", "/var/log/nginx", "/configs"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
