#!/usr/bin/perl
use strict;
use warnings;
use CGI ':standard';

# Captura de parámetros
my $nombre = param('nombre');
my $periodo = param('periodo');
my $departamento = param('departamento');
my $programa = param('programa');

# Subrutina principal que realiza la búsqueda
sub realizarBusqueda {
    my ($nombre, $periodo, $departamento, $programa) = @_;
    my @resultados;
    
    open my $fh, '<', 'Data_Universidades_Lab06.csv' or die "No se puede abrir el archivo: $!";
    while (my $line = <$fh>) {
        chomp $line;
        
        # Validación de coincidencias en cada criterio
        if (($nombre eq '' or $line =~ /\Q$nombre\E/i) &&
            ($periodo eq '' or $line =~ /\Q$periodo\E/i) &&
            ($departamento eq '' or $line =~ /\Q$departamento\E/i) &&
            ($programa eq '' or $line =~ /\Q$programa\E/i)) {
            push @resultados, $line;
        }
    }
    close $fh;
    
    return @resultados;
}

# Subrutina que genera el HTML de respuesta
sub generarHTML {
    my ($nombre, $periodo, $departamento, $programa, @resultados) = @_;
    
    print header(-charset => 'UTF-8');
    print start_html(-title => 'Resultado de Búsqueda');
    
    if (!@resultados) {
        print "<p>No se encontraron resultados para los criterios ingresados.</p>";
    } else {
        print "<h3>Resultados de la búsqueda:</h3><ul>";
        foreach my $resultado (@resultados) {
            print "<li>Universidad encontrada: $resultado</li>";
        }
        print "</ul>";
    }
    
    print end_html;
}

# Ejecución de búsqueda y generación de respuesta HTML
my @resultados = realizarBusqueda($nombre, $periodo, $departamento, $programa);
generarHTML($nombre, $periodo, $departamento, $programa, @resultados);
