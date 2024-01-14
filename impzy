#!/bin/bash
### MIT License Copyright (c) 2024 Hecdin Farias.

set -o errexit
set -o nounset
set -o pipefail

### Colores
gray="\e[2m"
bold="\e[1m"
end="\e[0m"

### Variables globales
IN_OPT=${1:-.}
IN_PATH=${2:-.}
INDEX_FILE="index.jsx"
VARS_NAME=()

### Mostrar ayuda
function func_show_help() {
  cat << EOF

  Usage:
    impzy [Options] [Arguments]

  Arguments:
    directory      Specify a directory (this is a required argument).

  Options:
    -p, --parse    Examine the specified directory and return an index.jsx file.
    -h, --help     Display this help message and exit.
    -v, --version  Display the version of the program and exit.

EOF
}

### Crear o limpiar el archivo "index.jsx"
func_initialize_index_file() {
  > "$INDEX_FILE"
}

### Procesar los archivos JSX y generar las importaciones
func_process_jsx_files() {
  local counter=0
  # Buscar todos los archivos .jsx en el directorio actual y sus subdirectorios
  local find
  find=$(fd --full-path "$IN_PATH" -e "jsx")

  for file in $find; do
    # Formatear la ruta del archivo
    local file_path
    file_path=$(echo "$file" | sed 's/^\.\///;s/\.jsx$//')
    # Extraer el nombre del archivo sin la extensión
    local file_name
    file_name=$(basename "$file" .jsx)
    # Ignorar archivos con el nombre 'index.jsx'
    if [ "$file_name" == "index" ]; then
      continue
    fi
    # Almacenar los datos en una variable
    local find_export_vars
    find_export_vars=($(rg --color=never 'export\s+const\s+\w+' "$file" | awk '{print $3}' | sed 's/;//g' | sed 's/,//g' | sed 's/}/\n/g'))
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
      echo "import { ${add_to_index[*]} } from './${file_path}.jsx';" >> "$INDEX_FILE"
      VARS_NAME+=("${add_to_index[*]},")
    else
      echo "import { ${find_export_vars[*]} } from './${file_path}.jsx';" >> "$INDEX_FILE"
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
  if ! [ -d "$IN_PATH" ]; then
    echo " Invalid directory."
  else
    func_initialize_index_file
    func_process_jsx_files
    func_finalize_index_file
  fi
}

### Opciones
case "${IN_OPT}" in
  --help|-h)
    func_show_help
    ;;
  --version|-v)
    echo "v1.1.3"
    ;;
  --parse|-p)
    func_main
    ;;
  *)
    echo " Invalid option."
    ;;
esac
