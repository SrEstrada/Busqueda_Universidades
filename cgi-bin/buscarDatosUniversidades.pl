#!/usr/bin/perl
use strict;
use warnings;
use CGI ':standard';

print header(-charset => 'UTF-8');
print start_html(-title=>'Resultado de Búsqueda');

my $nombre       = param('nombre');
my $periodo      = param('periodo');
my $departamento = param('departamento');
my $gestion      = param('gestion');

if (!$nombre && !$periodo && !$departamento && !$gestion) {
    print "<p>Error: Debe ingresar al menos un criterio de búsqueda.</p>";
} else {
    open my $fh, '<', 'Data_Universidades_Lab06.csv' or die "No se puede abrir el archivo: $!";
    
    my $found = 0;  # Variable para indicar si encontramos una coincidencia
    print "<h3>Resultados de la búsqueda:</h3>";
    
    while (my $line = <$fh>) {
        chomp $line;
        
        # Separa cada línea en columnas usando coma como delimitador
        my @fields = split /,/, $line;
        my ($codigo, $nombre_univ, $tipo_gestion, $estado, $fecha_inicio, $fecha_fin, $periodo_lic, $departamento_local) = @fields;
        
        # Realiza la búsqueda de cada criterio solo si el usuario ingresó un valor
        if ((!$nombre       || $nombre_univ =~ /\Q$nombre\E/i) &&
            (!$periodo      || $periodo_lic =~ /\Q$periodo\E/i) &&
            (!$departamento || $departamento_local =~ /\Q$departamento\E/i) &&
            (!$gestion      || $tipo_gestion =~ /\Q$gestion\E/i)) {
            
            print "<p>Universidad encontrada: $line</p>";
            $found = 1;
        }
    }
    
    # Mostrar mensaje si no se encontraron coincidencias
    print "<p>No se encontraron resultados para los criterios ingresados.</p>" unless $found;

    close $fh;
}

print end_html;
