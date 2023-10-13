#!/bin/bash

# Solicita al usuario que ingrese dos números
read -p "Ingrese el primer número: " num1
read -p "Ingrese el segundo número: " num2

# Realiza las operaciones
sum=$((num1 + num2))
product=$((num1 * num2))

# Muestra los resultados
echo "La suma de $num1 y $num2 es: $sum"
echo "El producto de $num1 y $num2 es: $product"

# Asignar permisos
chmod 755 calcular.sh
