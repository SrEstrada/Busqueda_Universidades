#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Text::CSV;
use utf8;

# Inicializa CGI
my $cgi = CGI->new();

# Imprime el encabezado de contenido HTML
print "Content-type: text/html\n\n";

# Obtiene los parámetros de entrada del formulario CGI
my $uniName   = $cgi->param('universityName')   || qr/.*/;
my $licPeriod = $cgi->param('licencePeriod')    || qr/.*/;
my $depLocal  = $cgi->param('localDepartment')  || qr/.*/;
my $pName     = $cgi->param('programName')      || qr/.*/;

# Decodifica los parámetros en caso de caracteres especiales
utf8::decode($uniName);
utf8::decode($licPeriod);
utf8::decode($depLocal);
utf8::decode($pName);

# Ruta del archivo CSV
my $archivo = '/usr/local/apache2/cgi-bin/ProgramasdeUniversidades.csv';

# Abre el archivo CSV o muestra un error si no se encuentra
open my $fh, '<', $archivo or die "No se pudo abrir el archivo CSV: $!";

# Inicializa el módulo CSV con el delimitador correcto
my $csv = Text::CSV->new({ binary => 1, sep_char => '|' });

# Lee las cabeceras y construye la fila de encabezados de la tabla HTML
my $tableKey = "";
if (my $fila = $csv->getline($fh)) {
    my @selectedValues = map { $fila->[$_] } (1, 4, 10, 16);
    for my $valor (@selectedValues) {
        $tableKey .= "<th>$valor</th>\n";
    }
}

# Variables para almacenar resultados y conteo de coincidencias
my $tableValues = "";
my $coincidenciasTotales = 0;

# Itera sobre cada fila del archivo CSV y verifica coincidencias
while (my $fila = $csv->getline($fh)) {
    my @selectedValues = map { $fila->[$_] } (1, 4, 10, 16);
    if ($selectedValues[0] =~ /$uniName/i &&
        $selectedValues[1] =~ /$licPeriod/i &&
        $selectedValues[2] =~ /$depLocal/i &&
        $selectedValues[3] =~ /$pName/i) {
        
        $tableValues .= "<tr>";
        for my $valor (@selectedValues) {
            $tableValues .= "<td>$valor</td>\n";
        }
        $tableValues .= "</tr>";
        $coincidenciasTotales++;
    }
}
close $fh;

# Mensaje de resultado de coincidencias
my $resultadoBusqueda = "Existen $coincidenciasTotales resultados de búsqueda";

# Genera la salida HTML
print $cgi->header('text/html');

print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultados Búsqueda</title>
    <style>
        * {
            font-family: 'Open Sans', sans-serif;
            background-color: #31304D;
        }
        table {
            border: solid 2px;
            width: 100%;
            background-color: #161A30;
        }
        th, td {
            text-align: center;
            padding: 8px;
            border: solid 2px;
            background-color: #B6BBC4;
        }
        div {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            color: #e9e5cf;
        }
        a {
            text-decoration: none;
        }
        a:visited {
            color: #e9e5cf;
        }
    </style>
</head>
<body>
    <div>
        <h2>$resultadoBusqueda</h2>
        <h2><a href="../../lab09/index.html">Para volver a buscar, presione aquí</a></h2>
        <h1>Resultados de la Búsqueda</h1>
    </div>
    <table>
        <tr>$tableKey</tr>
        $tableValues
    </table>
</body>
</html>
HTML
