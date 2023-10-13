#!/bin/bash

# Muestra el menú de opciones
echo "Menú de opciones:"
echo "1) Crear Directorio nuevo"
echo "2) Crear Archivo nuevo"
echo "3) Listar Directorio"
echo "4) Mostrar contenido de archivo"
read -p "Elija una opción (1-4): " opcion

# Realiza la acción correspondiente a la opción seleccionada
case "$opcion" in
    1)
        read -p "Ingrese el nombre del directorio: " directorio
        mkdir "$directorio"
        ;;
    2)
        read -p "Ingrese el nombre del archivo: " archivo
        touch "$archivo"
        ;;
    3)
        ls
        ;;
    4)
        read -p "Ingrese el nombre del archivo: " archivo
        cat "$archivo"
        ;;
    *)
        echo "Opción incorrecta"
        ;;
esac

# Asignar permisos
chmod 770 menu.sh
