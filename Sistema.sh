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

# Función para verificar si el archivo de contraseñas existe
function verificar_archivo_contrasenas() {
  if [ -f "$ARCHIVO_CONTRASEÑAS" ]; then
    return 0
  else
    return 1
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
    echo "|                                                 |"
    echo "| 1. Agregar Administrador                        |"
    echo "| 2. Eliminar Administrador                       |"
    echo "| 3. Agregar Usuario                              |"
    echo "| 4. Eliminar Usuario                             |"
    echo "| 5. Crear Estructura del Sistema                 |"
    echo "| 6. Crear Informe de Sala de Informática         |"
    echo "| 7. Eliminar Informe                             |"
    echo "| 8. Mostrar Información de Salas de Informática  |"
    echo "| 9. Salir                                        |"
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
        eliminar_informe
        ;;
      8)
        mostrar_informacion_sala
        ;;
      9)
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
    echo "|                                                 |"
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
  # Verificar si el archivo de contraseñas existe
  if ! verificar_archivo_contrasenas; then
    echo "El archivo de contraseñas no existe. Debes crear la estructura del sistema primero."
    return
  fi
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
  # Verificar si el archivo de contraseñas existe
  if ! verificar_archivo_contrasenas; then
    echo "El archivo de contraseñas no existe. Debes crear la estructura del sistema primero."
    return
  fi
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
    echo

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

# Función para crear un informe de la sala de informática
function crear_informe() {
  # Verificar si el archivo de contraseñas existe
  if ! verificar_archivo_contrasenas; then
    echo "El archivo de contraseñas no existe. Debes crear la estructura del sistema primero."
    return
  fi
    touch "$archivo_sala"
    clear
    echo " ________________________________________ "
    echo "|                                        |"
    echo "|  Crear Informe de Sala de Informática  |"
    echo "|________________________________________|"
    echo
    read -p "Ingrese el nombre de la sala: " nombre_sala
    archivo_sala="$DIRECTORIO_SALAS/$nombre_sala.txt"

    # Verificar si la sala ya existe
    if [ -e "$archivo_sala" ]; then
       echo "La sala '$nombre_sala' ya existe."
    else
    
    # Solicitar información de la sala    
    echo " Ingrese los siguientes datos para la sala '$nombre_sala'"
    echo "........................................................."
    read -p "Localidad o nombre de la UTU o Escuela Técnica: " localidad
    read -p "Departamento donde se encuentra la UTU o Escuela Técnica: " departamento
    read -p "Cantidad de Salas de Informática disponibles: " cantidad_salas
  
    # Obtener información del sistema
    numero_identificador=$(hostname)
    nombre_modelo_cpu=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)
    cantidad_procesadores=$(lscpu | grep "Socket(s)" | cut -d':' -f2 | xargs)
    potencia_mhz=$(lscpu | grep "CPU MHz" | cut -d':' -f2 | xargs)
    familia_cpu=$(lscpu | grep "CPU family" | cut -d':' -f2 | xargs)
    cache_cpu=$(lscpu | grep "L3 cache" | cut -d':' -f2 | xargs)

    memoria_total=$(free -m | grep "Mem:" | awk '{print $2}')
    memoria_libre=$(free -m | grep "Mem:" | awk '{print $4}')
    memoria_cache=$(free -m | grep "Mem:" | awk '{print $6}')
    memoria_disponible=$(free -m | grep "Mem:" | awk '{print $7}')

    cantidad_unidades_almacenamiento=$(lsblk -no NAME | wc -l)

    nombre_sistema=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f2)
    nombre_kernel=$(uname -s)
    version_kernel=$(uname -r)
    arquitectura_sistema=$(uname -m)

    # Agregar información al informe
    informe="Informe de Sala de Informática\n\n"
    informe+="Nombre de la sala: $nombre_sala\n"
    informe+="Localidad: $(grep 'Localidad' "$archivo_sala" | cut -d':' -f2 | xargs)\n"
    informe+="Departamento: $(grep 'Departamento' "$archivo_sala" | cut -d':' -f2 | xargs)\n"
    informe+="Cantidad de Salas de Informática disponibles: $(grep 'Cantidad de Salas' "$archivo_sala" | cut -d':' -f2 | xargs)\n"
    informe+="Número identificador de la Computadora: $numero_identificador\n"
    informe+="CPU:\n"
    informe+="  Nombre del modelo de procesador: $nombre_modelo_cpu\n"
    informe+="  Cantidad de procesadores: $cantidad_procesadores\n"
    informe+="  Potencia (Mhz): $potencia_mhz\n"
    informe+="  Familia: $familia_cpu\n"
    informe+="  Cache: $cache_cpu\n"
    informe+="Memoria:\n"
    informe+="  Memoria Total (MB): $memoria_total\n"
    informe+="  Memoria Libre (MB): $memoria_libre\n"
    informe+="  Memoria Cache (MB): $memoria_cache\n"
    informe+="  Memoria Disponible (MB): $memoria_disponible\n"
    informe+="Almacenamiento:\n"
    informe+="  Cantidad de unidades de Almacenamiento: $cantidad_unidades_almacenamiento\n"
    informe+="Sistema Operativo:\n"
    informe+="  Nombre del Sistema Operativo: $nombre_sistema\n"
    informe+="  Nombre del Kernel: $nombre_kernel\n"
    informe+="  Versión del Kernel: $version_kernel\n"
    informe+="  Arquitectura del sistema operativo: $arquitectura_sistema\n"

    # Agregar información adicional de las computadoras aquí

    informe+="\nInforme generado el $(date '+%Y-%m-%d %H:%M:%S') por $usuario_root\n"

    archivo_informe="$DIRECTORIO_LOG/informe_$nombre_sala.txt"
         echo -e "$informe" > "$archivo_informe"
         echo "Informe de la sala '$nombre_sala' creado exitosamente en '$archivo_informe'."
    else
         echo "La sala '$nombre_sala' no existe."
    fi
    pausa
}

