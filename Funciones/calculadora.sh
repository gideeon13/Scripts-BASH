#!/bin/bash

# Definir las funciones para cada operación
function suma() {
  resultado=$(($1 + $2))
  echo "La suma de $1 y $2 es: $resultado"
}

function multiplicacion() {
  resultado=$(($1 * $2))
  echo "El producto de $1 y $2 es: $resultado"
}

function division() {
  if [ $2 -eq 0 ]; then
    echo "No se puede dividir por cero."
  else
    resultado=$(echo "scale=2; $1 / $2" | bc)
    echo "La división de $1 entre $2 es: $resultado"
  fi
}

function potencia() {
  resultado=$(echo "$1^$2" | bc)
  echo "$1 elevado a la $2 es: $resultado"
}

# Menú principal
while true; do
  echo "Operaciones disponibles:"
  echo "a. Sumar"
  echo "b. Multiplicar"
  echo "c. Dividir"
  echo "d. Potencia"
  echo "e. Salir"
  read -p "Elija una opción: " opcion

  case $opcion in
    a)
      read -p "Ingrese el primer número: " num1
      read -p "Ingrese el segundo número: " num2
      suma $num1 $num2
      ;;
    b)
      read -p "Ingrese el primer número: " num1
      read -p "Ingrese el segundo número: " num2
      multiplicacion $num1 $num2
      ;;
    c)
      read -p "Ingrese el dividendo: " num1
      read -p "Ingrese el divisor: " num2
      division $num1 $num2
      ;;
    d)
      read -p "Ingrese la base: " num1
      read -p "Ingrese el exponente: " num2
      potencia $num1 $num2
      ;;
    e)
      echo "Saliendo del programa."
      exit 0
      ;;
    *)
      echo "Opción incorrecta. Por favor, elija una opción válida."
      ;;
  esac
done
