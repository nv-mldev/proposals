#!/bin/bash

# Build script for Software Design Document
# This script compiles the LaTeX document and generates the PDF

echo "Building Software Design Document..."

# Navigate to the latex directory
cd "$(dirname "$0")"

# Clean up any previous builds
rm -f *.aux *.log *.out *.toc *.lof *.lot *.fdb_latexmk *.fls *.synctex.gz *.nav *.snm

# Compile the document
echo "Running pdflatex (first pass)..."
pdflatex -interaction=nonstopmode software-design-document.tex

echo "Running pdflatex (second pass for references)..."
pdflatex -interaction=nonstopmode software-design-document.tex

echo "Running pdflatex (third pass for table of contents)..."
pdflatex -interaction=nonstopmode software-design-document.tex

# Check if PDF was generated successfully
if [ -f "software-design-document.pdf" ]; then
    echo "✓ PDF generated successfully: software-design-document.pdf"
    echo "Document size: $(du -h software-design-document.pdf | cut -f1)"
else
    echo "✗ Failed to generate PDF. Check the log files for errors."
    exit 1
fi

echo "Build completed!"
