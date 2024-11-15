FROM bitnami/minideb

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y perl
RUN apt-get install -y openssh-server
RUN apt -y install systemctl
RUN apt -y install vim
RUN apt -y install bash
RUN apt-get install -y locales
RUN apt-get install -y tree
RUN apt-get install -y libcgi-pm-perl
RUN apt-get install -y libtext-csv-perl

RUN echo -e 'LANG=es_PE.UTF-8\nLC_ALL=es_PE.UTF-8' > /etc/default/locale
RUN sed -i 's/^# *\(es_PE.UTF-8\)/\1/' /etc/locale.gen
RUN /sbin/locale-gen es_PE.UTF-8

RUN mkdir -p /home/pweb
RUN useradd pweb -m && echo "pweb:12345678" | chpasswd
RUN echo "root:12345678" | chpasswd
RUN chown pweb:www-data /usr/lib/cgi-bin/
RUN chown pweb:www-data /var/www/html/
RUN chmod 750 /usr/lib/cgi-bin/
RUN chmod 750 /var/www/html/

RUN echo "export LC_ALL=es_PE.UTF-8" >> /home/pweb/.bashrc
RUN echo "export LANG=es_PE.UTF-8" >> /home/pweb/.bashrc
RUN echo "export LANGUAGE=es_PE.UTF-8" >> /home/pweb/.bashrc

RUN ln -s /usr/lib/cgi-bin /home/pweb/cgi-bin
RUN ln -s /var/www/html/ /home/pweb/html

RUN ln -s /home/pweb /usr/lib/cgi-bin/toHOME
RUN ln -s /home/pweb /var/www/html/toHOME

# Configuración de ServerName para evitar el error de dominio
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN a2enmod cgid
RUN service apache2 restart

RUN systemctl enable ssh

COPY ./cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/buscarDatosUniversidades.pl

COPY . /var/www/html

EXPOSE 80
EXPOSE 22

CMD ["bash", "-c", "service ssh start && apachectl -D FOREGROUND"]
