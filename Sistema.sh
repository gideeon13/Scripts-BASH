#!/bin/bash

# Establecer el título de la terminal
echo -e "\033]0;Sistema de Relevamiento de Salas de Informática\007"

# Definir códigos de color ANSI
ROJO='\033[1;31m'
AMARILLO='\033[1;33m'
AZUL='\033[1;34m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

usuario_actual=$(whoami)

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
    echo -e "    ${ROJO}  ____________________________________________________________________________________${ROJO}"
    echo -e "    ${ROJO} |____________________________________________________________________________________${ROJO}|"
    echo -e "    ${ROJO} |____________________________________________________________________________________${ROJO}|"
    echo -e "${MAGENTA}     |                                                                                    |"
    echo "     | 888888b.   d8b                                              d8b      888           |"        
    echo "     | 888   88b  Y8P                                              Y8P      888           |"      
    echo "     | 888  .88P                                                            888           |"         
    echo "     | 8888888K.  888  .d88b.  88888b.  888  888  .d88b.  88888b.  888  .d88888  .d88b.   |"
    echo "     | 888   Y88b 888 d8P  Y8b 888  88b 888  888 d8P  Y8b 888  88b 888 d88  888 d88. .88b |"
    echo "     | 888    888 888 88888888 888  888 Y88  88P 88888888 888  888 888 888  888 888   888 |"
    echo "     | 888   d88P 888 Y8b.     888  888  Y8bd8P  Y8b.     888  888 888 Y88b 888 Y88. .88P |"
    echo "     | 8888888P   888   Y8888  888  888   Y88P     Y8888  888  888 888   Y88888   Y888P   |"
    echo -e "${MAGENTA}     |                                                                                    |"
    echo -e "    ${AZUL} |____________________________________________________________________________________${AZUL}|"
    echo -e "    ${AZUL} |____________________________________________________________________________________${AZUL}|"
    echo -e "    ${AZUL} |____________________________________________________________________________________${AZUL}|"
    echo -e "    ${RESET}"
    echo
    echo     "                          ╔════════════════════════════════════════╗"
    echo -e  "                           Usuario del sistema operativo: ${AMARILLO}$usuario_actual${RESET}"
    echo     "                          ╚════════════════════════════════════════╝"
    echo
    echo
    
    read -p "  > Ingrese el nombre de usuario: " usuario
    echo
    read -s -p "  > Ingrese la contraseña: " contrasena

    if su "$usuario" -c "true" -s /bin/bash -p <<EOF
$contrasena
EOF
    then
        echo "Autenticación exitosa como $usuario."
        if [ "$usuario" == "root" ]; then
            menu_root
        elif [ "$usuario" == "admin" ]; then
            menu_administrador "$usuario"
        else
            # Verificar si el usuario tiene permisos de administrador
            if groups "$usuario" | grep -q '\bsudo\b'; then
                menu_administrador "$usuario"
            else
                menu_usuario
            fi
        fi
    else
        clear
        echo "Credenciales incorrectas. Vuelve a intentarlo."
        pausa
        ingresar_sistema  # Reintenta la autenticación si las credenciales son incorrectas
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

    read -s -p "Ingrese la contraseña del administrador: " contrasena_admin
    echo

    if [ "$contrasena_admin" = "$(echo "$contrasena_admin" | rev)" ]; then
        echo "La contraseña es un palíndromo."
        echo
    fi

    # Verificar si el usuario actual es 'root' antes de otorgar permisos de administrador
    if [ "$usuario_actual" == "root" ]; then
        # Intenta crear al administrador en el sistema operativo y maneja los errores
        if useradd -m -s /bin/bash "$usuario_admin"; then
            if echo "$usuario_admin:$contrasena_admin" | chpasswd; then
                # Agregar la cuenta al archivo de contraseñas
                echo "$usuario_admin:$contrasena_admin" >> "$ARCHIVO_CONTRASENAS"
                echo "Administrador '$usuario_admin' agregado exitosamente al sistema."
                echo "Cuenta del administrador '$usuario_admin' agregada al archivo de contraseñas."
                echo

                # Agregar al administrador al grupo 'sudo'
                if usermod -aG sudo "$usuario_admin"; then
                    echo "El administrador '$usuario_admin' tiene permisos de administrador."
                    echo
                else
                    echo "Error al otorgar permisos de administrador al administrador '$usuario_admin'."
                    echo
                fi
            else
                echo "Error al establecer la contraseña del administrador '$usuario_admin'."
                echo
            fi
        else
            echo "Error al agregar el administrador '$usuario_admin'."
            echo
        fi
    else
        echo "Solo el usuario 'root' puede otorgar permisos de administrador."
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
    if id "$usuario" &>/dev/null; then
        echo "El usuario '$usuario' ya existe en el sistema."
        pausa
        return
    fi
    
    read -s -p "Ingrese la contraseña del usuario: " contrasena
    echo

    if [ "$contrasena" = "$(echo "$contrasena" | rev)" ]; then
        echo "La contraseña es un palíndromo."
    fi

    # Intenta crear al usuario en el sistema operativo y maneja los errores
    if useradd -m -s /bin/bash "$usuario"; then
        if echo "$usuario:$contrasena" | chpasswd; then
            # Agregar la cuenta al archivo de contraseñas
            echo "$usuario:$contrasena" >> "$ARCHIVO_CONTRASENAS"
            echo "Usuario '$usuario' agregado exitosamente al sistema."
            echo "Cuenta del usuario '$usuario' agregada al archivo de contraseñas."
            echo
        else
            echo "Error al establecer la contraseña del usuario '$usuario'."
            echo
        fi
    else
        echo "Error al agregar el usuario '$usuario'."
        echo
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

    # Verificar si el usuario existe y eliminarlo, redirigiendo los errores a /dev/null
    if id "$usuario" &>/dev/null; then {
        userdel -r "$usuario" 2>/dev/null
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

    # Verificar si la estructura ya existe
    if [ -d "$DIRECTORIO_SALAS" ] || [ -d "$DIRECTORIO_LOG" ] || [ -f "$ARCHIVO_CONTRASENAS" ]; then
        echo "La estructura del sistema ya existe."
        echo
        echo "¿Deseas borrar toda la información y empezar de nuevo? (Sí/No)"
        read respuesta

        if [ "$respuesta" = "Sí" ] || [ "$respuesta" = "si" ]; then
            # Borrar la información existente
            rm -rf "$DIRECTORIO_SALAS"
            rm -rf "$DIRECTORIO_LOG"
            rm -f "$ARCHIVO_CONTRASENAS"
            echo " --> Información del sistema borrada."
            echo
        else
            echo "-->  Saliendo sin hacer cambios.  <--"
            echo
            return
        fi
    fi

    # Crea el directorio de salas de informática si no existe
    if [ ! -d "$DIRECTORIO_SALAS" ]; then
        mkdir -p "$DIRECTORIO_SALAS"
        echo
        echo "Directorio de Salas de Informática creado en '$DIRECTORIO_SALAS'"
        echo

        # Asignar permisos al directorio de Salas
        chmod 755 "$DIRECTORIO_SALAS"
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
        chmod 755 "$DIRECTORIO_LOG"
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
        chmod 644 "$ARCHIVO_CONTRASENAS"
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
        # Crear el archivo con sudo y establecer permisos
        if sudo touch "$archivo_sala" && sudo chmod 600 "$archivo_sala"; then
            
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
        else
            echo "Error al crear el archivo de la sala."
        fi
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
       if sudo grep -q "Departamento: $departamento" "$archivo_sala"; then
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
