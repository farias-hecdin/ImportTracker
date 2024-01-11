#!/bin/bash
### MIT License Copyright (c) 2024 Hecdin Farias.

set -o errexit
set -o nounset
set -o pipefail

### Busca todos los archivos .jsx en el directorio actual y sus subdirectorios
FIND=$(fd --full-path "${1:-'.'}" -e "jsx")

### Colores
gray="\e[2m"
bold="\e[1m"
end="\e[0m"

### Variables globales
INDEX_FILE="index.jsx"
FILE_PATH=""
FILE_NAME=""
VARS_NAME=()

### Crear o limpiar el archivo "index.jsx"
func_initialize_index_file() {
  > "$INDEX_FILE"
}

### Procesar los archivos JSX y generar las importaciones
func_process_jsx_files() {
  local counter=0

  for file in $FIND; do
    # Formatear la ruta del archivo
    FILE_PATH=$(echo "$file" | sed 's/^\.\///;s/\.jsx$//')
    # Extraer el nombre del archivo sin la extensión
    FILE_NAME=$(basename "$file" .jsx)
    # Ignorar archivos con el nombre 'index.jsx'
    if [ "$FILE_NAME" == "index" ]; then
      continue
    fi
    # Almacenar los datos en una variable
    local find_export_vars=($(rg --color=never 'export\s+const\s+\w+' "$file" | awk '{print $3}' | sed 's/;//g' | sed 's/,//g' | sed 's/}/\n/g'))
    # Ignorar los datos vacios
    if [ "${find_export_vars[*]}" == "" ]; then
      continue
    fi
    # Añadir los datos a "index.jsx"
    if [ ${#find_export_vars[@]} -gt 1 ]; then
      local add_to_index=()
      for elem in "${find_export_vars[@]}"; do
        add_to_index+=("$elem,")
        ((counter+=1))
      done
      add_to_index[-1]=${find_export_vars[-1]}
      echo "import { ${add_to_index[*]} } from './${FILE_PATH}.jsx';" >> "$INDEX_FILE"
      VARS_NAME+=("${add_to_index[*]},")
    else
      echo "import { ${find_export_vars[*]} } from './${FILE_PATH}.jsx';" >> "$INDEX_FILE"
      VARS_NAME+=("${find_export_vars[*]},")
      ((counter+=1))
    fi
    find_export_vars=()
  done
  echo -e " ${bold}Number of imported components ${end}:"
  echo -e " ${gray}${counter}${end}"
}

### Agregar la exportación al final del archivo de "index.jsx"
func_finalize_index_file() {
  echo " " >> "$INDEX_FILE"
  echo "export {" >> "$INDEX_FILE"

  for elem in "${VARS_NAME[@]}"; do
    echo " $elem" >> "$INDEX_FILE"
  done
  echo "}" >> "$INDEX_FILE"
}

### Ejecutar el script
func_main() {
  func_initialize_index_file
  func_process_jsx_files
  func_finalize_index_file
}

### Opciones
case "$1" in
  --version|-v)
    echo "v1.1.2"
    ;;
  *)
    func_main
    ;;
esac

