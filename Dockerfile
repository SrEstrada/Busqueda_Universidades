# Usa una imagen base de Apache con Perl
FROM httpd:2.4

# Copia el archivo de configuración para habilitar CGI
RUN apt-get update && \
    apt-get install -y perl && \
    apt-get clean

# Habilita CGI en Apache
RUN sed -i '/^#LoadModule cgi_module/ s/^#//' /usr/local/apache2/conf/httpd.conf
RUN echo "ScriptAlias /cgi-bin/ /usr/local/apache2/cgi-bin/" >> /usr/local/apache2/conf/httpd.conf
RUN echo "<Directory \"/usr/local/apache2/cgi-bin\">\n    AllowOverride None\n    Options +ExecCGI\n    Require all granted\n</Directory>" >> /usr/local/apache2/conf/httpd.conf

# Copia los archivos en sus respectivas ubicaciones
COPY cgi-bin/ /usr/local/apache2/cgi-bin/
COPY htdocs/ /usr/local/apache2/htdocs/

# Da permisos de ejecución al script Perl en cgi-bin
RUN chmod +x /usr/local/apache2/cgi-bin/buscarDatosUniversidades.pl

# Exponer el puerto 80 para el servidor Apache
EXPOSE 80

# Inicia Apache
CMD ["httpd-foreground"]
