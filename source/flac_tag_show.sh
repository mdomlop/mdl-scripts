#!/bin/sh

# Inicializar las variables para almacenar los valores de las opciones
flac_tag=""
flac_file=""

# Analizar las opciones pasadas al script
while getopts ":t:f:" opcion
do
  case $opcion in
    t) flac_tag="$OPTARG" ;;
    f) flac_file="$OPTARG" ;;
    \?) echo "Opción inválida: -$OPTARG" >&2
        exit 1 ;;
    :) echo "La opción -$OPTARG requiere un argumento." >&2
       exit 1 ;;
  esac
done

# Verificar si las opciones fueron proporcionadas
if [ -z "$valor_t" ] || [ -z "$valor_f" ]
then
  echo "Uso: $0 -t flac_tag -f flac_file" >&2
  exit 1
fi

metaflac --show-tag="$flac_tag" "$flac_file"
