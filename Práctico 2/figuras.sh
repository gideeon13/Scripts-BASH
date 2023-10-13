#!/bin/bash

# Muestra el menú de opciones de figuras geométricas
echo "Menú de figuras geométricas:"
echo "1) Segmento de recta"
echo "2) Cuadrado"
echo "3) Rectángulo"
echo "4) Triángulo rectángulo"
read -p "Elija una opción (1-4): " opcion

# Muestra la figura seleccionada
case "$opcion" in
    1)
        echo "Segmento de recta: *********"
        ;;
    2)
        echo "Cuadrado:"
        echo "*********"
        echo "*********"
        echo "*********"
        echo "*********"

        ;;
    3)
        echo "Rectángulo:"
        echo "*************"
        echo "*************"
        echo "*************"
        ;;
    4)
        echo "Triángulo rectángulo:"
        echo "*"
        echo "**"
        echo "***"
        echo "****"
        echo "*****"
        ;;
    *)
        echo "Opción incorrecta"
        ;;
esac

# Asignar permisos
chmod 770 figuras.sh
