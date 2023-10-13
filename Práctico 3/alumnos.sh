#!/bin/bash

opcion=0

while [ $opcion -ne 4 ]; do
    # Muestra el menú de opciones
    echo "Menú de opciones:"
    echo "1) Agregar Alumno"
    echo "2) Mostrar Todos los Alumnos"
    echo "3) Borrar Registro de Alumnos"
    echo "4) Salir"
    read -p "Elija una opción (1-4): " opcion

    case $opcion in
        1)
            read -p "Ingrese el Nombre del alumno: " nombre
            read -p "Ingrese el Apellido del alumno: " apellido
            read -p "Ingrese la Fecha de nacimiento del alumno: " fecha
            echo "$nombre, $apellido, $fecha" >> registro.txt
            ;;
        2)
            cat registro.txt
            ;;
        3)
            > registro.txt
            echo "Se ha borrado el registro de alumnos."
            ;;
        4)
            echo "Saliendo del programa."
            ;;
        *)
            echo "Opción incorrecta"
            ;;
    esac
done

# Asignar permisos
chmod 711 alumnos.sh
chmod 600 registro.txt
