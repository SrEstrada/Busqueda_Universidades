#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use CGI;
use Text::CSV;
use utf8;

my $cgi = new CGI;

my $uniName   = $cgi->param('universityName')   || qr/.*/;
my $licPeriod = $cgi->param('licencePeriod')    || qr/.*/;
my $depLocal  = $cgi->param('localDepartment')  || qr/.*/;
my $pName     = $cgi->param('programName')      || qr/.*/;

utf8::decode($uniName);
utf8::decode($licPeriod);
utf8::decode($depLocal);
utf8::decode($pName);

my $archivo = '../ProgramasdeUniversidades.csv';

open my $fh, '<', $archivo or die "No soportó";

my $csv = Text::CSV->new({ binary => 1, sep_char => '|'});

my $tableKey = "";
if (my $fila = $csv->getline($fh)) {
    my @selectedValues = map { $fila->[$_] } (1, 4, 10, 16);
    for my $valor (@selectedValues) {
        $tableKey .= "<th>$valor</th>\n";
    }
}

my $tableValues = "";
my $coincidenciasTotales = 0;

while(my $fila = $csv->getline($fh)){
    my @selectedValues = map { $fila->[$_] } (1, 4, 10, 16);
    if($selectedValues[0] =~ /$uniName/i && $selectedValues[1] =~ /$licPeriod/i && $selectedValues[2] =~ /$depLocal/i && $selectedValues[3] =~ /$pName/i){
        $tableValues .= "<tr>";
        for my $valor (@selectedValues) {
            $tableValues .= "<td>$valor</td>\n";
        }
        $tableValues .= "</tr>";
        $coincidenciasTotales++;
    }
}
close $fh;
$coincidenciasTotales = "Existen $coincidenciasTotales resultados de búsqueda";

print $cgi->header('text/html');

print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultados Búsqueda</title>
    <style>
        *{
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
        div{
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            color: #e9e5cf;
        }
        a{
            text-decoration: none;
        }
        a:visited{
            color: #e9e5cf;
        }
    </style>
</head>
<body>
    <div>
        <h2>$coincidenciasTotales</h2>
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

