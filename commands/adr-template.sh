#!/bin/bash

# ADR Template Generator
# Creates Architecture Decision Records with proper numbering and template

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ADR_DIR="docs/decisions"
ADR_INDEX="$ADR_DIR/README.md"

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

print_title() {
    echo -e "${BLUE}$1${NC}"
}

# Function to create ADR directory if it doesn't exist
init_adr_directory() {
    if [ ! -d "$ADR_DIR" ]; then
        print_info "Creating ADR directory: $ADR_DIR"
        mkdir -p "$ADR_DIR"
        
        # Create initial index
        create_adr_index
        
        # Create first ADR (about using ADRs)
        create_first_adr
    fi
}

# Function to create or update ADR index
create_adr_index() {
    cat > "$ADR_INDEX" << 'EOF'
# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) documenting significant architectural decisions for this project.

## What is an ADR?

An Architecture Decision Record (ADR) captures important architectural decisions made along with their context and consequences.

## Format

Each ADR follows this structure:
- **Status**: Proposed, Accepted, Deprecated, or Superseded
- **Context**: What is the issue motivating this decision?
- **Decision**: What we will do (in active voice)
- **Consequences**: What becomes easier or more difficult

## Active Decisions

| ADR | Title | Date | Status |
|-----|-------|------|--------|

## Deprecated Decisions

| ADR | Title | Date | Status | Superseded By |
|-----|-------|------|--------|---------------|

## Rejected Decisions

| ADR | Title | Date | Status |
|-----|-------|------|--------|
EOF

    print_info "✓ ADR index created/updated: $ADR_INDEX"
}

