#!/bin/bash

\e]2;Sistema de Relevamiento de Salas de Informática\a

# Función para Ingresar al Sistema

function ingresar_sistema() {
  clear
  echo " __________________________________________________"
  echo "|                   Bienvenido al                  |"
  echo "| Sistema de Relevamiento de Salas de Informática  |"
  echo "|__________________________________________________|"
  read -p "Ingrese el nombre de usuario: " usuario
  read -s -p "Ingrese la contraseña: " password
  echo
}

  # Verificar las credenciales de Usuario
   if autenticar_usuario "$usuario" "$password"; then
     if [ "$usuario" == "root" ]; then
       menu_root
     else 
       menu_usuario "$usuario"
     fi
    else
      echo "Credenciales incorrectas."
    fi

# Función para autenticar un usuario
function autenticar_usuario() {
  local usuario="$1"
  local password="$2"

  # Buscar las credenciales del usuario en el archivo de contraseñas
  if grep -q "^$usuario:" "$ARCHIVO_CONTRASEÑAS"; then
    hashed_password=$(grep "^$usuario:" "$ARCHIVO_CONTRASEÑAS" | cut -d: -f2)
    if bcrypt -s "$password" "$hashed_password"; then
      echo "Autenticacion exitosa."
      return 0
    fi
  fi
  return 1
}

# Menú para el usuario root (Administrador)
function menu_root() {
  while true; do
    clear
    echo " _________________________________________________"
    echo "|                                                 |"
    echo "|            Menú de Administrador (root)         |"
    echo "|_________________________________________________|"
    echo "| 1. Agregar Administrador                        |"
    echo "| 2. Eliminar Administrador                       |"
    echo "| 3. Agregar Usuario                              |"
    echo "| 4. Eliminar Usuario                             |"
    echo "| 5. Crear Estructura del Sistema                 |"
    echo "| 6. Crear Informe de Sala de Informática         |"
    echo "| 7. Mostrar Información de Salas de Informática  |"
    echo "| 8. Salir                                        |"
    echo "|_________________________________________________|"
    echo
    read -p "Seleccione una opcion: " opcion_root

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
    echo " _________________________________________________"
    echo "|                                                 |"
    echo "|            Menú de Usuario ($usuario)           |"
    echo "|_________________________________________________|"
    echo "| 1. Mostrar Información de Salas de Informática  |"
    echo "| 2. Salir                                        |"
    echo "|_________________________________________________|"
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
