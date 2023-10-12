#!/bin/bash

# Cambiar el título de la ventana de la terminal

\e]2;Nuevo título\a

# Cambiar el tamaño del texto 

\e[5;0m (tamaño normal)

\e[6;1m (doble altura)

\e[6;2m (doble ancho)

echo -e "\e[5;0mTamaño de texto normal\e[0m"

# Cambiar color del cursor

echo -e "\e]12;3\a" # "3" es el número del color deseado