# Function to create first ADR
create_first_adr() {
    local date=$(date +%Y-%m-%d)
    
    cat > "$ADR_DIR/0001-use-architecture-decision-records.md" << EOF
# 1. Use Architecture Decision Records

Date: $date

## Status

Accepted

## Context

We need to record the architectural decisions made on this project to:
- Help current and future team members understand why decisions were made
- Provide context for architectural evolution
- Enable better decision-making by learning from past choices
- Document trade-offs explicitly

## Decision

We will use Architecture Decision Records (ADRs), as described by Michael Nygard, to document significant architectural decisions.

An ADR consists of:
- A title and number
- Status (Proposed, Accepted, Deprecated, Superseded)
- Context (what is the issue we're seeing that motivates this decision)
- Decision (what we will do in response to the issue)
- Consequences (what becomes easier or more difficult as a result)

ADRs will be:
- Stored in \`docs/decisions/\`
- Numbered sequentially (0001, 0002, etc.)
- Written in Markdown
- Committed to version control with code

## Consequences

### Positive
- Architectural knowledge is captured and preserved
- New team members can understand decision rationale
- Decisions are made explicit and visible
- Historical context is available when revisiting decisions

### Negative
- Requires discipline to document decisions
- Takes time to write ADRs
- Team must agree on what constitutes a "significant" decision

### Neutral
- ADRs become part of our development workflow
- Will need tooling to help create and manage ADRs
EOF

    print_info "✓ First ADR created: 0001-use-architecture-decision-records.md"
}

# Function to get next ADR number
get_next_adr_number() {
    local max_num=0
    
    if [ -d "$ADR_DIR" ]; then
        for file in "$ADR_DIR"/*.md; do
            if [ -f "$file" ] && [ "$(basename "$file")" != "README.md" ]; then
                local num=$(basename "$file" | grep -o '^[0-9]\+')
                if [ ! -z "$num" ]; then
                    num=$((10#$num))  # Convert to decimal
                    if [ $num -gt $max_num ]; then
                        max_num=$num
                    fi
                fi
            fi
        done
    fi
    
    printf "%04d" $((max_num + 1))
}

# Function to create new ADR
create_adr() {
    local title=$1
    local status=${2:-Proposed}
    
    if [ -z "$title" ]; then
        print_error "Title is required"
        echo "Usage: $0 new <title> [status]"
        return 1
    fi
    
    # Initialize ADR directory if needed
    init_adr_directory
    
    # Get next number
    local number=$(get_next_adr_number)
    
    # Create filename
    local slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    local filename="$ADR_DIR/${number}-${slug}.md"
    
    # Get current date
    local date=$(date +%Y-%m-%d)
    
    # Create ADR file
    cat > "$filename" << EOF
# ${number#0}. $title

Date: $date

## Status

$status

## Context

[Describe the issue motivating this decision or change]

## Decision

[Describe the decision in active voice: "We will..."]

## Consequences

### Positive
- [What becomes easier or possible]
- [Benefit 2]

### Negative
- [What becomes harder or impossible]
- [Trade-off 2]

### Neutral
- [Neither positive nor negative, but noteworthy]
EOF

    print_info "✓ ADR created: $filename"
    print_info ""
    print_title "Next steps:"
    echo "  1. Edit the ADR: $filename"
    echo "  2. Fill in the Context, Decision, and Consequences sections"
    echo "  3. Commit to version control"
    echo "  4. Update index: $0 index"
    echo ""
    
    # Open in editor if EDITOR is set
    if [ ! -z "$EDITOR" ]; then
        print_info "Opening in $EDITOR..."
        $EDITOR "$filename"
    fi
}

# Function to update ADR status
update_status() {
    local adr_number=$1
    local new_status=$2
    local superseded_by=${3:-}
    
    if [ -z "$adr_number" ] || [ -z "$new_status" ]; then
        print_error "ADR number and status are required"
        echo "Usage: $0 status <number> <status> [superseded_by]"
        return 1
    fi
    
    # Find ADR file
    local adr_file=$(find "$ADR_DIR" -name "${adr_number}-*.md" | head -n 1)
    
    if [ -z "$adr_file" ]; then
        print_error "ADR not found: $adr_number"
        return 1
    fi
    
    # Update status in file
    if [ "$new_status" = "Superseded" ] && [ ! -z "$superseded_by" ]; then
        sed -i.bak "s/^Status$/Status\n\n~~$old_status~~\n**Superseded** by [ADR-$superseded_by]($superseded_by)/" "$adr_file"
    else
        sed -i.bak "s/^## Status.*/## Status\n\n$new_status/" "$adr_file"
    fi
    
    rm -f "${adr_file}.bak"
    
    print_info "✓ Updated status of $adr_file to: $new_status"
}

# Function to list all ADRs
list_adrs() {
    print_title "Architecture Decision Records"
    echo ""
    
    if [ ! -d "$ADR_DIR" ]; then
        print_warning "No ADR directory found. Run: $0 init"
        return 1
    fi
    
    local count=0
    
    for file in "$ADR_DIR"/*.md; do
        if [ -f "$file" ] && [ "$(basename "$file")" != "README.md" ]; then
            count=$((count + 1))
            
            local number=$(basename "$file" | grep -o '^[0-9]\+')
            local title=$(grep -m 1 "^# " "$file" | sed 's/^# [0-9]\+\. //')
            local status=$(grep -A 1 "^## Status" "$file" | tail -n 1 | sed 's/^[[:space:]]*//')
            local date=$(grep "^Date:" "$file" | sed 's/Date: //')
            
            echo "[$number] $title"
            echo "      Status: $status | Date: $date"
            echo "      File: $file"
            echo ""
        fi
    done
    
    if [ $count -eq 0 ]; then
        print_warning "No ADRs found"
    else
        print_info "Total ADRs: $count"
    fi
}

# Function to update ADR index
update_index() {
    print_info "Updating ADR index..."
    
    if [ ! -d "$ADR_DIR" ]; then
        print_error "ADR directory not found"
        return 1
    fi
    
    # Create temp file for new index
    local temp_index=$(mktemp)
    
    # Write header
    cat > "$temp_index" << 'EOF'
# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) documenting significant architectural decisions for this project.

## Active Decisions

| ADR | Title | Date | Status |
|-----|-------|------|--------|
EOF

    # Add active decisions
    for file in "$ADR_DIR"/*.md; do
        if [ -f "$file" ] && [ "$(basename "$file")" != "README.md" ]; then
            local number=$(basename "$file" | grep -o '^[0-9]\+')
            local title=$(grep -m 1 "^# " "$file" | sed 's/^# [0-9]\+\. //')
            local status=$(grep -A 1 "^## Status" "$file" | tail -n 1 | sed 's/^[[:space:]]*//')
            local date=$(grep "^Date:" "$file" | sed 's/Date: //')
            local filename=$(basename "$file")
            
            if [[ "$status" == "Accepted" ]] || [[ "$status" == "Proposed" ]]; then
                echo "| [$number]($filename) | $title | $date | $status |" >> "$temp_index"
            fi
        fi
    done
    
    # Add deprecated section
    cat >> "$temp_index" << 'EOF'

## Deprecated Decisions

| ADR | Title | Date | Status |
|-----|-------|------|--------|
EOF

    # Add deprecated decisions
    for file in "$ADR_DIR"/*.md; do
        if [ -f "$file" ] && [ "$(basename "$file")" != "README.md" ]; then
            local number=$(basename "$file" | grep -o '^[0-9]\+')
            local title=$(grep -m 1 "^# " "$file" | sed 's/^# [0-9]\+\. //')
            local status=$(grep -A 1 "^## Status" "$file" | tail -n 1 | sed 's/^[[:space:]]*//')
            local date=$(grep "^Date:" "$file" | sed 's/Date: //')
            local filename=$(basename "$file")
            
            if [[ "$status" == *"Deprecated"* ]] || [[ "$status" == *"Superseded"* ]]; then
                echo "| [$number]($filename) | $title | $date | $status |" >> "$temp_index"
            fi
        fi
    done
    
    # Replace old index
    mv "$temp_index" "$ADR_INDEX"
    
    print_info "✓ ADR index updated: $ADR_INDEX"
}

# Function to show usage
show_usage() {
    cat << EOF
ADR Template Generator - Create and manage Architecture Decision Records

Usage:
    $0 <command> [options]

Commands:
    init
        Initialize ADR directory structure
        Creates docs/decisions/ and first ADR
        
        Example:
            $0 init

    new <title> [status]
        Create new ADR with title
        Status: Proposed (default), Accepted, Deprecated, Superseded
        
        Example:
            $0 new "Use PostgreSQL for database"
            $0 new "Migrate to microservices" Proposed

    list
        List all ADRs with status
        
        Example:
            $0 list

    status <number> <new_status> [superseded_by]
        Update ADR status
        
        Example:
            $0 status 0005 Accepted
            $0 status 0003 Superseded 0008

    index
        Regenerate ADR index (README.md)
        
        Example:
            $0 index

    help
        Show this help message

Examples:
    # Initialize ADR system
    $0 init

    # Create new ADR
    $0 new "Use Redis for caching"

    # List all ADRs
    $0 list

    # Accept an ADR
    $0 status 0005 Accepted

    # Supersede an old ADR
    $0 status 0003 Superseded 0010

    # Update index
    $0 index

Configuration:
    ADR_DIR: $ADR_DIR (can be changed in script)
    EDITOR: ${EDITOR:-not set} (for auto-opening new ADRs)

EOF
}

# Main script logic
main() {
    local command=${1:-help}
    
    case "$command" in
        init)
            init_adr_directory
            print_info "✓ ADR system initialized"
            ;;
            
        new)
            shift
            create_adr "$@"
            ;;
            
        list)
            list_adrs
            ;;
            
        status)
            shift
            update_status "$@"
            ;;
            
        index)
            update_index
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
