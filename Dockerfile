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

RUN apt-get install -y locales

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

RUN mkdir -p /home/pweb/scripts

RUN chown pweb:pweb -R /home/pweb/scripts

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN a2enmod cgid
RUN service apache2 restart

RUN systemctl enable ssh
#RUN service ssh start



COPY ./html/* /var/www/html/
COPY ./css/* /var/www/html/css/
COPY ./images/* /var/www/html/images/
COPY ./cgi-bin/buscarDatosUniversidades.pl /usr/lib/cgi-bin

#COPY ./scripts/* /home/pweb/.

#COPY ./cgi-bin/cgi01.pl /usr/lib/cgi-bin

COPY ./cgi-bin/data/ProgramasdeUniversidades.csv /usr/lib/cgi-bin/data/

#RUN chmod +x /usr/lib/cgi-bin/cgi01.pl

#RUN chmod +x /usr/lib/cgi-bin/calculadora.pl

#RUN chmod +x /usr/lib/cgi-bin/*
RUN chmod 755 /usr/lib/cgi-bin/buscarDatosUniversidades.pl
#RUN chmod 755 /usr/lib/cgi-bin/cgi01.pl

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 80
EXPOSE 22

#CMD ["apachectl", "-D", "FOREGROUND"]
CMD ["bash", "-c", "service ssh start && apachectl -D FOREGROUND"]

# docker build -f dockerfile4.txt -t iminideb4 .
# docker run -d -p 8112:80 -p 2201:22 --name cminideb4 iminideb4
# docker stop cminideb4
# docker start cminideb4
# docker exec -it cminideb4 /bin/bash
# docker rm cminideb4
# docker rmi iminideb4

# http://127.0.0.1:8112/
# http://127.0.0.1:8112/cgi-bin/cgi01.pl

# ssh -p 2201 pweb@127.0.0.1 -t bash
# cd $HOME/scripts
# perl script01.pl