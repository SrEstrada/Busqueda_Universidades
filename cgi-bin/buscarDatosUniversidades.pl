#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Text::CSV;

print "Content-type: text/html\n\n";

# Configuración de CGI
my $query = CGI->new;

# Obtener los parámetros del formulario
my $nombre_universidad = $query->param("nombre_universidad") || "";
my $periodo_licenciamiento = $query->param("periodo_licenciamiento") || "";
my $departamento_local = $query->param("departamento_local") || "";
my $denominacion_programa = $query->param("denominacion_programa") || "";

# Ruta del archivo CSV
my $file_path = "/usr/lib/cgi-bin/data/Programas_de_Universidades1.csv";
open(my $fh, "<", $file_path) or die "No se pudo abrir el archivo CSV: $!";

# Leer y procesar el archivo CSV
my $csv = Text::CSV->new({ sep_char => '|' });
my @resultados;

while (my $row = $csv->getline($fh)) {
    my ($codigo_entidad, $nombre, $tipo_gestion, $estado_licenciamiento, $periodo, $codigo_filial, $nombre_filial,
        $departamento_filial, $provincia_filial, $codigo_local, $departamento_local, $provincia_local,
        $distrito_local, $latitud_ubicacion, $longitud_ubicacion, $tipo_autorizacion_local, 
        $denominacion, $tipo_nivel_academico, $nivel_academico, $codigo_clase_programa, 
        $nombre_clase_programa, $tipo_autorizacion_programa, $tipo_autorizacion_local) = @$row;

    # Filtrar los resultados según los parámetros
    if ($nombre =~ /\Q$nombre_universidad\E/i &&
        $periodo =~ /\Q$periodo_licenciamiento\E/i &&
        $departamento_local =~ /\Q$departamento_local\E/i &&
        $denominacion =~ /\Q$denominacion_programa\E/i) {

        push @resultados, $row;
    }
}
close $fh;

# Imprimir resultados en HTML
print "<html><body>";
print "<h1>Resultados de Búsqueda</h1>";
if (@resultados) {
    print "<table border='1'>";
    print "<tr><th>Nombre Universidad</th><th>Periodo Licenciamiento</th><th>Departamento Local</th><th>Denominación Programa</th></tr>";
    foreach my $row (@resultados) {
        print "<tr>";
        print "<td>$_</td>" for @$row[1, 4, 10, 16];
        print "</tr>";
    }
    print "</table>";
} else {
    print "<p>No se encontraron resultados.</p>";
}
print "</body></html>";
