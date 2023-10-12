#!/bin/bash

# Menú para el usuario root (administrador)
function menu_root() {
  while true; do
    clear
    echo "-------------------------------"
    echo "| Menú de Administrador (root) |"
    echo "-------------------------------"
    echo "| 1. Agregar Administrador"
    echo "| 2. Eliminar Administrador"
    echo "| 3. Agregar Usuario"
    echo "| 4. Eliminar Usuario"
    echo "| 5. Crear Estructura del Sistema"
    echo "| 6. Crear Informe de Sala de Informática"
    echo "| 7. Mostrar Información de Salas de Informática"
    echo "| 8. Salir"
    echo
    read -p "Seleccione una opción: " opcion_root

    case $opcion_root in
      1)
        agregar_administrador
        ;;
      2)
        eliminar_administrador
        ;;
      3)
        agregar_usuario
        ;;
      4)
        eliminar_usuario
        ;;
      5)
        crear_estructura
        ;;
      6)
        crear_informe
        ;;
      7)
        mostrar_informacion_sala
        ;;
      8)
        exit
        ;;
      *)
        echo "Opción no válida. Intente nuevamente."
        ;;
    esac
    pausa
  done
}

# Menú para usuarios
function menu_usuario() {
  local usuario="$1"
  while true; do
    clear
    echo "Menú de Usuario ($usuario)"
    echo "----------------------------"
    echo "1. Mostrar Información de Salas de Informática"
    echo "2. Salir"
    echo
    read -p "Seleccione una opción: " opcion_usuario

    case $opcion_usuario in
      1)
        mostrar_informacion_sala
        ;;
      2)
        exit
        ;;
      *)
        echo "Opción no válida. Intente nuevamente."
        ;;
    esac
    pausa
  done
}
