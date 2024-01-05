#!/bin/bash
# MIT License Copyright (c) 2024 Hecdin Farias

set -o errexit
set -o nounset
set -o pipefail

LIST_FILE_NAME=()
INDEX_FILE="index.jsx"

# Crear o limpiar el archivo `index.jsx`.
func_initialize_index_file() {
  > "$INDEX_FILE"
}

# Procesar los archivos JSX y generar las importaciones.
func_process_jsx_files() {
  local counter=0

  for file_path in $(find . -type f -name "*.jsx"); do
  local file_name=""
  local import_path=""
    # Extraer el nombre del archivo sin la extensión.
    file_name=$(basename "$file_path" .jsx)
    # Ignorar archivos con el nombre 'index'.
    if [ "$file_name" == "index" ]; then
      continue
    fi
    LIST_FILE_NAME+=("$file_name")
    # Formatear la ruta del archivo para la importación.
    import_path=$(echo "$file_path" | sed 's/^\.\///;s/\.jsx$//')
    # Escribir la línea de importación en el archivo "index.jsx".
    echo "import { ${file_name} } from './${import_path}.jsx';" >> "$INDEX_FILE"

    ((counter+=1))
  done
  echo "Número de componentes importados: ${counter}"
}

# Agregar la exportación al final del archivo de "index.jsx".
func_finalize_index_file() {
  echo " " >> "$INDEX_FILE"
  echo "export {" >> "$INDEX_FILE"

  for elem in "${LIST_FILE_NAME[@]}"; do
    echo " $elem," >> "$INDEX_FILE"
  done
  echo "}" >> "$INDEX_FILE"
}

# Ejecutar el script.
func_main() {
  func_initialize_index_file
  func_process_jsx_files
  func_finalize_index_file

  echo "Listo.!!"
}

func_main

