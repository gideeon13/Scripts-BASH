#!/bin/bash

# Solicita al usuario que ingrese una fecha de nacimiento
read -p "Ingrese una fecha de nacimiento (YYYY-MM-DD): " fecha

# Comprueba si la fecha es válida
if date -d "$fecha" &>/dev/null; then
    echo "Fecha ingresada correctamente"
else
    echo "Fecha no válida"
fi

# Asignar permisos
chmod 711 fecha.sh
