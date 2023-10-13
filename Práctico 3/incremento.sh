#!/bin/bash

# Solicita al usuario que ingrese un número
read -p "Ingrese un número: " numero

if [ "$numero" -gt 0 ]; then
    for i in $(seq $numero 100); do
        echo $i
    done
elif [ "$numero" -lt 0 ]; then
    for i in $(seq $numero -1 -100); do
        echo $i
    done
else
    echo "Número igual a cero, no se muestran números."
fi

# Asignar permisos
chmod 755 incremento.sh
