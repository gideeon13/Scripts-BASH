#!/bin/bash

# Establecer el título de la terminal
echo -e "\033]0;Sistema de Relevamiento de Salas de Informática\007"

# Definir códigos de color ANSI
ROJO='\033[0;31m'
AMARILLO='\033[0;33m'
AZUL='\033[0;34m'
RESET='\033[0m'

# Directorio base del Sistema
DIRECTORIO_BASE="Sistema de Relevamiento de Salas"

# Directorio para almacenar información de salas de informática
DIRECTORIO_SALAS="$DIRECTORIO_BASE/Salas"

# Directorio para almacenar registros de acceso
DIRECTORIO_LOG="$DIRECTORIO_BASE/Logs"

# Crear Archivo para Contraseñas
ARCHIVO_CONTRASENAS="$DIRECTORIO_LOG/cuentas_sistema.txt"

# Establecer permisos en el archivo Sistema.sh
chmod 744 "$0"

imprimir_titulo() {
    echo -e "${AMARILLO} __________________________________________________${AZUL}"
    echo -e "|${AMARILLO}                                                  ${AZUL}|"
    echo -e "|${AMARILLO}                   Bienvenido al                  ${AZUL}|"
    echo -e "|${AMARILLO} Sistema de Relevamiento de Salas de Informática  ${AZUL}|"
    echo -e "|${AMARILLO}__________________________________________________${AZUL}|"
    echo -e "${RESET}"
}

# Crear directorio principal al iniciar el programa
function crear_estructura_inicial () {
    if [ ! -d "$DIRECTORIO_BASE" ]; then
       mkdir -p "$DIRECTORIO_BASE"
    fi
}

function ingresar_sistema() {
    # Llama a la función para crear la estructura inicial del Sistema
    crear_estructura_inicial
    
    clear
    imprimir_titulo
    echo

    usuario=$(whoami)

    if [ "$usuario" == "root" ] || [ "$usuario" == "admin" ]; then
        read -p "Ingrese su nombre de usuario: " usuario_ingresado
        read -s -p "Ingrese su contraseña: " contrasena_ingresada
        echo  # Agrega un salto de línea después de la contraseña

        if verificar_credenciales "$usuario_ingresado" "$contrasena_ingresada"; then
            if [ "$usuario_ingresado" == "root" ]; then
                menu_root
            elif [ "$usuario_ingresado" == "admin" ]; then
                menu_administrador "$usuario_ingresado"
            fi
        else
            echo "Credenciales incorrectas. Vuelve a intentarlo."
        fi
    else
        echo "El usuario actual no tiene acceso a esta funcionalidad."
    fi
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
    echo "| 6. Salir                                        |"
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
        exit
        ;;
      *)
        echo "Opción no válida. Intente nuevamente."
        ;;
    esac
    pausa
 done
}

# Menú para administradores del sistema operativo (no root)
function menu_administrador() {
    local usuario_admin="$1"
    while true; do
        clear
        echo " _________________________________________________"
        echo "|                                                 |"
        echo "|               Menú de Administrador             |"
        echo "|_________________________________________________|"
        echo "|                                                 |"
        echo "| 1. Crear Informe de Sala de Informática         |"
        echo "| 2. Eliminar Informe                             |"
        echo "| 3. Mostrar Información de Salas de Informática  |"
        echo "| 4. Salir                                        |"
        echo "|_________________________________________________|"
        echo
        read -p "Seleccione una opcion: " opcion_admin
        
        case $opcion_admin in
            1)
                crear_informe
                ;;
            2)
                eliminar_informe
                ;;
            3)
                mostrar_informacion_sala
                ;;
            4)
                exit
                ;;
            *)
                echo "Opción no válida. Intente nuevamente."
                ;;
        esac
        pausa
    done
}

# Menú para usuarios regulares
function menu_usuario() {
    while true; do
        clear
        echo " _________________________________________________"
        echo "|                                                 |"
        echo "|                 Menú de Usuario                 |"
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
    echo
    read -n 1 -s -r -p "Presione cualquier tecla para continuar..."
    echo
}

