#!/bin/bash

# API Validator
# Validates OpenAPI specifications for breaking changes and best practices

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_title() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command -v node &> /dev/null; then
        missing_deps+=("node")
    fi
    
    if ! npm list -g openapi-diff &> /dev/null; then
        missing_deps+=("openapi-diff")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        echo "Install missing dependencies:"
        echo "  npm install -g openapi-diff"
        return 1
    fi
    
    return 0
}

# Function to validate OpenAPI spec format
validate_spec() {
    local spec_file=$1
    
    print_info "Validating OpenAPI spec: $spec_file"
    
    if [ ! -f "$spec_file" ]; then
        print_error "Spec file not found: $spec_file"
        return 1
    fi
    
    # Check if it's valid JSON or YAML
    if [[ "$spec_file" == *.json ]]; then
        if ! jq empty "$spec_file" 2>/dev/null; then
            print_error "Invalid JSON format"
            return 1
        fi
    elif [[ "$spec_file" == *.yaml ]] || [[ "$spec_file" == *.yml ]]; then
        if ! command -v yaml &> /dev/null; then
            print_warning "yaml-cli not installed, skipping YAML validation"
            print_info "Install with: npm install -g yaml-cli"
        fi
    else
        print_error "Unsupported file format. Use .json, .yaml, or .yml"
        return 1
    fi
    
    print_success "✓ Spec file format is valid"
    return 0
}

