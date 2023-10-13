#!/bin/bash

while true; do
    clear
    echo "Menú de Mantenimiento del Sistema"
    echo "1) Reporte del Sistema"
    echo "2) Reporte de Memoria"
    echo "3) Salir"
    read -p "Seleccione una opción: " opcion

    case $opcion in
        1)
            clear
            echo "Reporte del Sistema"
            echo "a) Nombre de modelo de Procesador"
            echo "b) Cantidad de Procesadores"
            read -p "Seleccione una opción (a/b): " reporte_opcion

            case $reporte_opcion in
                "a")
                    modelo_procesador=$(cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d':' -f2)
                    echo "Nombre del modelo de procesador: $modelo_procesador"
                    ;;
                "b")
                    cantidad_procesadores=$(nproc)
                    echo "Cantidad de procesadores: $cantidad_procesadores"
                    ;;
                *)
                    echo "Opción inválida. Presione Enter para continuar."
                    read
                    ;;
            esac
            ;;
        2)
            clear
            echo "Reporte de Memoria"
            echo "a) Memoria Total"
            echo "b) Memoria Libre"
            read -p "Seleccione una opción (a/b): " reporte_opcion

            case $reporte_opcion in
                "a")
                    memoria_total=$(free -h | grep "Mem:" | awk '{print $2}')
                    echo "Memoria Total: $memoria_total"
                    ;;
                "b")
                    memoria_libre=$(free -h | grep "Mem:" | awk '{print $4}')
                    echo "Memoria Libre: $memoria_libre"
                    ;;
                *)
                    echo "Opción inválida. Presione Enter para continuar."
                    read
                    ;;
            esac
            ;;
        3)
            echo "Saliendo del programa."
            exit 0
            ;;
        *)
            echo "Opción inválida. Presione Enter para continuar."
            read
            ;;
    esac

    read -p "Presione Enter para volver al menú."
done
