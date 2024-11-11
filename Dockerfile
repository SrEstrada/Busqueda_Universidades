FROM bitnami/minideb

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install -y apache2 perl libcgi-pm-perl libtext-csv-perl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod cgid

RUN mkdir -p /usr/lib/cgi-bin /var/www/index.html

COPY ./cgi-bin/ /usr/lib/cgi-bin/
COPY ./index.html/ /var/www/index.html/

RUN chmod +x /usr/lib/cgi-bin/*.pl && \
    chmod -R 755 /usr/lib/cgi-bin/* && \
    chmod 755 /var/www/*.index.html
    
RUN chmod -R 755 /var/www/index.html

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
