FROM phusion/baseimage:latest

ENV DEBIAN_FRONTEND noninteractive
ENV MYCNF_PHP_DATE___TIMEZONE "Etc/UTC"
ENV MYCNF_SNMP_COMMUNITY "public"

RUN apt-get -qq update \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y dist-upgrade \
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

#VOLUME ["/opt/librenms"]

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
COPY ./configs/nginx/librenms.conf /etc/nginx/conf.d/librenms.conf
RUN rm /etc/nginx/sites-enabled/default
RUN phpenmod mcrypt

# Copy Configuration Files
RUN cp /opt/librenms/snmpd.conf.example /etc/snmp/snmpd.conf \
    && cp /opt/librenms/misc/librenms.logrotate /etc/logrotate.d/librenms \
    && cp /opt/librenms/librenms.nonroot.cron /etc/cron.d/librenms

# Copy SNMP Config
RUN curl -o /usr/bin/distro https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro \
    && chmod +x /usr/bin/distro

# Change Final Permissions
RUN chown -R librenms:librenms /opt/librenms

# Copy Service Files
RUN mkdir -p /etc/my_init.d
COPY ./my_init.d/ /etc/my_init.d/
COPY ./service/ /etc/service/

#EXPOSE 9350

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
