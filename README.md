> Translate this file into your native language using `Google Translate` or a [similar service](https://immersivetranslate.com).

# Impzy

Impzy es una pequeña herramienta escrita en [`Nim`](https://nim-lang.org/) que te ayuda a crear un archivo `index` que contiene todas las exportaciones de javascript de un directorio específico.

## 🗒️ Instalación

Para instalar Impzy, sigue los siguientes:

1. Clona el repositorio en tu equipo.

```bash
git clone https://github.com/farias-hecdin/Impzy.git
```

2. Navega al directorio `impzy/` y ejecuta los siguientes comandos para instalar las dependencias y compilar el programa:

```bash
cd Impzy/
nimble install
nimble build
```

> Nota: ¿No tienes instalado Nimble? No te preocupes. Nimble se instala automáticamente cuando descargas `Nim`. Visita la [web oficial](https://nim-lang.org/) de Nim para descargarlo.

3. Agrega el archivo `impzy`  a tu ruta de `.bashrc` o `.zshrc` para poder ejecutar el programa desde cualquier directorio.

```bash
echo 'export PATH=$PATH:/full/path/to/directory/impzy' >> ~/.zshrc
source ~/.zshrc
```

Asegúrate de reemplazar `full/path/to/directory/impzy` con la ruta real donde almacenaste el archivo `impzy`.

## 🗒️ Uso

Usar Impzy es fácil. Para empezar, solo necesitas ejecutar el comando `impzy parse` con dos opciones: `--pattern <pattern>` y `--dir <path>`. La opción `--pattern` te permite especificar el patrón que deseas analizar, mientras que `--dir` indica el directorio que deseas examinar. Por ejemplo:

```bash
impzy parse --pattern "export *" --dir "./src/components"
```

Una vez que ejecutes el comando, Impzy analizará el directorio especificado (en este caso, `./src/components`) y generará un archivo `index.jsx` en el mismo directorio. Este archivo contendra las exportaciones de todos los elementos encontrados en el directorio. Si deseas personalizar el resultado, puedes modificar el patrón de exportación simplemente cambiando el argumento de la opción `--pattern` (por ejemplo: `--pattern "export default function"`)."

Los patrones validos son:

* `export *` o `export default *` ara capturar cualquier expresión válida que esté precedida por una declaración export.
* `export function`, `export default function`, `export const`, etc. Esto captura patrones específicos.
* `*` para capturar todas las expresiones, ya sea que lleve `default` o no.

Para más información utiliza el comando `impzy --help`.

## 🛡️ Licencia

Impzy está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
