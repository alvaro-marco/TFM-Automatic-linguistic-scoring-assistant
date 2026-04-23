# Configuración de Entorno LaTeX en macOS

Este proyecto está configurado para compilar documentos LaTeX utilizando **Visual Studio Code** y **MacTeX**, manteniendo el espacio de trabajo limpio mediante la redirección de archivos auxiliares a una carpeta dedicada.

## 📋 Requisitos de Instalación

Para poder compilar este proyecto, asegúrate de tener instalados los siguientes componentes en tu Mac:

### 1. MacTeX
Es la distribución completa de LaTeX para macOS. Incluye `latexmk` y todos los motores de renderizado.
- **Descarga manual:** [tug.org/mactex](https://tug.org/mactex/)
- **Instalación rápida (Homebrew):**
  ```bash
  brew install --cask mactex
  ```

### 2. Visual Studio Code

El editor recomendado.

    Descarga: code.visualstudio.com

### 3. Extensión LaTeX Workshop

Busca e instala la extensión LaTeX Workshop (de James Yu) desde el Marketplace de VS Code.
⚙️ Configuración de Preferencias (VS Code)

Para lograr que los archivos basura se guarden en una carpeta aparte pero el PDF se genere en la carpeta principal, sigue estos pasos:

    En VS Code, presiona Cmd + Shift + P.

    Escribe y selecciona "Preferences: Open User Settings (JSON)".

    Pega el siguiente bloque de configuración (o mézclalo con tus llaves {} existentes):

```JSON
{
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "-pdf",
                "-outdir=.",
                "-auxdir=build",
                "%DOC%"
            ],
            "env": {}
        }
    ],

    // Indica a VS Code que el PDF resultante está en la raíz
    "latex-workshop.latex.outDir": "./",

    // Configuración de limpieza de archivos auxiliares
    "latex-workshop.latex.clean.subfolder.enabled": true,
    "latex-workshop.latex.clean.auxiliaryLayers": [
        "build"
    ],

    // Recomendado: compilar automáticamente al guardar el archivo
    "latex-workshop.latex.autoBuild.run": "onFileChange"
}
```
🚀 Cómo utilizarlo

    Preparación: Crea una carpeta llamada build en la raíz de tu proyecto para que LaTeX pueda escribir allí los archivos temporales:
    ```Bash
    mkdir build
    ```

    Compilación: Abre tu archivo .tex y usa el atajo Option + Cmd + B o guarda el archivo (Cmd + S).

    Resultado: - El archivo .pdf aparecerá en la raíz del proyecto.

        Todos los archivos .aux, .log, .gz, etc., se guardarán dentro de /build.

🧹 Limpieza

Si deseas borrar todos los archivos temporales de un plumazo:

    Presiona Cmd + Shift + P.

    Ejecuta: LaTeX Workshop: Clean up auxiliary files.