# Función para agregar un administrador en el sistema operativo
function agregar_administrador() {
# Verificar si el archivo de contraseñas existe
if [ ! -f "$ARCHIVO_CONTRASENAS" ]; then
    clear
    imprimir_titulo
    echo "El archivo de contraseñas no está creado. Debes crearlo primero."
    pausa
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

    # Verificar si el administrador ya existe en el sistema
    id "$usuario_admin" && {
        echo "El administrador '$usuario_admin' ya existe en el sistema."
        pausa
        return
    }

    read -s -p "Ingrese la contraseña del administrador: " contrasena_admin
    echo  

    if [ "$contrasena_admin" = "$(echo "$contrasena_admin" | rev)" ]; then
        echo "La contraseña es un palíndromo." 
        echo
    fi

    # Crear al administrador en el sistema operativo
    if useradd -m -s /bin/bash "$usuario_admin"; then
        echo "$usuario_admin:$contrasena_admin" | chpasswd
        echo
        echo "Administrador '$usuario_admin' agregado exitosamente al sistema."
        echo

        # Agregar la cuenta al archivo de contraseñas
        echo "$usuario_admin:$contrasena_admin" >> "$ARCHIVO_CONTRASENAS"
        echo "Cuenta del administrador '$usuario_admin' agregada al archivo de contraseñas."
        echo

        # Agregar al administrador al grupo "sudo"
        if usermod -aG sudo "$usuario_admin"; then
            echo "El administrador '$usuario_admin' tiene permisos de administrador."
            echo
        else
            echo "Error al otorgar permisos de administrador al administrador '$usuario_admin'."
            echo
        fi
    else
        echo "Error al agregar el administrador '$usuario_admin'."
        echo
    fi

    pausa
}


# Función para eliminar un administrador en el sistema operativo
function eliminar_administrador() {
# Verificar si el archivo de contraseñas existe
if [ ! -f "$ARCHIVO_CONTRASENAS" ]; then
    clear
    imprimir_titulo
    echo "El archivo de contraseñas no está creado. Debes crearlo primero."
    pausa
    return
fi
    clear
    echo " ___________________________"
    echo "|                           |"    
    echo "|   Eliminar Administrador  |"
    echo "|___________________________|"
    echo
    read -p "Ingrese el nombre de usuario del administrador a eliminar: " usuario_admin

    # Verificar si el administrador existe
    if id "$usuario_admin" &>/dev/null; then {
        # Eliminar al administrador del sistema operativo
        userdel -r "$usuario_admin"
        echo "Administrador '$usuario_admin' eliminado del sistema operativo."
        
        # Eliminar la cuenta del archivo de contraseñas
        sed -i "/^$usuario_admin:/d" "$ARCHIVO_CONTRASENAS"
        echo "Cuenta del administrador '$usuario_admin' eliminada del archivo de contraseñas."
    }
    else
        echo "El administrador '$usuario_admin' no existe en el sistema."
    fi
    pausa
}

# Función para agregar un usuario en el sistema operativo
function agregar_usuario() {
# Verificar si el archivo de contraseñas existe
if [ ! -f "$ARCHIVO_CONTRASENAS" ]; then
    clear
    imprimir_titulo
    echo "El archivo de contraseñas no está creado. Debes crearlo primero."
    pausa
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

    # Verificar si el usuario ya existe en el sistema
   id "$usuario" && {
        echo "El usuario '$usuario' ya existe en el sistema."
        pausa
        return
    }

    read -s -p "Ingrese la contraseña del usuario: " contrasena
    echo  # Agregar un salto de línea después de ingresar la contraseña

    if [ "$contrasena" = "$(echo "$contrasena" | rev)" ]; then
        echo "La contraseña es un palíndromo."
    fi

    # Crear al usuario en el sistema operativo
    if useradd -m -s /bin/bash "$usuario"; then
        echo "$usuario:$contrasena" | chpasswd
        echo
        echo "Usuario '$usuario' agregado exitosamente al sistema."
        echo

        # Agregar la cuenta al archivo de contraseñas
        echo "$usuario:$contrasena" >> "$ARCHIVO_CONTRASENAS"
        echo "Cuenta del usuario '$usuario' agregada al archivo de contraseñas."
        echo
    else
        echo "Error al agregar el usuario '$usuario'."
    fi

    pausa
}


# Función para eliminar un usuario en el sistema operativo
function eliminar_usuario() {
# Verificar si el archivo de contraseñas existe
if [ ! -f "$ARCHIVO_CONTRASENAS" ]; then
    clear
    imprimir_titulo
    echo "El archivo de contraseñas no está creado. Debes crearlo primero."
    pausa
    return
fi
    clear
    echo " ____________________ "
    echo "|                    |"    
    echo "|  Eliminar Usuario  |"
    echo "|____________________|"
    echo
    read -p "Ingrese el nombre de usuario a eliminar: " usuario

    # Verificar si el usuario existe
    if id "$usuario" &>/dev/null; then {
        # Eliminar al usuario del sistema operativo
        userdel -r "$usuario"
        echo "Usuario '$usuario' eliminado del sistema operativo."
        
        # Eliminar la cuenta del archivo de contraseñas
        sed -i "/^$usuario:/d" "$ARCHIVO_CONTRASENAS"
        echo "Cuenta del usuario '$usuario' eliminada del archivo de contraseñas."
    }
    else
        echo "El usuario '$usuario' no existe en el sistema."
    fi
    pausa
}

