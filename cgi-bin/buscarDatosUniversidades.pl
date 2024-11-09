#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Text::CSV;

# Configuración inicial CGI y encabezado HTML
my $cgi = CGI->new;
print $cgi->header(-charset => 'UTF-8');
print $cgi->start_html(-title => 'Resultado de Búsqueda');

# Parámetro de búsqueda ingresado en el formulario HTML
my $nombre_universidad = $cgi->param('nombre') || '';

# Configuración de archivo CSV y lectura de datos
my $archivo_csv = "../cgi-bin/Data_Universidades_Lab06.csv";
my $csv = Text::CSV->new({ binary => 1 });

open my $fh, "<:encoding(utf8)", $archivo_csv or die "No se pudo abrir '$archivo_csv' $!\n";

# Búsqueda de coincidencias en el archivo CSV
my @resultados;
while (my $row = $csv->getline($fh)) {
    my ($nombre, $ubicacion, $tipo) = @$row;
    if ($nombre =~ /\Q$nombre_universidad\E/i) {
        push @resultados, { nombre => $nombre, ubicacion => $ubicacion, tipo => $tipo };
    }
}
close $fh;

# Generación de respuesta HTML basada en los resultados encontrados
print "<html><head><title>Resultados</title></head><body>";
print "<h1>Resultados de búsqueda</h1>";

if (@resultados) {
    print "<ul>";
    foreach my $uni (@resultados) {
        print "<li>$uni->{nombre} - $uni->{ubicacion} ($uni->{tipo})</li>";
    }
    print "</ul>";
} else {
    print "<p>No se encontraron resultados para '$nombre_universidad'.</p>";
}
print "</body></html>";
