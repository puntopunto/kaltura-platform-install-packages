FROM centos:6


RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# ssl
RUN yum install -y certbot certonly
RUN certbot certonly -d fsboard.gq --nginx --apache --standalone -n --agree-tos -m usheynet@gmail.com


# mysql
RUN yum install -y mysql mysql-server
RUN mysql_install_db
RUN chkconfig mysqld on
RUN service mysqld start


# facilities
RUN yum install -y postfix memcached ntp
RUN chkconfig postfix on
RUN chkconfig memcached on
RUN chkconfig ntpd on
RUN service postfix start
RUN service memcached start
RUN service ntpd start


# kaltura
RUN rpm -ihv http://installrepo.kaltura.org/releases/kaltura-release.noarch.rpm
RUN yum install -y kaltura-server

COPY docker/install/* /root/install/
RUN chmod +x /root/install/install.sh

EXPOSE 80 443 1935 88 8443


# start services
CMD ["/sbin/init"]
