> [!TIP]
> Use `Google Translate` to read this file in your native language.

# Impzy
Impzy es una pequeña herramienta escrita en [`Nim`](https://nim-lang.org/) que te ayuda a crear un archivo `index` que contiene todas las exportaciones de javascript de un directorio específico.

## Instalación
Para instalar Impzy, sigue los siguientes:

1. Clona este repositorio en tu equipo.
```bash
git clone https://github.com/farias-hecdin/Impzy.git
```

2. Agrega el archivo `impzy-[arm/arm64]` que se encuentra en `bin/` a tu ruta de `.bashrc` o `.zshrc` para poder ejecutar el programa desde cualquier directorio.
```sh
echo 'export PATH=$PATH:/full/path/to/directory/impzy' >> ~/.zshrc
source ~/.zshrc
```

Asegúrate de reemplazar `full/path/to/directory/impzy` con la ruta real donde almacenaste el archivo `impzy`.

## Uso
Impzy es fácil de usar. Para empezar, solo necesitas ejecutar el comando `impzy parse` con dos opciones: `--pattern <pattern>` y `--dir <path>`. La opción `--pattern` te permite especificar el patrón que deseas analizar, mientras que `--dir` indica el directorio que deseas examinar. Por ejemplo:
```bash
impzy parse --pattern "export *" --dir "./src/components"
```

Una vez que ejecutes el comando, Impzy analizará el directorio especificado (en este caso, `./src/components`) y generará un archivo `index.jsx` en el mismo directorio. Este archivo contendra las exportaciones de todos los elementos encontrados en el directorio. Si deseas personalizar el resultado, puedes modificar el patrón de exportación simplemente cambiando el argumento de la opción `--pattern` (por ejemplo: `--pattern "export default function"`)."

Para más información utiliza el comando `impzy --help`.

## Licencia
Impzy está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
