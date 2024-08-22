import std/[strutils, strformat]
import pkg/[tinyre, cmdos]
import export_extractor, term_proccesor, text_styled, file_ops

var logs, recursive = false
var exportedComponents*, indexedFiles* = 0

#-- Generar el contenido del archivo 'index'
proc generateIndexFile*(file: string, imports, components: seq[string]) =
  let f = open(file, fmWrite)
  defer: f.close()
  # Add the import statements
  for elem in imports:
    appendLine(f, elem)
  appendLine(f, "")
  appendLine(f, "export {")
  # Add the exported components
  for elem in components:
    appendLine(f, &"  {elem},")
  appendLine(f, "}")

proc getImportsAndComponents*(pattern, dir, extension: string): (seq[string], seq[string]) =
  var imports, components, messages: seq[string]
  let defaultPattern = re"default"

  # Verificar que el término de búsqueda sea válido
  if not validateTermSearch(pattern): errorTextAndExit("Invalid pattern.")
  let keywords = extractTerm(pattern)
  # Obtener una lista de archivos y validarla
  let files = findFiles(extension, dir, recursive)
  let totalFiles = files.len
  if totalFiles == 0: errorTextAndExit("No files found.")

  stdout.writeLine(underline & "Progress:" & nostyle)
  # Iterar sobre cada archivo encontrado
  for filePath in files:
    let identifiers = getIdentifiers(filePath, keywords)
    # Mostrar progreso en la consola.
    indexedFiles += 1
    loading(totalFiles, indexedFiles)
    # Verificar si se encontraron identificadores en el archivo actual.
    if identifiers[0] != "":
      let componentsList = identifiers.join(", ")
      # Construir la sentencia de importación
      let importStatement = (
        if pattern.find(defaultPattern) > 0: "import $# from \"$#\";" % [componentsList, filePath]
        else: "import { $# } from \"$#\";" % [componentsList, filePath]
      )
      components.add(identifiers)
      imports.add(importStatement)
      # Si está habilitada la opción de logs, agregar el mensaje correspondiente
      if logs: messages.add(foundText(filePath, $identifiers.len))
    else:
      if logs: messages.add(noFoundText(filePath))

  if logs: stdout.write("\n\n$#Files:$#\n$#" % [underline, nostyle, messages.join("\n")])
  exportedComponents = components.len
  result = (imports, components)

#-- Inicializar "--parse [options]"
proc initParseCommand*(flag: CmdosFlags, arg: CmdosArgs): bool =
  let pattern = getArgsValue(arg, "--pattern")[0]
  let dir = getArgsValue(arg, "--dir")[0]
  let extension = getArgsValue(arg, "--ext")[0]
  recursive = getFlagsValue(flag, "--recursive")
  logs = getFlagsValue(flag, "--log")

  # Generar las importaciones
  let (imports, components) = getImportsAndComponents(pattern, dir, extension)
  if exportedComponents > 0:
    # Crear un nuevo archivo y añadir los datos encontrados
    let file = "index." & extension
    createNewFile(file)
    generateIndexFile(file, imports, components)
  result = true
