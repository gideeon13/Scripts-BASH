#!/bin/bash

nombre_fijo="Cristian"

echo "¡Bienvenido al Calculador Especial!"
echo "-----------------------------------"

echo "Por favor, ingresa tu nombre de usuario:"
read nombre_usuario

echo "Okey, nombre_usuario, ¡vamos a hacer algunos calculos!"

echo "Ingresa el primer numero:"
read num1

echo "Ingresa el segundo numero:"
read num2

suma=$((num1 + num2))
multiplicacion=$((num1 * num2))
resta=$((num1 - num2))
potencia=$((num1 ** num2))

echo -e "Hola soy $nombre_fijo: mira $nombre_usuario, el resultado de lo que estuve calculando..."
echo "El resultado de sumar los numeros es: $suma"
echo "El resultado de multiplicarlos es: $multiplicacion"
echo "El resultado de restar el segundo numero al primero es: $resta"
echo "El resultado de elevar el primero numero a la potencia del segundo es: $potencia"