# Función para eliminar el informe de sala de informática
function eliminar_informe() {
    clear
    echo " ________________________________ "
    echo "|                                |"
    echo "|  Eliminar Sala de Informática  |"
    echo "|________________________________|"
    echo
    read -p "Ingrese el nombre de la sala a eliminar: " nombre_sala
    archivo_sala="$DIRECTORIO_SALAS/$nombre_sala.txt"

    # Verificar si la sala existe
    if [ -e "$archivo_sala" ]; then
       rm "$archivo_sala"
       echo "Sala de Informática '$nombre_sala' eliminada exitosamente."
    else
       echo "La sala '$nombre_sala' no existe."
    fi
    pausa
}

# Función para mostrar información de una sala de informática
function mostrar_informacion_sala() {
    clear
    echo " _______________________________________________ "
    echo "|                                               |"
    echo "|  Mostrar Información de Salas de Informática  |"
    echo "|_______________________________________________|"
    echo "|                                               |"
    echo "| 1. Por Departamento                           |"
    echo "| 2. Por Nombre o Localidad                     |"
    echo "| 3. Por Número de Sala                         |"
    echo "| 4. Salir                                      |"
    echo "|_______________________________________________|"    
    echo
    read -p "Seleccione su opción: " opcion_mostrar

    case $opcion_mostrar in
        1) 
          clear
          echo " ........................................"
          echo "|  Mostrar Información por Departamento  |"
          echo " ........................................"
          echo
          read -p "Ingrese el Departamento: " departamento
          mostrar_por_departamento "$departamento"
          ;;
        2)
          clear
          echo " .............................................."
          echo "|  Mostrar Información por Nombre o Localidad  |"
          echo " .............................................."
          echo 
          read -p "Ingrese el Nombre o Localidad: " nombre_localidad
          mostrar_por_nombre_localidad "$nombre_localidad"
          ;;
        3)
          clear
          echo " .........................................."
          echo "|  Mostrar Información por Número de Sala  |"
          echo " .........................................."
          echo
          read -p "Ingrese el Número de Sala: " numero_sala
          mostrar_por_numero_sala "$numero_sala"
          ;;
        4)
          return
          ;;
        *)
          echo "Opción no válida. Intente nuevamente."
          ;;
    esac
    pausa
}

# Función para mostrar información de salas por departamento
function mostrar_por_departamento() {
    local departamento="$1"
    clear
    echo "Salas de Informática en el Departamento: $departamento"
    # Buscar y mostrar información de las salas e el departamento
    for archivo_sala in "$DIRECTORIO_SALAS"/*.txt; do
       if grep -q "Departamento: $departamento" "$archivo_sala"; then
          cat "$archivo_sala"
          echo
       fi
     done
}

# Función para mostrar información de salas por nombre o localidad
function mostrar_por_nombre_localidad() {
    local nombre_localidad="$1"
    clear
    echo "Salas de Informática con Nombre o Localidad: $nombre_localidad"
    # Buscar y mostrar información de las salas con el nombre o localidad
    for archivo_sala in "$DIRECTORIO_SALAS"/*.txt; do
        if grep -q "Nombre de la Sala: $nombre_localidad\|Localidad: $nombre_localidad" "$archivo_sala"; then
           cat "$archivo_sala"
           echo
        fi
    done
}

# Función para mostrar información de salas por número de sala
function mostrar_por_numero_sala() {
    local numero_sala="$1"
    archivo_sala="$DIRECTORIO_SALAS/$numero_sala.txt"

    # Verificar si la sala ya existe
    if [ -e "$archivo_sala" ]; then
       cat "$archivo_sala"
    else
       echo "La sala '$numero_sala' no existe."
    fi
}

# Iniciar el Sistema
while true; do
   ingresar_sistema
done
