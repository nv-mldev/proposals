#!/bin/bash

# Script to convert README.md with Mermaid diagrams to PDF

# Check if input file exists
if [ ! -f "infra/README.md" ]; then
    echo "Error: infra/README.md not found!"
    exit 1
fi

echo "Converting Mermaid diagrams to images..."

# Create temp directory for images
mkdir -p temp_images

# Copy the original file to process
cp infra/README.md temp_images/README_temp.md

# Extract individual mermaid diagrams and convert them
counter=1
while IFS= read -r line; do
    if [[ "$line" == '```mermaid' ]]; then
        # Start extracting mermaid code
        echo "$line" > temp_images/diagram_$counter.mmd
        while IFS= read -r mermaid_line; do
            if [[ "$mermaid_line" == '```' ]]; then
                echo "$mermaid_line" >> temp_images/diagram_$counter.mmd
                break
            else
                echo "$mermaid_line" >> temp_images/diagram_$counter.mmd
            fi
        done
        
        # Convert the mermaid diagram to PNG
        mmdc -i temp_images/diagram_$counter.mmd -o temp_images/diagram_$counter.png -t dark --backgroundColor transparent
        
        # Replace the mermaid code block with image reference in the temp file
        sed -i "/\`\`\`mermaid/,/\`\`\`/c![Diagram $counter](temp_images/diagram_$counter.png)" temp_images/README_temp.md
        
        ((counter++))
    fi
done < infra/README.md

echo "Converting to PDF..."

# Convert to PDF with pandoc
pandoc temp_images/README_temp.md \
    -o infra/README.pdf \
    --pdf-engine=xelatex \
    -V mainfont="DejaVu Sans" \
    -V geometry:margin=1in \
    --toc \
    --number-sections

# Clean up
rm -rf temp_images

echo "PDF generated: infra/README.pdf"
