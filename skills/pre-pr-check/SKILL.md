---
name: pre-pr-check
description: Validates changes against pre-PR checklist before submission to ensure quality and completeness. Use when about to create a PR, wrapping up development, or when the user mentions PR readiness, submission checklist, or quality gates.
---

# Pre-PR Readiness Check

## Purpose

Validate changes against comprehensive checklist before creating PR, ensuring quality and reducing review cycles.

## When to Use

- Before creating a pull request
- During local development wrap-up phase
- As part of pre-commit hooks (automated)
- Before requesting code review
- To ensure CI/CD will pass

## Pre-PR Checklist

### 1. Code Complete

```markdown
- [ ] All planned changes implemented
- [ ] No work-in-progress (WIP) code
- [ ] No commented-out code blocks
- [ ] No debug code (console.log, print statements)
- [ ] No TODO comments without linked tickets
- [ ] Meets acceptance criteria from ticket
```

### 2. Tests Added/Updated

```markdown
- [ ] Unit tests for new business logic
- [ ] Integration tests for new API endpoints
- [ ] Tests for edge cases (null, empty, max values)
- [ ] Tests for error scenarios
- [ ] All existing tests still pass
- [ ] No flaky tests (run 3x to verify)
- [ ] Test coverage > 80% for new code
- [ ] Tests are readable (clear arrange/act/assert)
```

### 3. Code Quality

```markdown
- [ ] Clear, descriptive names (no x, tmp, data)
- [ ] Functions under 50 lines
- [ ] No code duplication
- [ ] Magic numbers extracted to constants
- [ ] Complex logic has comments
- [ ] Follows team coding standards
- [ ] No linter warnings
- [ ] Type hints/annotations added (if applicable)
```

### 4. Security Review

```markdown
- [ ] Input validation on all user inputs
- [ ] No SQL injection (use parameterized queries)
- [ ] No XSS (escape output properly)
- [ ] Authentication checked for protected endpoints
- [ ] Authorization verified (user can access resource?)
- [ ] No secrets in code (use env variables)
- [ ] Sensitive data not logged
- [ ] Rate limiting for public endpoints
- [ ] CSRF protection on state-changing operations
```

### 5. Performance Check

```markdown
- [ ] No N+1 queries
- [ ] Database queries use indexes
- [ ] No unbounded loops
- [ ] Appropriate caching
- [ ] Memory leaks prevented
- [ ] No blocking operations in critical path
- [ ] Resource cleanup (connections, file handles)
```

### 6. Error Handling

```markdown
- [ ] All exceptions caught and handled
- [ ] Errors logged with context
- [ ] User-facing error messages are clear
- [ ] Partial failures handled gracefully
- [ ] Retry logic for transient failures
- [ ] Circuit breaker for external services
- [ ] Timeout set for network calls
```

### 7. Observability

```markdown
- [ ] Important operations logged
- [ ] Errors logged with stack traces
- [ ] Metrics for key operations (if applicable)
- [ ] Correlation IDs passed through
- [ ] No PII/secrets in logs
- [ ] Appropriate log levels used
```

### 8. Backward Compatibility

```markdown
- [ ] No breaking API changes (or documented)
- [ ] Database migrations safe (backward compatible)
- [ ] Feature flags for risky changes
- [ ] Rollback plan documented
- [ ] No removed endpoints without deprecation
```

### 9. Documentation

```markdown
- [ ] Code comments where logic is complex
- [ ] API docs updated (OpenAPI, JSDoc, etc.)
- [ ] README updated if needed
- [ ] CHANGELOG entry added
- [ ] Migration guide (if breaking changes)
- [ ] Architecture docs updated (if design changed)
```

### 10. Dependencies

```markdown
- [ ] New dependencies justified
- [ ] No known vulnerabilities (npm audit, pip-audit)
- [ ] Licenses compatible with project
- [ ] Dependency versions pinned
- [ ] Lock file updated (package-lock.json, Pipfile.lock)
```

## Automated Checks

### Run Before Creating PR

