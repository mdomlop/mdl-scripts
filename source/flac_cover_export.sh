#!/bin/sh

##### flac_cover_export
# Export cover from a flac file.
#
# Version 1 (2024-03-??)
# - Requires: metaflac

# Inicializar las variables para almacenar los valores de las opciones
valor_t=""
valor_f=""

# Analizar las opciones pasadas al script
while getopts ":t:f:" opcion
do
  case $opcion in
    t) valor_t="$OPTARG" ;;
    f) valor_f="$OPTARG" ;;
    \?) echo "Opción inválida: -$OPTARG" >&2
        exit 1 ;;
    :) echo "La opción -$OPTARG requiere un argumento." >&2
       exit 1 ;;
  esac
done

# Verificar si las opciones fueron proporcionadas
if [ -z "$valor_t" ] || [ -z "$valor_f" ]
then
  echo "Uso: $0 -t valor_t -f valor_f" >&2
  exit 1
fi

metaflac --export-picture-to="$valor_t" "$valor_f"
