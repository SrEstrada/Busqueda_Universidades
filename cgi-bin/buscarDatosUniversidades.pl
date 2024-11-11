#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Text::CSV;

# Crear objeto CGI
my $q = CGI->new;

# Capturar parámetros del formulario
my $nombre = $q->param('nombre') || '';
my $periodo = $q->param('periodo') || '';
my $departamento = $q->param('departamento') || '';
my $tipo_gestion = $q->param('gestion') || '';

# Verificar si al menos un campo tiene datos
unless ($nombre || $periodo || $departamento || $tipo_gestion) {
    print $q->header('text/html; charset=UTF-8');
    print "<p>Error: Debe ingresar al menos un criterio de búsqueda.</p>";
    exit;
}

# Especificar la ruta del archivo CSV
my $csv_file = "/cgi-bin/Programas de Universidades.csv";

# Crear el objeto CSV
my $csv = Text::CSV->new({ binary => 1, sep_char => '|' }) or die "Error al crear CSV: " . Text::CSV->error_diag();

# Abrir archivo CSV
open my $fh, '<', $csv_file or die "No se pudo abrir el archivo '$csv_file': $!";

# Imprimir encabezado HTML
print $q->header('text/html; charset=UTF-8');
print "<html><head><title>Resultados de Búsqueda</title></head><body>";
print "<h1>Resultados de la Búsqueda</h1>";
print "<table border='1'><tr><th>Nombre</th><th>Periodo</th><th>Departamento</th><th>Gestión</th></tr>";

# Leer y filtrar los datos
while (my $row = $csv->getline($fh)) {
    my ($csv_nombre, $csv_periodo, $csv_departamento, $csv_gestion) = @$row;

    # Filtrar los resultados
    if (($nombre eq '' || $csv_nombre =~ /\Q$nombre\E/i) &&
        ($periodo eq '' || $csv_periodo =~ /\Q$periodo\E/i) &&
        ($departamento eq '' || $csv_departamento =~ /\Q$departamento\E/i) &&
        ($tipo_gestion eq '' || $csv_gestion =~ /\Q$tipo_gestion\E/i)) {
        
        # Imprimir resultado en tabla
        print "<tr><td>$csv_nombre</td><td>$csv_periodo</td><td>$csv_departamento</td><td>$csv_gestion</td></tr>";
    }
}

# Cerrar tabla y HTML
print "</table></body></html>";

# Cerrar archivo CSV
close $fh or warn "No se pudo cerrar el archivo '$csv_file': $!";