#!/bin/bash

# Directorio base del sistema
DIRECTORIO_BASE="./Sistema de Relevamiento de Salas"

# Directorio para almacenar información de salas de informática
DIRECTORIO_SALAS="$DIRECTORIO_BASE/Salas"

# Directorio para almacenar registros de acceso
DIRECTORIO_LOG="$DIRECTORIO_BASE/Logs"

# Archivo de contraseñas (usuario:contraseña)
ARCHIVO_CONTRASEÑAS="$DIRECTORIO_BASE/contraseñas.txt"

# Función para crear la estructura del sistema
function crear_estructura_sistema() {
  # Crea el directorio base si no existe
  if [ ! -d "$DIRECTORIO_BASE" ]; then
    mkdir -p "$DIRECTORIO_BASE"
    echo "Directorio base del sistema creado en '$DIRECTORIO_BASE'."
  else
    echo "El directorio base del sistema ya existe."
  fi

  # Crea el directorio de salas de informática si no existe
  if [ ! -d "$DIRECTORIO_SALAS" ]; then
    mkdir -p "$DIRECTORIO_SALAS"
    echo "Directorio de salas de informática creado en '$DIRECTORIO_SALAS'."
  else
    echo "El directorio de salas de informática ya existe."
  fi

  # Crea el directorio de registros de acceso si no existe
  if [ ! -d "$DIRECTORIO_LOG" ]; then
    mkdir -p "$DIRECTORIO_LOG"
    echo "Directorio de registros de acceso creado en '$DIRECTORIO_LOG'."
  else
    echo "El directorio de registros de acceso ya existe."
  fi

  # Crea el archivo de contraseñas si no existe
  if [ ! -e "$ARCHIVO_CONTRASEÑAS" ]; then
    touch "$ARCHIVO_CONTRASEÑAS"
    echo "Archivo de contraseñas creado en '$ARCHIVO_CONTRASEÑAS'."
  else
    echo "El archivo de contraseñas ya existe."
  fi
}

# Llama a la función para crear la estructura del sistema
crear_estructura_sistema

# Resto del código...
