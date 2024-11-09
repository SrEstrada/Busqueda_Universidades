#!/usr/bin/perl
use strict;
use warnings;
use CGI ':standard';

print header(-charset => 'UTF-8');
print start_html(-title=>'Resultado de Búsqueda');

my $nombre = param('nombre');

if (!$nombre) {
    print "<p>Error: Debe ingresar un nombre de universidad.</p>";
} else {
    open my $fh, '<', 'Data_Universidades_Lab06.csv' or die "No se puede abrir el archivo: $!";
    while (my $line = <$fh>) {
        chomp $line;
        # El procesamiento de datos se realizará en siguientes commits
    }
    close $fh;
}

print end_html;
