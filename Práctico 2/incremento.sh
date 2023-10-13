#!/bin/bash

# Solicita al usuario que ingrese un número
read -p "Ingrese un número: " numero

# Realiza las operaciones
if [ "$numero" -gt 0 ]; then
    resultado=$((numero + 10))
elif [ "$numero" -lt 0 ]; then
    resultado=$((numero - 10))
else
    resultado="$numero"
fi

# Muestra el resultado
echo "El resultado es: $resultado"

# Asignar permisos
chmod 755 incremento.sh
