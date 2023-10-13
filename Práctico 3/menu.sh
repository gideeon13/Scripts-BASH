#!/bin/bash

opcion=0

while [ $opcion -ne 5 ]; do
    # Muestra el menú de opciones
    echo "Menú de opciones:"
    echo "1) Crear 40 Directorios nuevos"
    echo "2) Crear 40 Archivos nuevos"
    echo "3) Eliminar todos los directorios"
    echo "4) Eliminar todos los archivos"
    echo "5) Salir"
    read -p "Elija una opción (1-5): " opcion

    case $opcion in
        1)
            for i in $(seq 1 40); do
                mkdir "dir$i"
            done
            echo "Se crearon 40 directorios."
            ;;
        2)
            for i in $(seq 1 40); do
                touch "arch$i.txt"
            done
            echo "Se crearon 40 archivos."
            ;;
        3)
            rm -r dir*
            echo "Se eliminaron todos los directorios."
            ;;
        4)
            rm -f arch*.txt
            echo "Se eliminaron todos los archivos."
            ;;
        5)
            echo "Saliendo del programa."
            ;;
        *)
            echo "Opción incorrecta"
            ;;
    esac
done

# Asignar permisos
chmod 770 menu.sh
