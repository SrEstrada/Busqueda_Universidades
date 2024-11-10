#!/usr/bin/perl
use strict;
use warnings;
use CGI ':standard';
use utf8;

# Creación del objeto CGI
my $q = CGI->new;

# Subrutina principal que maneja la lógica de búsqueda
sub realizarBusqueda {
    # Captura de parámetros del formulario
    my $nombre = $q->param('nombre') || '';
    my $periodo = $q->param('periodo') || '';
    my $departamento = $q->param('departamento') || '';
    my $tipo_gestion = $q->param('tipo_gestion') || '';

    # Mensaje de error si no hay criterios
    unless ($nombre || $periodo || $departamento || $tipo_gestion) {
        return "<p>Error: Debe ingresar al menos un criterio de búsqueda.</p>";
    }

    # Abrir el archivo CSV
    open my $fh, '<:encoding(UTF-8)', 'Data_Universidades_Lab06.csv' or die "No se puede abrir el archivo: $!";

    my @resultados;
    while (my $line = <$fh>) {
        chomp $line;
        
        # Separar los campos del CSV
        my @campos = split /,/, $line;

        # Asumimos que los campos son en este orden:
        # [0] -> Código, [1] -> Nombre, [2] -> Tipo Gestión, [3] -> Estado Licenciamiento
        # [4] -> Fecha Inicio, [5] -> Fecha Fin, [6] -> Periodo Licenciamiento, [7] -> Departamento, etc.

        # Aplicar filtros según criterios de búsqueda
        my $coincidencia = 1;
        
        $coincidencia &&= ($campos[1] =~ /\Q$nombre\E/i) if $nombre;
        $coincidencia &&= ($campos[6] =~ /\Q$periodo\E/i) if $periodo;
        $coincidencia &&= ($campos[7] =~ /\Q$departamento\E/i) if $departamento;
        $coincidencia &&= ($campos[2] =~ /\Q$tipo_gestion\E/i) if $tipo_gestion;

        # Si cumple todos los criterios, agregar a los resultados
        push @resultados, $line if $coincidencia;
    }

    close $fh;

    # Generar HTML con resultados
    if (@resultados) {
        my $html = "<h3>Resultados de la búsqueda:</h3><ul>";
        $html .= "<li>$_</li>" for @resultados;
        $html .= "</ul>";
        return $html;
    } else {
        return "<p>No se encontraron resultados para los criterios especificados.</p>";
    }
}

# Subrutina que genera el HTML completo de respuesta
sub generarHTML {
    my $contenido = shift;

    print $q->header('text/html; charset=UTF-8');
    print <<"HTML";
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultado de Búsqueda</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="resultados">
        $contenido
    </div>
</body>
</html>
HTML
}

# Llamar a la subrutina principal y pasar el contenido a generarHTML
generarHTML(realizarBusqueda());
