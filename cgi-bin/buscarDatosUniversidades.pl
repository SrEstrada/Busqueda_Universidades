#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Text::CSV;
use utf8;
use Unicode::Normalize;

# Configuración de la codificación UTF-8
binmode(STDOUT, ":utf8");

# Inicializa CGI
my $cgi = CGI->new();

# Obtiene los parámetros de entrada del formulario
my $uniName = $cgi->param('universityName') || '';
my $licPeriod = $cgi->param('licencePeriod') || '';
my $depLocal = $cgi->param('localDepartment') || '';
my $pName = $cgi->param('programName') || '';

# Normaliza las cadenas para manejar diacríticos
my $normalized_uniName = nfkd($uniName);
my $normalized_licPeriod = nfkd($licPeriod);
my $normalized_depLocal = nfkd($depLocal);
my $normalized_pName = nfkd($pName);

# Ruta del archivo CSV (ajusta según tu ubicación)
my $archivo = '/usr/lib/cgi-bin/data/ProgramasdeUniversidades.csv';

# Abre el archivo CSV
open my $fh, '<:encoding(UTF-8)', $archivo or die "No se pudo abrir el archivo CSV: $!";

# Inicializa el módulo CSV
my $csv = Text::CSV->new({ binary => 1, sep_char => '|' });

# Construye la fila de encabezados de la tabla
my $tableKey = "<th>Nombre</th><th>Fecha Inicio Licenciamiento</th><th>Departamento Filial</th><th>Latitud Ubicación</th>";

# Variables para almacenar resultados
my $tableValues = "";
my $coincidenciasTotales = 0;

# Itera sobre cada fila del CSV y verifica coincidencias
while (my $fila = $csv->getline($fh)) {
    my @selectedValues = map { nfkd($_) } @{$fila}[1, 4, 10, 16];

    if ($selectedValues[0] =~ /$normalized_uniName/i &&
        $selectedValues[1] =~ /$normalized_licPeriod/i &&
        $selectedValues[2] =~ /$normalized_depLocal/i &&
        $selectedValues[3] =~ /$normalized_pName/i) {
        $coincidenciasTotales++;
        $tableValues .= "<tr>";
        for my $valor (@selectedValues) {
            $tableValues .= "<td>$valor</td>\n";
        }
        $tableValues .= "</tr>";
    }
}
close $fh;

# Mensaje de resultado de coincidencias
my $resultadoBusqueda = "Existen $coincidenciasTotales resultados de búsqueda";

# Genera la salida HTML
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
        <h2><a href="../html/index.html">Para volver a buscar, presione aquí</a></h2>
        <h1>Resultados de la Búsqueda</h1>
    </div>
    <table>
        <tr>$tableKey</tr>
        $tableValues
    </table>
</body>
</html>
HTML
