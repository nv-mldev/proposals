#!/bin/bash

# Script to convert Mermaid diagrams to PNG images
# Converts all .mmd files in infra/mermaid/ to PNG images in pics/ folder

# Set Chrome executable path for Puppeteer
export PUPPETEER_EXECUTABLE_PATH="/usr/bin/google-chrome-stable"

# Define directories
MERMAID_DIR="infra/mermaid"
OUTPUT_DIR="pics"

# Check if mermaid CLI is installed
if ! command -v mmdc &> /dev/null; then
    echo "Error: Mermaid CLI (mmdc) is not installed!"
    echo "Please install it with: npm install -g @mermaid-js/mermaid-cli"
    exit 1
fi

# Check if input directory exists
if [ ! -d "$MERMAID_DIR" ]; then
    echo "Error: Directory $MERMAID_DIR does not exist!"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Initialize counters
total_files=0
converted_files=0
failed_files=0

echo "Converting Mermaid diagrams from $MERMAID_DIR to $OUTPUT_DIR..."
echo "=============================================================="

# Process each .mmd file in the mermaid directory
for mermaid_file in "$MERMAID_DIR"/*.mmd; do
    # Check if files exist (in case no .mmd files are found)
    if [ ! -f "$mermaid_file" ]; then
        echo "No .mmd files found in $MERMAID_DIR"
        exit 1
    fi
    
    # Get the base filename without path and extension
    base_name=$(basename "$mermaid_file" .mmd)
    
    # Define output PNG file path
    png_file="$OUTPUT_DIR/${base_name}.png"
    
    echo "Converting: $mermaid_file -> $png_file"
    
    # Increment total files counter
    ((total_files++))
    
    # Convert mermaid diagram to PNG with high resolution
    if mmdc -i "$mermaid_file" -o "$png_file" \
            --width 1200 \
            --height 800 \
            --scale 2 \
            --backgroundColor white; then
        echo "✓ Successfully converted: $base_name"
        ((converted_files++))
    else
        echo "✗ Failed to convert: $base_name"
        ((failed_files++))
    fi
    
    echo ""
done

echo "=============================================================="
echo "Conversion Summary:"
echo "  Total files found: $total_files"
echo "  Successfully converted: $converted_files"
echo "  Failed conversions: $failed_files"
echo ""

if [ $failed_files -eq 0 ]; then
    echo "🎉 All diagrams converted successfully!"
    echo "Images saved in: $(realpath $OUTPUT_DIR)"
else
    echo "⚠️  Some conversions failed. Please check the error messages above."
fi

# List the generated PNG files
if [ $converted_files -gt 0 ]; then
    echo ""
    echo "Generated image files:"
    ls -la "$OUTPUT_DIR"/*.png 2>/dev/null || echo "No PNG files found in $OUTPUT_DIR"
fi
