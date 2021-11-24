FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get -y install apache2

COPY ./ /var/www/html/
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80