# Función para crear la estructura del Sistema
function crear_estructura() {
    clear
    echo
    echo "...................................."
    echo "|..................................|"
    echo "|  Creando Estructura del Sistema  |"
    echo "|..................................|"
    echo "...................................."
    echo

    # Crea el directorio de salas de informática si no existe
    if [ ! -d "$DIRECTORIO_SALAS" ]; then
        mkdir -p "$DIRECTORIO_SALAS"
        echo
        echo "Directorio de Salas de Informática creado en '$DIRECTORIO_SALAS'"
        echo

        # Asignar permisos al directorio de Salas
        chmod 700 "$DIRECTORIO_SALAS"
    else
        echo
        echo "El directorio de salas de informática ya existe."
        echo
    fi

    # Crea el directorio de registros de acceso si no existe
    if [ ! -d "$DIRECTORIO_LOG" ]; then
        mkdir -p "$DIRECTORIO_LOG"
        echo
        echo "Directorio de registros de acceso creado en '$DIRECTORIO_LOG'"
        echo

        # Asignar permisos al directorio de Logs
        chmod 700 "$DIRECTORIO_LOG"
    else
        echo
        echo "El directorio de registros de acceso ya existe."
        echo
    fi

    # Crear el archivo de contraseñas si no existe
    if [ ! -f "$ARCHIVO_CONTRASENAS" ]; then
        touch "$ARCHIVO_CONTRASENAS"
        echo
        echo "Archivo de Contraseñas creado en '$ARCHIVO_CONTRASENAS'"
        echo

        # Asignar permisos al archivo de contraseñas
        chmod 600 "$ARCHIVO_CONTRASENAS"
    else
        echo
        echo "El archivo de contraseñas ya existe."
        echo
    fi

    pausa
    return
}


# Función para crear un informe de la sala de informática
function crear_informe() {
    clear
    echo " ________________________________________ "
    echo "|                                        |"
    echo "|  Crear Informe de Sala de Informática  |"
    echo "|________________________________________|"
    echo
    read -p "Ingrese el nombre de la sala: " nombre_sala
    archivo_sala="$DIRECTORIO_SALAS/$nombre_sala.txt"
    
    # Verificar si el archivo de la sala ya existe
    if [ -e "$archivo_sala" ]; then
       echo "La sala '$nombre_sala' ya existe."
    else
    
    #Crear el archivo de la sala si no existe
    touch "$archivo_sala"
    
    # Agregar permisos al archivo
    chmod 600 "$archivo_sala"
    
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
         
         # Obtener la fecha y hora del sistema
         fecha_actual=$(date '+%Y-%m-%d %H:%M:%S')

         # Agregar información al informe
         cat <<EOF >> "$archivo_sala"

Informe de Sala de Informàtica

        
Nombre de la Sala: $nombre_sala
Localidad: $localidad
Departamento: $departamento
Cantidad de Salas: $cantidad_salas

Informaciòn del Sistema:
Nùmero Identificador: $numero_identificador

CPU:
  Nombre del modelo de procesador: $nombre_modelo_cpu
  Cantidad de procesadores: $cantidad_procesadores
Memoria
  Memoria Total (MB): $memoria_total
  Memoria Libre (MB): $memoria_libre
  Memoria Cache (MB): $memoria_cache
  Memoria Disponible (MB): $memoria_disponible
Almacenamiento:
  Cantidad de unidades de Almacenamiento: $cantidad_unidades_almacenamiento
Sistema Operativo:
  Nombre del Sistema Operativo: $nombre_sistema
  Nombre del Kernel: $nombre_kernel
  Versiòn del Kernel: $version_kernel
  Arquitectura del sistema operativo: $arquitectura_sistema
  
Fecha y Hora de creaciòn: $fecha_actual
Creado por: $usuario
EOF

         echo "Informe de la sala '$nombre_sala' creado exitosamente en '$archivo_sala'."
         echo
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
          echo ".........................................."
          echo "|  Mostrar Información por Departamento  |"
          echo ".........................................."
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
    echo
    echo "Salas de Informática en el Departamento: $departamento"
    echo
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
    echo
    echo "Salas de Informática con Nombre o Localidad: $nombre_localidad"
    echo
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
