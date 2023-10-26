# Función para agregar un administrador en el sistema operativo
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

    # Verificar si el administrador ya existe en el sistema
    if id "$usuario_admin" &>/dev/null; then
        echo "El administrador '$usuario_admin' ya existe en el sistema."
        pausa
        return
    fi

    read -s -p "Ingrese la contraseña del administrador: " contrasena_admin
    echo  # Agregar un salto de línea después de ingresar la contraseña

    if [ "$contrasena_admin" = "$(echo "$contrasena_admin" | rev)" ]; then
        echo "La contraseña es un palíndromo."
    fi

    # Crear al administrador en el sistema operativo
    useradd -m -s /bin/bash "$usuario_admin"
    echo "$usuario_admin:$contrasena_admin" | chpasswd
    echo "Administrador '$usuario_admin' agregado exitosamente al sistema."

    # Agregar la cuenta al archivo de contraseñas
    echo "$usuario_admin:$contrasena_admin" >> "$ARCHIVO_CONTRASENAS"
    echo "Cuenta del administrador '$usuario_admin' agregada al archivo de contraseñas."
    pausa
}

# Función para agregar un usuario en el sistema operativo
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

    # Verificar si el usuario ya existe en el sistema
    if id "$usuario" &>/dev/null; then
        echo "El usuario '$usuario' ya existe en el sistema."
        pausa
        return
    fi

    read -s -p "Ingrese la contraseña del usuario: " contrasena
    echo  # Agregar un salto de línea después de ingresar la contraseña

    if [ "$contrasena" = "$(echo "$contrasena" | rev)" ]; then
        echo "La contraseña es un palíndromo."
    fi

    # Crear al usuario en el sistema operativo
    useradd -m -s /bin/bash "$usuario"
    echo "$usuario:$contrasena" | chpasswd
    echo "Usuario '$usuario' agregado exitosamente al sistema."

    # Agregar la cuenta al archivo de contraseñas
    echo "$usuario:$contrasena" >> "$ARCHIVO_CONTRASENAS"
    echo "Cuenta del usuario '$usuario' agregada al archivo de contraseñas."
    pausa
}
