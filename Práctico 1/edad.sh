#!/bin/bash

# Solicita al usuario que ingrese su edad
read -p "Ingrese su edad: " edad

if [ $edad -ge 18 ]; then
    echo "Ya eres mayor de edad"
else
    echo "Aun eres menor de edad"
fi

# Asignar permisos
chmod 770 edad.sh