```bash
# 1. Run linter
npm run lint          # JavaScript/TypeScript
pylint src/           # Python
rubocop               # Ruby

# 2. Run formatter
npm run format        # Prettier
black src/            # Python
gofmt -w .            # Go

# 3. Run tests
npm test              # JavaScript
pytest                # Python
go test ./...         # Go

# 4. Check coverage
npm test -- --coverage
pytest --cov=src --cov-report=html

# 5. Security scan
npm audit
pip-audit
snyk test

# 6. Type check
tsc --noEmit          # TypeScript
mypy src/             # Python
flow check            # Flow

# 7. Build (ensure no errors)
npm run build
python setup.py build

# 8. Run locally
npm start             # Test manually
# Try to break your changes!
```

### Git Pre-Commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Running pre-commit checks..."

# Run linter
echo "Linting..."
npm run lint || exit 1

# Run tests
echo "Testing..."
npm test || exit 1

# Check for secrets
echo "Checking for secrets..."
if git diff --cached | grep -i "password\|secret\|api_key\|private_key"; then
    echo "⚠️  Possible secret detected! Please review."
    exit 1
fi

# Check for debug code
echo "Checking for debug code..."
if git diff --cached | grep -i "console.log\|debugger\|TODO\|FIXME"; then
    echo "⚠️  Debug code or TODOs found! Please clean up."
    exit 1
fi

echo "✅ Pre-commit checks passed!"
```

## PR Description Template

Use this template when creating PR:

```markdown
## Description
[Describe what this PR does and why]

## Changes
- [Specific change 1]
- [Specific change 2]
- [Specific change 3]

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to break)
- [ ] Refactoring (no functional changes)
- [ ] Documentation update
- [ ] Performance improvement

## Testing
[How was this tested?]
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed
- [ ] Tested edge cases

## Screenshots (if applicable)
[Add screenshots showing UI changes]

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-reviewed code
- [ ] Commented complex logic
- [ ] Updated documentation
- [ ] Tests added covering changes
- [ ] All tests passing
- [ ] No linter warnings
- [ ] Checked for breaking changes
- [ ] Updated CHANGELOG (if needed)

## Related Issues
Closes #[issue number]
Related to #[issue number]

## Rollback Plan
[How to rollback if this causes issues]

## Deployment Notes
[Special deployment considerations, if any]
```

## Self-Review Before PR

### Review Your Own Diff

```bash
# View changes in diff tool
git diff main...HEAD

# Or use GitHub CLI
gh pr diff

# Review each file:
# - Does every change have a purpose?
# - Any accidental changes?
# - Any debug code left in?
# - Any commented-out code?
# - Any formatting-only changes in unrelated files?
```

### Questions to Ask Yourself

```markdown
Functionality:
□ Does this solve the problem?
□ Are all acceptance criteria met?
□ Did I test the happy path?
□ Did I test error cases?
□ What happens if this fails?

Code Quality:
□ Is this the simplest solution?
□ Can I understand this in 6 months?
□ Would a junior developer understand this?
□ Is there duplicated code?
□ Are names clear and descriptive?

Risk:
□ What could go wrong?
□ Will this scale?
□ Are there security implications?
□ Could this break existing functionality?
□ What's the rollback plan?

Team:
□ Follows team conventions?
□ Matches existing patterns?
□ Would I approve this PR if I didn't write it?
```

## Scope Creep Check

### PR Scope Should Be Focused

```markdown
✅ Good PR scope:
- Single feature or bug fix
- Related changes grouped together
- Clear purpose from title

❌ Bad PR scope (should split):
- Multiple unrelated features
- Bug fix + refactoring + new feature
- Changes across many subsystems
- "While I was here" additions

Exception: Large refactoring
- Must touch many files
- Document approach in PR description
- Consider breaking into smaller PRs
```

### Files Changed Review

```markdown
Expected changes:
✅ Source files implementing feature
✅ Test files for new/modified code
✅ Documentation updates
✅ Dependencies if justified

