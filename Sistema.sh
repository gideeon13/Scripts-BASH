#!/bin/bash

# Directorio base del Sistema
DIRECTORIO_BASE="~/Sistema de Relevamiento de Salas"

# Directorio para almacenar información de salas de informática
DIRECTORIO_SALAS="$DIRECTORIO_BASE/Salas"

# Directorio para almacenar registros de acceso
DIRECTORIO_LOG="$DIRECTORIO_BASE/Logs"

# Archivo de contraseñas (usuario:contraseña)
ARCHIVO_CONTRASEÑAS="$DIRECTORIO_BASE/Contraseñas.txt"

\e]2;Sistema de Relevamiento de Salas de Informática\a

# Crear directorio principal al iniciar el programa
function crear_estructura_inicial () {
    if [ ! -d "$DIRECTORIO_BASE" ]; then
       mkdir -p "$DIRECTORIO_BASE"
    fi
}

# Función para Ingresar al Sistema
function ingresar_sistema() {
  # Llama a la función para crear la estructura inicial del Sistema
  crear_estructura_inicial

  clear
  echo " __________________________________________________"
  echo "|                   Bienvenido al                  |"
  echo "| Sistema de Relevamiento de Salas de Informática  |"
  echo "|__________________________________________________|"
  echo
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

# Función para pausar la ejecución y esperar una tecla
function pausa() {
    read -n 1 -s -r -p "Presione cualquier tecla para continuar..."
    echo
}

# Función para agregar un Administrador
function agregar_administrador() {
    clear
    echo " _________________________ "
    echo "|                         |"    
    echo "|  Agregar Administrador  |"
    echo "|_________________________|"
    echo
    read -p "Ingrese el nombre de usuario del administrador: " usuario_admin
    if [ -z "$usuario_admin" ]; then
      echo "El nombre de usuario no puede estar vacío."
      pausa
      return
    fi

    # Verificar si el administrador ya existe
    if grep -q "^$usuario_admin:" "$ARCHIVO_CONTRASEÑAS"; then
       echo "El administrador '$usuario_admin' ya existe."
    else

    # Solicitar y almacenar la contraseña de forma segura
    read -s -p "Ingrese la contraseña del administrador: " contraseña_admin
    if [ -z "$contraseña_admin" ]; then
       echo "La contraseña no puede estar vacía."
       pausa
       return
    fi

    # Hashear la contraseña y almacenarla en el archivo de contraseñas
    contraseña_hasheada=$(bcrypt "$contraseña_admin")
    echo "$usuario_admin:$contraseña_hasheada" >> "$ARCHIVO_CONTRASEÑAS"
    echo "Administrador '$usuario_admin' agregado exitosamente."
    fi
    pausa
}

# Función para eliminar un administrador
function eliminar_administrador() {
    clear
    echo " ___________________________"
    echo "|                           |"    
    echo "|   Eliminar Administrador  |"
    echo "|___________________________|"
    echo
    read -p "Ingrese el nombre de usuario del administrador a eliminar: " usuario_admin

    # Verificar si el administrador existe
    if grep -q "^$usuario_admin:" "$ARCHIVO_CONTRASEÑAS"; then
       # Eliminar al administrador del archivo de contraseñas
       sed -i "/^$usuario_admin:/d" "$ARCHIVO_CONTRASEÑAS"
       echo "Administrador '$usuario_admin' eliminado exitosamente."
    else
       echo "El administrador '$usuario_admin' no existe."
    fi
    pausa
}

# Función para agregar un usuario 
function agregar_usuario() {
    clear
    echo " ___________________ "
    echo "|                   |"    
    echo "|  Agregar Usuario  |"
    echo "|___________________|"
    echo
    read -p "Ingrese el nombre de usuario: " usuario
    if [ -z "$usuario" ]; then
       echo "El nombre de usuario no puede estar vacío."
       pausa
       return
    fi

    # Verificar si el usuario ya existe
    if grep -q "^$usuario:" "$ARCHIVO_CONTRASEÑAS"; then
       echo "El usuario '$usuario' ya existe."
    else

    # Solicitar y almacenar la contraseña de forma segura
    read -s -p "Ingrese la contraseña: " contraseña
    if [ -z "$contraseña" ]; then
       echo "La contraseña no puede estar vacía."
       pausa
       return
    fi

    # Hashear la contraseña y almacenarla en el archivo de contraseñas
    contraseña_hasheada=$(bycrpt "$contraseña")
    echo "$usuario:$contraseña_hasheada" >> "$ARCHIVO_CONTRASEÑAS"
    echo "Usuario '$usuario' agregado exitosamente."
    fi
    pausa
}

function eliminar_usuario() {
    clear
    echo " ____________________ "
    echo "|                    |"    
    echo "|  Eliminar Usuario  |"
    echo "|____________________|"
    echo
    read -p "Ingrese el nombre de usuario a eliminar: " usuario

    # Verificar si el usuario existe
    if grep -q "^$usuario:" "$ARCHIVO_CONTRASEÑAS"; then

         # Eliminar al usuario del archivo de contraseñas
         sed -i "/^$usuario:/d" "$ARCHIVO_CONTRASEÑAS"
         echo "Usuario '$usuario' eliminado exitosamente."
    else 
         echo "El usuario '$usuario' no existe."
    fi
    pausa
}

# Función para crear la estructura del Sistema
function crear_estructura() {
    clear
    echo "-..................................- "
    echo "|  Creando Estructura del Sistema  |"
    echo "|..................................|"

    # Crea el directorio de salas de informática si no existe
    if [ ! -d "$DIRECTORIO_SALAS" ]; then
       mkdir -p "$DIRECTORIO_SALAS"
       echo "Directorio de Salas de Informática creado en '$DIRECTORIO_SALAS'"
    else
       echo "El directorio de salas de informática ya existe."
    fi
    # Crea el directorio de registros de acceso si no existe
    if [ ! -d "$DIRECTORIO_LOG" ]; then
       mkdir -p "$DIRECTORIO_LOG"
       echo "Directorio de registros de acceso creado en '$DIRECTORIO_LOG'"
    else
       echo "El directorio de registros de acceso ya existe."
    fi
    # Crear el archivo de contraseñas si no existe
    if [ ! -f "$ARCHIVO_CONTRASEÑAS" ]; then
       touch "$ARCHIVO_CONTRASEÑAS"
       echo "Archivo de Contraseñas creado en '$ARCHIVO_CONTRASEÑAS'"
    else
       "El archivo de contraseñas ya existe."
    fi
    pausa
}





# Iniciar el Sistema
while true; do
   ingresar_sistema
done