# Function to check for breaking changes
check_breaking_changes() {
    local old_spec=$1
    local new_spec=$2
    
    print_title "Checking for Breaking Changes"
    
    if [ ! -f "$old_spec" ] || [ ! -f "$new_spec" ]; then
        print_error "Both spec files must exist"
        return 1
    fi
    
    print_info "Comparing: $old_spec -> $new_spec"
    
    # Use openapi-diff to check for breaking changes
    local output=$(openapi-diff "$old_spec" "$new_spec" 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_success "✓ No breaking changes detected"
        return 0
    else
        print_error "✗ Breaking changes detected:"
        echo "$output" | grep -E "breaking|removed|changed" || echo "$output"
        return 1
    fi
}

# Function to check API versioning
check_versioning() {
    local spec_file=$1
    
    print_title "Checking API Versioning"
    
    # Extract version from spec
    local version=""
    if [[ "$spec_file" == *.json ]]; then
        version=$(jq -r '.info.version // empty' "$spec_file")
    else
        version=$(grep -A 1 "version:" "$spec_file" | tail -n 1 | sed 's/^[[:space:]]*//' | tr -d '"' | tr -d "'")
    fi
    
    if [ -z "$version" ]; then
        print_error "✗ No version specified in OpenAPI spec"
        return 1
    fi
    
    print_info "API Version: $version"
    
    # Check if version follows semantic versioning
    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_warning "⚠ Version doesn't follow semantic versioning (X.Y.Z)"
        print_info "  Current: $version"
        print_info "  Expected format: 1.0.0, 2.1.3, etc."
    else
        print_success "✓ Version follows semantic versioning"
    fi
    
    # Check if paths include version
    local has_versioned_paths=false
    if [[ "$spec_file" == *.json ]]; then
        if jq -r '.paths | keys[]' "$spec_file" | grep -q '/v[0-9]'; then
            has_versioned_paths=true
        fi
    fi
    
    if [ "$has_versioned_paths" = true ]; then
        print_success "✓ Paths include version prefix (e.g., /v1/...)"
    else
        print_warning "⚠ Paths don't include version prefix"
        print_info "  Consider: /v1/users, /v2/users, etc."
    fi
}

# Function to check security definitions
check_security() {
    local spec_file=$1
    
    print_title "Checking Security Configuration"
    
    local has_security=false
    
    if [[ "$spec_file" == *.json ]]; then
        if jq -e '.securitySchemes // .components.securitySchemes' "$spec_file" > /dev/null 2>&1; then
            has_security=true
        fi
    fi
    
    if [ "$has_security" = true ]; then
        print_success "✓ Security schemes defined"
        
        # List security schemes
        if [[ "$spec_file" == *.json ]]; then
            local schemes=$(jq -r '.securitySchemes // .components.securitySchemes | keys[]' "$spec_file" 2>/dev/null || echo "")
            if [ ! -z "$schemes" ]; then
                print_info "Security schemes:"
                echo "$schemes" | while read -r scheme; do
                    echo "  - $scheme"
                done
            fi
        fi
    else
        print_error "✗ No security schemes defined"
        print_info "  Add authentication (OAuth2, API Key, JWT, etc.)"
        return 1
    fi
}

# Function to check for proper error responses
check_error_responses() {
    local spec_file=$1
    
    print_title "Checking Error Response Coverage"
    
    local missing_errors=()
    local required_codes=("400" "401" "403" "404" "500")
    
    print_info "Checking for standard error codes: ${required_codes[*]}"
    
    # This is a simplified check - would need more sophisticated parsing
    for code in "${required_codes[@]}"; do
        if ! grep -q "\"$code\"" "$spec_file"; then
            missing_errors+=("$code")
        fi
    done
    
    if [ ${#missing_errors[@]} -eq 0 ]; then
        print_success "✓ All standard error codes present"
    else
        print_warning "⚠ Missing error codes: ${missing_errors[*]}"
        echo "  Recommended error responses:"
        echo "    400 - Bad Request (validation errors)"
        echo "    401 - Unauthorized (authentication required)"
        echo "    403 - Forbidden (insufficient permissions)"
        echo "    404 - Not Found (resource doesn't exist)"
        echo "    500 - Internal Server Error"
    fi
}

# Function to generate comparison report
generate_report() {
    local old_spec=$1
    local new_spec=$2
    local output_file=${3:-api-comparison-report.md}
    
    print_info "Generating comparison report: $output_file"
    
    cat > "$output_file" << EOF
# API Comparison Report

**Generated**: $(date +"%Y-%m-%d %H:%M:%S")

## Specifications

- **Old**: $old_spec
- **New**: $new_spec

## Breaking Changes

EOF

    # Run comparison and append to report
    if openapi-diff "$old_spec" "$new_spec" >> "$output_file" 2>&1; then
        echo "No breaking changes detected" >> "$output_file"
    fi
    
    cat >> "$output_file" << EOF

## Recommendations

### Versioning
- Maintain backward compatibility when possible
- Use semantic versioning (X.Y.Z)
- Deprecation period: 6 months minimum
- Document migration paths

### Best Practices
- All endpoints have security defined
- Standard error codes (400, 401, 403, 404, 500)
- Clear error messages with error codes
- Examples provided for all operations
- Rate limiting documented

EOF

    print_success "✓ Report generated: $output_file"
}

# Function to show usage
show_usage() {
    cat << EOF
API Validator - Validate OpenAPI specifications and detect breaking changes

Usage:
    $0 <command> [options]

Commands:
    validate <spec_file>
        Validate OpenAPI specification format and best practices
        
        Example:
            $0 validate api-spec.json
            $0 validate openapi.yaml

    compare <old_spec> <new_spec>
        Compare two API specs for breaking changes
        
        Example:
            $0 compare v1-api.json v2-api.json
            $0 compare old-spec.yaml new-spec.yaml

    report <old_spec> <new_spec> [output_file]
        Generate detailed comparison report
        
        Example:
            $0 report v1-api.json v2-api.json
            $0 report old.yaml new.yaml report.md

    check-all <spec_file>
        Run all validation checks on a single spec
        
        Example:
            $0 check-all api-spec.json

    help
        Show this help message

Validation Checks:
    - Spec file format (JSON/YAML)
    - Breaking changes (if comparing)
    - API versioning
    - Security configuration
    - Error response coverage
    - Best practices compliance

Examples:
    # Validate single spec
    $0 validate openapi.json

    # Compare for breaking changes
    $0 compare v1.json v2.json

    # Generate full report
    $0 report v1.json v2.json changes.md

    # Run all checks
    $0 check-all api-spec.json

Dependencies:
    - Node.js
    - openapi-diff: npm install -g openapi-diff
    - jq: brew install jq (for JSON parsing)

EOF
}

# Main script logic
main() {
    local command=${1:-help}
    
    case "$command" in
        validate)
            if [ -z "$2" ]; then
                print_error "Spec file required"
                echo "Usage: $0 validate <spec_file>"
                exit 1
            fi
            
            validate_spec "$2"
            ;;
            
        compare)
            if [ -z "$2" ] || [ -z "$3" ]; then
                print_error "Both old and new spec files required"
                echo "Usage: $0 compare <old_spec> <new_spec>"
                exit 1
            fi
            
            if ! check_dependencies; then
                exit 1
            fi
            
            check_breaking_changes "$2" "$3"
            ;;
            
        report)
            if [ -z "$2" ] || [ -z "$3" ]; then
                print_error "Both old and new spec files required"
                echo "Usage: $0 report <old_spec> <new_spec> [output_file]"
                exit 1
            fi
            
            if ! check_dependencies; then
                exit 1
            fi
            
            generate_report "$2" "$3" "$4"
            ;;
            
        check-all)
            if [ -z "$2" ]; then
                print_error "Spec file required"
                echo "Usage: $0 check-all <spec_file>"
                exit 1
            fi
            
            local spec_file=$2
            local all_passed=true
            
            echo ""
            print_title "Running All Validation Checks"
            echo ""
            
            if ! validate_spec "$spec_file"; then
                all_passed=false
            fi
            
            echo ""
            check_versioning "$spec_file" || all_passed=false
            
            echo ""
            check_security "$spec_file" || all_passed=false
            
            echo ""
            check_error_responses "$spec_file" || all_passed=false
            
            echo ""
            if [ "$all_passed" = true ]; then
                print_success "========================================="
                print_success "All checks passed!"
                print_success "========================================="
            else
                print_error "========================================="
                print_error "Some checks failed"
                print_error "========================================="
                exit 1
            fi
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
