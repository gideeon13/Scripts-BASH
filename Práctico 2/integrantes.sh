#!/bin/bash

# Solicita al usuario que ingrese el nombre de los integrantes
read -p "Ingrese el nombre de los integrantes del grupo: " nombres

# Muestra en pantalla los nombres ingresados
echo "Integrantes del grupo: $nombres"

# Asignar permisos
chmod 740 integrantes.sh
