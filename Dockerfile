FROM centos:latest
LABEL maintainer="Bryan Huang"
LABEL email="bryan.huang@virtualjoy.co"


# - Install basic packages needed by supervisord
# - Install inotify, needed to automate daemon restarts after config file changes
# - Install supervisord (via python's easy_install - as it has the newest 3.x version)

#Install tools
RUN yum install -y yum-utils python-setuptools inotify-tools unzip sendmail tar mysql sudo wget telnet rsync git nmap

#Install yum repos and utils epel-release
#rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm  && \
#yum -y install epel-release && \
RUN yum -y install epel-release
RUN yum -y install epel-release && \
  rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
  yum-config-manager -q --enable remi && \
  yum-config-manager -q --enable remi-php72


RUN yum install -y php-fpm php-common memcached
RUN yum install -y php-pecl-apc php-cli php-pear php-pdo php-mysql php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml php-adodb php-imap php-intl php-soap
RUN yum install -y php-mysqli php-zip php-iconv php-curl php-simplexml php-dom php-bcmath php-opcache php-pecl-redis

#Clean up yum repos to save spaces
RUN yum update -y && yum clean all && rm -rf /var/cache/yum \

#Install supervisor
RUN easy_install supervisor
#Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD php-fpm.conf /etc/php-fpm.conf
ADD www.conf /etc/php-fpm.d/www.conf

EXPOSE 9000

CMD ['php']