Unexpected changes (investigate):
⚠️ Config files (unless needed)
⚠️ Unrelated files
⚠️ Whitespace changes in many files
⚠️ Dependency version bumps (unless necessary)
⚠️ Auto-generated files (can commit separately)
```

## Common Pre-PR Mistakes

### 1. Forgetting to Add Files

```bash
# Check for untracked files
git status

# Common forgotten files:
# - New test files
# - New migration files
# - Updated lock files (package-lock.json)
```

### 2. Committing Debug Code

```bash
# Search for debug statements
git diff main | grep -i "console.log\|debugger\|print("

# Or use pre-commit hook to prevent
```

### 3. Mixing Concerns

```markdown
❌ Bad: Bug fix + refactoring + new feature in one PR
✅ Good: Three separate PRs

Why? Easier to review, easier to rollback, clearer history
```

### 4. Missing Tests

```markdown
❌ "It works on my machine" without tests
✅ Tests demonstrating it works

Golden rule: If it's not tested, it's broken
```

### 5. Vague PR Description

```markdown
❌ Bad:
Title: "Fix bug"
Description: "Fixed the issue"

✅ Good:
Title: "Fix null pointer error in user profile"
Description: "Handle case where user has no email set. 
Added null check and test case. Fixes #123"
```

## PR Size Management

### Target Size

```markdown
Ideal: < 400 lines changed
Acceptable: < 800 lines
Large: < 1500 lines (needs extra care)
Too large: > 1500 lines (split if possible)

Exceptions:
- Auto-generated code (OpenAPI, migrations)
- Moving/renaming files (git sees as new)
- Large data files
```

### How to Split Large PRs

```markdown
Strategy 1: By feature
- PR 1: Core functionality
- PR 2: Edge cases and error handling
- PR 3: UI polish and docs

Strategy 2: By layer
- PR 1: Database and models
- PR 2: Business logic
- PR 3: API endpoints
- PR 4: Frontend

Strategy 3: Preparation + Implementation
- PR 1: Refactoring/setup (backward compatible)
- PR 2: New feature using refactored code
```

## Pre-PR Automation

### GitHub Actions Example

```yaml
name: Pre-PR Checks

on:
  push:
    branches-ignore:
      - main

jobs:
  checks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: 18
      
      - name: Install dependencies
        run: npm ci
      
      - name: Lint
        run: npm run lint
      
      - name: Type check
        run: npm run type-check
      
      - name: Unit tests
        run: npm test
      
      - name: Coverage check
        run: npm test -- --coverage --coverageThreshold='{"global":{"branches":80,"functions":80,"lines":80,"statements":80}}'
      
      - name: Security audit
        run: npm audit --audit-level=moderate
      
      - name: Build
        run: npm run build
```

## Resources

### PR Best Practices
- [Google Code Review Guidelines](https://google.github.io/eng-practices/review/)
- [PR Template Generator](https://www.talater.com/open-source-templates/)
- [Conventional Commits](https://www.conventionalcommits.org/)

### Tools
- [Danger JS](https://danger.systems/js/) - PR automation
- [Husky](https://typicode.github.io/husky/) - Git hooks
- [lint-staged](https://github.com/okonet/lint-staged) - Run linters on staged files

## Quick Reference

### Before Creating PR

```bash
# 1. Self-review
git diff main...HEAD

# 2. Run checks
npm run lint && npm test && npm run build

# 3. Security scan
npm audit

# 4. Check coverage
npm test -- --coverage

# 5. Manual testing
npm start
# Test your changes thoroughly

# 6. Clean up
# Remove debug code, TODOs, commented code

# 7. Descriptive commits
git commit -m "feat: add user email verification"

# 8. Push
git push origin feature-branch

# 9. Create PR with template
gh pr create --template
```

### Red Flags (Don't Create PR Yet)

- 🚨 Tests failing
- 🚨 Linter errors
- 🚨 Build fails
- 🚨 Security vulnerabilities
- 🚨 Debug code still present
- 🚨 No tests for changes
- 🚨 Breaking changes without plan
- 🚨 > 1500 lines (consider splitting)
