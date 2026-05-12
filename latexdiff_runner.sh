#!/bin/zsh

echo "===== LaTeX Diff Runner v1 ====="

# ----------------------------
# INPUTS
# ----------------------------
read "BASE_COMMIT?Introduce commit base: "
read "TARGET_COMMIT?Introduce commit objetivo (default: HEAD): "

# Default HEAD si vacío
if [[ -z "$TARGET_COMMIT" ]]; then
  TARGET_COMMIT="HEAD"
fi

# Archivo principal
read "MAIN_TEX?Ruta a main.tex (default: main.tex): "
if [[ -z "$MAIN_TEX" ]]; then
  MAIN_TEX="main.tex"
fi

# Carpeta de salida
OUTPUT_DIR="revise"
echo "\n📁 Creando carpeta $OUTPUT_DIR..."
mkdir -p $OUTPUT_DIR

# ----------------------------
# CLEAN AUX FILES (seguro)
# ----------------------------
echo "🧹 Limpiando archivos auxiliares..."
find . -type f \( \
  -name "*.aux" -o \
  -name "*.log" -o \
  -name "*.out" -o \
  -name "*.toc" -o \
  -name "*.fls" -o \
  -name "*.fdb_latexmk" -o \
  -name "*.synctex.gz" \
\) -delete

# ----------------------------
# RUN GIT LATEXDIFF
# ----------------------------
echo "🚀 Ejecutando git latexdiff..."

echo "📄 Compilando PDF..."

git latexdiff $BASE_COMMIT $TARGET_COMMIT \
  --main "$MAIN_TEX" \
  --no-view \
  --ignore-latex-errors \
  --latexopt "-interaction=nonstopmode" \
  --output "$OUTPUT_DIR/diff"

# ----------------------------
# CHECK OUTPUT
# ----------------------------

cd "$OUTPUT_DIR"

FILE_TYPE=$(file diff)

echo "📄 Tipo detectado: $FILE_TYPE"

if echo "$FILE_TYPE" | grep -q "PDF"; then
  mv diff diff.pdf
  echo "✅ PDF listo en: $OUTPUT_DIR/diff.pdf"
  exit 0
else
  mv diff diff.tex
  pdflatex -interaction=nonstopmode diff.tex > /dev/null
  if [[ -f "diff.pdf" ]]; then
    echo "✅ PDF generado correctamente:"
    echo "   👉 $OUTPUT_DIR/diff.pdf"
    exit 0
  else
    echo "❌ Error: no se generó PDF"
    exit 1
  fi
fi