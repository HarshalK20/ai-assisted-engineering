#!/bin/bash

# Diagram Generator
# Generates architecture diagrams from Mermaid or PlantUML source files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if required tools are installed
check_dependencies() {
    local missing_deps=()
    
    if ! command -v mmdc &> /dev/null; then
        missing_deps+=("mermaid-cli (@mermaid-js/mermaid-cli)")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        echo "Install missing dependencies:"
        echo "  npm install -g @mermaid-js/mermaid-cli"
        echo "  # or"
        echo "  brew install mermaid-cli"
        return 1
    fi
    
    return 0
}

# Function to generate Mermaid diagram
generate_mermaid() {
    local input_file=$1
    local output_file=$2
    local format=${3:-png}
    
    print_info "Generating Mermaid diagram..."
    print_info "Input: $input_file"
    print_info "Output: $output_file"
    print_info "Format: $format"
    
    if [ ! -f "$input_file" ]; then
        print_error "Input file not found: $input_file"
        return 1
    fi
    
    # Generate diagram
    if mmdc -i "$input_file" -o "$output_file" -b transparent; then
        print_info "✓ Diagram generated successfully: $output_file"
        return 0
    else
        print_error "✗ Failed to generate diagram"
        return 1
    fi
}

# Function to batch process all Mermaid files in a directory
batch_process_mermaid() {
    local input_dir=${1:-.}
    local output_dir=${2:-./diagrams}
    local format=${3:-png}
    
    print_info "Batch processing Mermaid files..."
    print_info "Input directory: $input_dir"
    print_info "Output directory: $output_dir"
    print_info "Format: $format"
    
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"
    
    # Find all .mmd files
    local mmd_files=$(find "$input_dir" -name "*.mmd" -type f)
    
    if [ -z "$mmd_files" ]; then
        print_warning "No .mmd files found in $input_dir"
        return 1
    fi
    
    local count=0
    local success=0
    local failed=0
    
    while IFS= read -r file; do
        count=$((count + 1))
        local filename=$(basename "$file" .mmd)
        local output_file="$output_dir/${filename}.$format"
        
        echo ""
        print_info "Processing ($count): $file"
        
        if mmdc -i "$file" -o "$output_file" -b transparent 2>/dev/null; then
            success=$((success + 1))
            print_info "✓ Success: $output_file"
        else
            failed=$((failed + 1))
            print_error "✗ Failed: $file"
        fi
    done <<< "$mmd_files"
    
    echo ""
    print_info "========================================="
    print_info "Batch processing complete!"
    print_info "Total files: $count"
    print_info "Successful: $success"
    print_info "Failed: $failed"
    print_info "========================================="
}

# Function to create a sample Mermaid diagram
create_sample() {
    local output_file=${1:-sample-diagram.mmd}
    
    print_info "Creating sample Mermaid diagram: $output_file"
    
    cat > "$output_file" << 'EOF'
# Sample Architecture Diagram

```mermaid
graph TB
    subgraph frontend [Frontend Layer]
        Web[Web Application<br/>React]
        Mobile[Mobile App<br/>React Native]
    end
    
    subgraph backend [Backend Services]
        API[API Gateway<br/>Kong]
        Auth[Auth Service<br/>Node.js]
        Users[User Service<br/>Python]
        Orders[Order Service<br/>Go]
    end
    
    subgraph data [Data Layer]
        UserDB[(User Database<br/>PostgreSQL)]
        OrderDB[(Order Database<br/>PostgreSQL)]
        Cache[(Cache<br/>Redis)]
    end
    
    Web --> API
    Mobile --> API
    
    API --> Auth
    API --> Users
    API --> Orders
    
    Auth --> UserDB
    Users --> UserDB
    Orders --> OrderDB
    
    Users --> Cache
    Orders --> Cache
```
EOF

    print_info "✓ Sample diagram created: $output_file"
    print_info "Generate PNG: ./diagram-generator.sh $output_file"
}

# Function to watch for changes and auto-regenerate
watch_and_generate() {
    local input_file=$1
    local output_file=$2
    local format=${3:-png}
    
    if ! command -v fswatch &> /dev/null; then
        print_error "fswatch not installed"
        echo "Install with: brew install fswatch"
        return 1
    fi
    
    print_info "Watching $input_file for changes..."
    print_info "Press Ctrl+C to stop"
    
    # Generate initially
    generate_mermaid "$input_file" "$output_file" "$format"
    
    # Watch for changes
    fswatch -o "$input_file" | while read; do
        echo ""
        print_info "File changed, regenerating..."
        generate_mermaid "$input_file" "$output_file" "$format"
    done
}

# Function to show usage
show_usage() {
    cat << EOF
Diagram Generator - Generate architecture diagrams from Mermaid source files

Usage:
    $0 <command> [options]

Commands:
    generate <input.mmd> [output.png] [format]
        Generate diagram from Mermaid file
        Formats: png, svg, pdf (default: png)
        
        Example:
            $0 generate architecture.mmd architecture.png
            $0 generate architecture.mmd architecture.svg svg

    batch [input_dir] [output_dir] [format]
        Batch process all .mmd files in directory
        
        Example:
            $0 batch ./docs/diagrams ./output png
            $0 batch . ./diagrams

    sample [filename]
        Create a sample Mermaid diagram file
        
        Example:
            $0 sample my-diagram.mmd

    watch <input.mmd> [output.png] [format]
        Watch file for changes and auto-regenerate
        (Requires fswatch: brew install fswatch)
        
        Example:
            $0 watch architecture.mmd architecture.png

    help
        Show this help message

Examples:
    # Generate single diagram
    $0 generate docs/architecture.mmd docs/architecture.png

    # Batch process all diagrams in docs/
    $0 batch docs/ output/

    # Create sample and generate
    $0 sample test.mmd
    $0 generate test.mmd test.png

    # Watch and auto-regenerate
    $0 watch architecture.mmd architecture.png

Dependencies:
    - mermaid-cli: npm install -g @mermaid-js/mermaid-cli
    - fswatch (optional, for watch): brew install fswatch

EOF
}

# Main script logic
main() {
    local command=${1:-help}
    
    case "$command" in
        generate)
            if ! check_dependencies; then
                exit 1
            fi
            
            if [ -z "$2" ]; then
                print_error "Missing input file"
                echo "Usage: $0 generate <input.mmd> [output.png] [format]"
                exit 1
            fi
            
            local input_file=$2
            local output_file=${3:-${input_file%.mmd}.png}
            local format=${4:-png}
            
            generate_mermaid "$input_file" "$output_file" "$format"
            ;;
            
        batch)
            if ! check_dependencies; then
                exit 1
            fi
            
            local input_dir=${2:-.}
            local output_dir=${3:-./diagrams}
            local format=${4:-png}
            
            batch_process_mermaid "$input_dir" "$output_dir" "$format"
            ;;
            
        sample)
            local output_file=${2:-sample-diagram.mmd}
            create_sample "$output_file"
            ;;
            
        watch)
            if ! check_dependencies; then
                exit 1
            fi
            
            if [ -z "$2" ]; then
                print_error "Missing input file"
                echo "Usage: $0 watch <input.mmd> [output.png] [format]"
                exit 1
            fi
            
            local input_file=$2
            local output_file=${3:-${input_file%.mmd}.png}
            local format=${4:-png}
            
            watch_and_generate "$input_file" "$output_file" "$format"
            ;;
            
        help|--help|-h)
            show_usage
            ;;
            
        *)
            print_error "Unknown command: $command"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
