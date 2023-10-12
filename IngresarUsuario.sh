#!/bin/bash

# Función para ingresar al sistema
function ingresar_sistema() {
  clear
  echo "Sistema de Relevamiento de Salas de Informática"
  echo "--------------------------------------------"
  read -p "Ingrese el nombre de usuario: " usuario
  read -s -p "Ingrese la contraseña: " password
  echo

  # Verificar las credenciales de usuario
  if autenticar_usuario "$usuario" "$password"; then
    if [ "$usuario" == "root" ]; then
      menu_root
    else
      menu_usuario "$usuario"
    fi
  else
    echo "Credenciales incorrectas."
  fi
}

# Función para autenticar un usuario
function autenticar_usuario() {
  local usuario="$1"
  local password="$2"

  # Buscar las credenciales del usuario en el archivo de contraseñas
  if grep -q "^$usuario:" "$ARCHIVO_CONTRASEÑAS"; then
    hashed_password=$(grep "^$usuario:" "$ARCHIVO_CONTRASEÑAS" | cut -d: -f2)
    if bcrypt -s "$password" "$hashed_password"; then
      echo "Autenticación exitosa."
      return 0
    fi
  fi
  return 1
}
