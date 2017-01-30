FROM phusion/baseimage:latest

ENV DEBIAN_FRONTEND noninteractive
ENV MYCNF_PHP_DATE___TIMEZONE "Etc/UTC"
ENV MYCNF_SNMP_COMMUNITY "public"
ENV LIBRENMS_AUTOUPDATE "no"

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
    nano

# Components for LibreNMS
RUN apt-get install -y php7.0-cli \
    php7.0-mysql \
    php7.0-gd \
    php7.0-snmp \
    php-pear \
    php7.0-curl \
    php7.0-fpm \
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
    php-net-ipv4 \
    php-net-ipv6 \
    rrdtool \
    git

# Create LibreNMS User
RUN useradd librenms -d /opt/librenms -M -r \
    && usermod -a -G librenms www-data

# Clone the LibreNMS Repository
RUN cd /opt \
    && git clone https://github.com/librenms/librenms.git librenms

# Change Permissions
RUN cd /opt/librenms \
    && mkdir rrd logs \
    && chmod 775 rrd

# Copy NGINX Configuration for LibreNMS
COPY ./configs/nginx/conf.d/* /etc/nginx/conf.d/
COPY ./configs/nginx/snippets/* /etc/nginx/snippets/
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
COPY ./my_init.d/ /etc/my_init.d/
COPY ./service/ /etc/service/

# Cleanup
RUN apt-get -yq autoremove --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
