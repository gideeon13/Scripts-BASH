#!/bin/bash

# Solicita al usuario que ingrese su nombre y contraseña
read -p "Ingrese su nombre: " nombre
read -p "Ingrese su contraseña: " contraseña

if [ "$nombre" == "Admin" ]; then
    if [ "$contraseña" == "1234" ]; then
        echo "Ingreso correcto"
    else
        echo "Contraseña incorrecta"
    fi
else
    echo "Usuario incorrecto"
fi

# Asignar permisos
chmod 755 login.sh
