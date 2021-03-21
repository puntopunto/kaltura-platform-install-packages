# Main image build file

## SYSTEM
# base
FROM centos:7

# networking
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# date and locale
#RUN localectl set-locale C - wrong/fix
#RUN timedatectl set-timezone - $(???)

## SSL (hardcocded for now, fix)
FROM docker.io/certbot/certbot
RUN certbot certonly -d fsboard.gq --standalone -n --agree-tos -m usheynet@gmail.com

## INSTALLER FILES - STAGE 1
# import platform installer and common files
COPY docker/install/* /root/install/

## MYSQL
# import
FROM docker.io/percona:5.6.51
RUN mysql_install_db
COPY /root/install/percona-mysql56-server.service /etc/systemd/system/mysql.service
RUN systemctl enable --now mysql
RUN systemctl restart mysql

## FACILITIES
RUN yum install -y postfix memcached ntp
RUN systemctl enable --now postfix memcached ntpd
RUN systemctl restart postfix memcached ntpd

## PRE-INSTALL KALTURA-SERVER
RUN rpm -ihv http://installrepo.kaltura.org/releases/kaltura-release.noarch.rpm
RUN yum install -y kaltura-server

## SET PERMISSIONS & ACCESS
# installer permissions
RUN chmod +x /root/install/install.sh
# web access
EXPOSE 80 443 1935 88 8443

## ENTRYPOINT
# start services
CMD ["/sbin/init"]
