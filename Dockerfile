# Main image build file

FROM centos:7
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

## basic prepare - TODO
# timezone
# locale to default
RUN localectl set-locale C

## repos
# EPEL
#RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# RPM Fusion
#RUN yum localinstall --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm && yum install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted

## ssl
#RUN yum install -y certbot
#RUN certbot certonly -d fsboard.gq --standalone -n --agree-tos -m usheynet@gmail.com

## mysql
RUN yum install -y mysql mysql-server
RUN mysql_install_db
RUN chkconfig mysqld on
RUN service mysqld start

## facilities
RUN yum install -y postfix memcached ntp
RUN chkconfig postfix on
RUN chkconfig memcached on
RUN chkconfig ntpd on
RUN service postfix start
RUN service memcached start
RUN service ntpd start

## kaltura
RUN rpm -ihv http://installrepo.kaltura.org/releases/kaltura-release.noarch.rpm
RUN yum install -y kaltura-server

COPY docker/install/* /root/install/
RUN chmod +x /root/install/install.sh

EXPOSE 80 443 1935 88 8443

## start services
CMD ["/sbin/init"]
