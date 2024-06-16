# Impzy
Impzy es una pequeña herramienta escrita en bash, diseñada para facilitar la creación de un archivo `index.jsx` que contenga todas las exportaciones de componentes de React.js de un directorio.

## Requisitos

* [`fd`](https://github.com/sharkdp/fd)

## Instalación
Sigue los siguientes pasos para instalar `impzy`

1. Clona este repositorio en tu equipo.
```bash
git clone https://github.com/farias-hecdin/Impzy.git
```

2. Agrega el archivo `impzy` a tu ruta de `.bashrc` o `.zshrc` para poder ejecutar el programa desde cualquier directorio.
```bash
### Bash
echo 'export PATH=$PATH:/ruta/completa/al/directorio/impzy' >> ~/.bashrc
source ~/.bashrc
```

```bash
### Zsh
echo 'export PATH=$PATH:/ruta/completa/al/directorio/impzy' >> ~/.zshrc
source ~/.zshrc
```

Asegúrate de reemplazar `/ruta/completa/al/directorio/impzy` con la ruta real donde almacenaste el archivo `impzy`.

## Uso
Impzy está diseñado para ser simple y fácil de usar. Solo necesitas ejecutar el comando `impzy` seguido de la opción `--parse` o `-p` y el directorio que deseas analizar:

```bash
impzy --parse /ruta/al/directorio
```

Impzy analizará el directorio y creará un archivo `index.jsx`, con todas las exportaciones de componentes de React.js del directorio.

## Licencia
Impzy está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
