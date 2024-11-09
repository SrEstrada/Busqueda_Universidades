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
    
    my $found = 0;  # Variable para indicar si encontramos una coincidencia
    while (my $line = <$fh>) {
        chomp $line;
        
        # Si el nombre buscado se encuentra en la línea actual
        if ($line =~ /\Q$nombre\E/i) {
            print "<h3>Resultado de la búsqueda:</h3>";
            print "<p>Universidad encontrada: $line</p>";
            $found = 1;
            last;  # Salir del ciclo una vez encontrada la coincidencia
        }
    }
    
    # Mostrar mensaje si no se encontraron coincidencias
    print "<p>No se encontraron resultados para \"$nombre\".</p>" unless $found;

    close $fh;
}

print end_html;

