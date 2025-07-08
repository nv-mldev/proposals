# Software Design Document - LaTeX Build

This directory contains the LaTeX source code for the ProWiz Version 3.0 Software Design Document.

## Files

- `software-design-document.tex` - Main LaTeX document with all chapters
- `build.sh` - Build script to compile the document
- `README.md` - This file

## Document Structure

The document includes the following chapters, each with embedded images from the `../../pics/` directory:

1. **System Architecture Overview** - `arch.png`
2. **Detailed Architecture Design** - `arch_architecture.png`
3. **Compliance and Governance Framework** - `compliance.png`
4. **Documentation and Knowledge Management** - `doc.png`
5. **Email and Communication Infrastructure** - `email.png`
6. **ERP Integration and Business Process Automation** - `erp-action.png`
7. **Workflow Management and Process Orchestration** - `flow.png`
8. **Project Timeline and Resource Scheduling** - `gantt.png`
9. **Server Infrastructure and Deployment Architecture** - `server.png`

## Features

- Professional document formatting with table of contents and list of figures
- Comprehensive chapters with technical details and analysis
- Embedded high-quality images from your pics directory
- Appendices with technical specifications, API reference, and glossary
- Proper cross-references and hyperlinks
- Professional styling with headers and page numbering

## Building the Document

### Prerequisites

Make sure you have LaTeX installed on your system:

```bash
# Ubuntu/Debian
sudo apt-get install texlive-full

# macOS with Homebrew
brew install --cask mactex

# Or minimal installation
sudo apt-get install texlive-latex-base texlive-latex-extra texlive-fonts-recommended
```

### Build Process

1. Navigate to this directory:

   ```bash
   cd /home/nithin/work/proposals/prowiz/ver3/infra/latex
   ```

2. Run the build script:

   ```bash
   ./build.sh
   ```

3. The script will generate `software-design-document.pdf`

### Manual Build (Alternative)

If you prefer to build manually:

```bash
pdflatex software-design-document.tex
pdflatex software-design-document.tex  # Run twice for proper references
```

## Output

The compiled document will be:

- **File**: `software-design-document.pdf`
- **Format**: Professional PDF with bookmarks and hyperlinks
- **Content**: Complete software design document with all images embedded

## Customization

To customize the document:

1. **Add new chapters**: Add new `\chapter{}` sections before the appendices
2. **Modify styling**: Edit the preamble section with package configurations
3. **Add images**: Place new images in `../../pics/` and reference them with `\includegraphics{}`
4. **Update content**: Edit the chapter content as needed

## Troubleshooting

- **Missing images**: Ensure all PNG files exist in `../../pics/` directory
- **LaTeX errors**: Check the `.log` file for detailed error messages
- **Missing packages**: Install additional LaTeX packages as needed

## Document Specifications

- **Page Size**: A4
- **Font Size**: 12pt
- **Margins**: 1 inch on all sides
- **Graphics**: PNG images scaled to fit page width
- **Cross-references**: Automatic chapter and figure numbering
- **Navigation**: PDF bookmarks and hyperlinks enabled
