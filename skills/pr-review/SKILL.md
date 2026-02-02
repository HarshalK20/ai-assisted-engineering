---
name: pr-review
description: Scans pull requests for architectural drift, risks, and maintenance concerns with comprehensive quality analysis. Use when reviewing PRs, examining code changes, or when the user mentions pull request review, code review, or quality assessment.
---

# PR Review Intelligence

## Purpose

Scan pull requests for architectural drift, risks, and maintenance concerns beyond surface-level issues.

## When to Use

- During code review process
- For large or complex PRs (> 500 lines)
- When reviewing unfamiliar code or domains
- For critical path changes (auth, payment, core business logic)
- When evaluating junior developer PRs for mentoring
- Before approving changes to production code

## Review Dimensions

### 1. Correctness

Does it work as intended?

```markdown
Check for:
- [ ] Logic errors (off-by-one, wrong operators)
- [ ] Edge cases handled (null, empty, boundary values)
- [ ] Error conditions caught
- [ ] Race conditions in concurrent code
- [ ] Resource leaks (connections, file handles)
- [ ] Infinite loops or recursion without base case
```

### 2. Architecture Fit

Does it align with system design?

```markdown
Questions:
- Does this follow established patterns?
- Is it in the right layer? (UI logic in backend?)
- Does it respect bounded contexts?
- Are dependencies pointing in the right direction?
- Does it introduce circular dependencies?
- Is it consistent with existing abstractions?
```

### 3. Scalability

Will it work at 10x, 100x scale?

```markdown
Red flags:
🚩 Loading entire table into memory
🚩 N+1 queries
🚩 No pagination on list endpoints
🚩 Unbounded loops
🚩 No caching for expensive operations
🚩 Synchronous processing of large batches
🚩 No rate limiting on public endpoints
```

### 4. Testing

Are tests adequate?

```markdown
Assess:
- [ ] Happy path tested
- [ ] Edge cases tested (null, empty, max)
- [ ] Error cases tested
- [ ] Coverage for business logic > 80%
- [ ] Tests are readable (clear arrange/act/assert)
- [ ] Tests are reliable (not flaky)
- [ ] Mock external dependencies
- [ ] Integration tests for API contracts
```

### 5. Maintainability

Can someone else work with this?

```markdown
Check:
- [ ] Functions under 50 lines
- [ ] Clear variable/function names
- [ ] Complex logic has comments
- [ ] No magic numbers (extract to constants)
- [ ] Consistent naming conventions
- [ ] No code duplication
- [ ] Appropriate abstraction level
```

### 6. Security

Are there vulnerabilities?

```markdown
Common issues:
- [ ] SQL injection (using string interpolation)
- [ ] XSS (unescaped output)
- [ ] Missing authentication checks
- [ ] Missing authorization checks
- [ ] Sensitive data in logs
- [ ] Secrets hardcoded
- [ ] Insecure cryptography
- [ ] CSRF protection missing
- [ ] Mass assignment vulnerabilities
```

## PR Review Process

### Step 1: Understand Context

Before diving into code:

```markdown
Read:
- [ ] PR title and description
- [ ] Linked tickets/issues
- [ ] Related PRs
- [ ] Discussion comments

Understand:
- What problem does this solve?
- Why this approach?
- What's the expected behavior?
```

### Step 2: High-Level Review

Start big, then zoom in:

```markdown
1. Review file list (what changed?)
2. Check test files (do tests match changes?)
3. Look for unexpected changes (config, deps)
4. Identify risky areas (auth, payment, data)
5. Check PR size (> 500 lines = hard to review)
```

### Step 3: Detailed Review

Line-by-line analysis:

```markdown
For each file:
- Does it do what PR description says?
- Are there simpler ways?
- What could go wrong?
- Are all paths tested?
- Is error handling complete?
```

### Step 4: Run Code Locally

Don't just read, test:

```bash
# Checkout PR
git fetch origin pull/123/head:pr-123
git checkout pr-123

# Install dependencies
npm install  # or pip install, etc.

# Run tests
npm test

# Run linter
npm run lint

# Test manually
npm start
# Try feature, try to break it
```

### Step 5: Leave Feedback

Structured, actionable comments:

```markdown
Format: [Category] Description → Suggestion

Examples:
🔴 [Security] SQL injection vulnerability → Use parameterized query
🟡 [Performance] N+1 query → Use JOIN or prefetch
🟢 [Style] Inconsistent naming → Rename to match convention
💡 [Suggestion] Consider caching here → Could improve performance
❓ [Question] Why this approach? → Help me understand rationale
```

## Feedback Framework

### 1. Conventional Comments

Prefix comments with type:

```markdown
**praise**: 👍 Love this pattern! Very clean.

**nitpick**: Variable name could be more descriptive (minor)

**suggestion**: Consider extracting this to a helper function

**issue**: This will fail when input is null

**question**: Why did you choose this approach over X?

**thought**: This might not scale well under high load

**chore**: Missing a test for the error case
```

### 2. Severity Levels

Indicate urgency:

```markdown
🔴 **Blocking** (must fix before merge):
- Security vulnerabilities
- Critical bugs
- Breaking changes without migration

🟡 **Important** (should fix before merge):
- Performance issues
- Missing tests for critical logic
- Architectural deviations

🟢 **Minor** (can fix later or ignore):
- Style nitpicks
- Optional optimizations
- Non-critical refactoring
```

### 3. The Praise Sandwich

```markdown
❌ Bad:
"This function is too long and confusing."

✅ Better:
"Good use of async/await! This function could be easier to understand if 
we extracted the validation logic into a separate function. The error 
handling is well done."
```

## Example PR Review

### PR: Add User Email Verification

**Files changed**: 8 files, +320 -45 lines

### Review Comments

#### File: `auth/verify_email.py`

```python
# Line 23
def verify_email(token: str) -> bool:
    user = db.query(f"SELECT * FROM users WHERE token = '{token}'")
    if user:
        user.email_verified = True
        db.save(user)
        return True
    return False
```

**Comments**:

```markdown
🔴 **[Security]** SQL injection vulnerability (line 23)
The token parameter is directly interpolated into the SQL query. An attacker 
could inject malicious SQL.

**Fix**:
\`\`\`python
user = db.query("SELECT * FROM users WHERE token = %s", (token,))
\`\`\`

🟡 **[Issue]** Race condition possible (line 24-26)
If two requests verify the same token simultaneously, both might succeed. 
Consider using a database transaction with SELECT FOR UPDATE.

🟡 **[Missing Test]** No test for expired tokens
What happens if the token is valid but expired? Need to check expiry.

💡 **[Suggestion]** Add logging
Should log successful verifications for audit trail:
\`\`\`python
logger.info(f"Email verified for user {user.id}")
\`\`\`
```

#### File: `auth/tests/test_verify_email.py`

```python
def test_verify_email():
    token = "test_token_123"
    result = verify_email(token)
    assert result == True
```

**Comments**:

```markdown
🟡 **[Testing]** Missing test cases
Current tests only cover happy path. Need tests for:
- Invalid token (should return False)
- Expired token (should return False)
- Already verified email (idempotency)
- SQL injection attempt
- Null/empty token

🟢 **[Nitpick]** Use `assert result` instead of `assert result == True`
More Pythonic and handles truthy values.
```

#### File: `requirements.txt`

```diff
+ requests==2.28.0
```

**Comments**:

```markdown
❓ **[Question]** Why add requests library?
Don't see it used in the changes. Was this needed for something? If not, 
please remove to avoid unnecessary dependencies.
```

#### Overall Feedback

```markdown
## Summary
Good start on email verification! A few critical security issues to address 
before we can merge.

## Must Fix Before Merge
1. 🔴 SQL injection vulnerability (auth/verify_email.py:23)
2. 🟡 Add test cases for edge cases
3. 🟡 Handle token expiration

## Suggestions for Follow-up PR
- Add rate limiting on verification endpoint (prevent brute force)
- Send confirmation email after successful verification
- Consider using JWT tokens instead of random strings

## Approval Status
**Request Changes** ⚠️

Once the security issue and tests are addressed, this will be ready to merge!
```

## PR Size Guidelines

### Size Categories

```markdown
**Tiny** (< 50 lines):
- Quick review (5-10 min)
- Easy to understand
- Low risk

**Small** (50-200 lines):
- Moderate review (15-30 min)
- Focused change
- Acceptable

**Medium** (200-500 lines):
- Thorough review needed (30-60 min)
- Should be focused on single feature
- Consider splitting if possible

**Large** (500-1000 lines):
- Difficult to review (1-2 hours)
- High chance of missing issues
- Should be split unless unavoidable

**Huge** (> 1000 lines):
- Nearly impossible to review thoroughly
- High risk of bugs sneaking through
- MUST be split (except auto-generated code)
```

### When to Request Splitting

```markdown
Request split if:
- [ ] Multiple independent features
- [ ] Refactoring + feature in same PR
- [ ] Touches many different subsystems
- [ ] > 1000 lines of hand-written code

Exceptions (don't split):
- Auto-generated code (OpenAPI, protobuf)
- Large data files (migrations, fixtures)
- Renaming/moving files (git detects as new)
```

## Architectural Red Flags

Watch for these patterns:

### Anti-Patterns

```markdown
🚩 **God Class**: Class with > 500 lines or > 20 methods
→ Suggest: Split by responsibility

🚩 **Shotgun Surgery**: Small change affects 10+ files
→ Suggests: Poor abstraction, tight coupling

🚩 **Magic Numbers**: Hardcoded values without explanation
→ Suggest: Extract to named constants

🚩 **Deep Nesting**: > 3 levels of if/else or loops
→ Suggest: Extract to functions, use early returns

🚩 **Long Parameter List**: Function with > 5 parameters
→ Suggest: Use parameter object or builder pattern

🚩 **Feature Envy**: Class accessing another class's data more than its own
→ Suggest: Move method to appropriate class

🚩 **Primitive Obsession**: Using primitives instead of small objects
→ Suggest: Create value objects (Email, Money, etc.)
```

### Architecture Violations

```markdown
⚠️ **Layer Violation**: UI code in database layer
⚠️ **Circular Dependency**: Service A depends on B, B depends on A
⚠️ **Dependency Inversion**: High-level module depends on low-level detail
⚠️ **Single Responsibility**: Class doing multiple unrelated things
⚠️ **Tight Coupling**: Can't test without entire system
```

## Review Checklist Template

```markdown
## PR Review Checklist

### Functionality
- [ ] Changes match PR description
- [ ] No unrelated changes
- [ ] Edge cases handled
- [ ] Error handling complete

### Code Quality
- [ ] Readable and maintainable
- [ ] Follows project conventions
- [ ] No code duplication
- [ ] Appropriate abstractions

### Testing
- [ ] Tests added/updated
- [ ] Tests cover edge cases
- [ ] Tests are reliable
- [ ] Coverage adequate

### Security
- [ ] Input validation
- [ ] Authentication/authorization checked
- [ ] No SQL injection
- [ ] No XSS vulnerabilities
- [ ] No secrets in code

### Performance
- [ ] No obvious bottlenecks
- [ ] Appropriate caching
- [ ] Queries optimized
- [ ] No N+1 queries

### Architecture
- [ ] Fits existing patterns
- [ ] Respects layer boundaries
- [ ] No circular dependencies
- [ ] Scales appropriately

### Observability
- [ ] Errors logged
- [ ] Important actions logged
- [ ] Metrics added (if needed)

### Documentation
- [ ] Comments where needed
- [ ] API docs updated
- [ ] README updated (if needed)

## Decision
[ ] Approve ✅
[ ] Request Changes ⚠️
[ ] Comment (no blocking issues) 💬
```

## Resources

### Code Review Best Practices
- [Google Code Review Guide](https://google.github.io/eng-practices/review/)
- [Conventional Comments](https://conventionalcomments.org/)
- [Code Review Etiquette](https://phauer.com/2018/code-review-guidelines/)

### Security
- [OWASP Code Review Guide](https://owasp.org/www-pdf-archive/OWASP_Code_Review_Guide_v2.pdf)
- [Common Vulnerability Types](https://owasp.org/www-project-top-ten/)

### Tools
- [Danger JS](https://danger.systems/js/) - Automate PR checks
- [CodeClimate](https://codeclimate.com/) - Automated code review
- [SonarQube](https://www.sonarqube.org/) - Code quality analysis

## Quick Reference

### Review Priority

1. **Security** (critical vulnerabilities)
2. **Correctness** (bugs, logic errors)
3. **Architecture** (doesn't fit design)
4. **Testing** (inadequate coverage)
5. **Performance** (obvious bottlenecks)
6. **Maintainability** (hard to understand)
7. **Style** (formatting, naming)

### Comment Types

- 🔴 Blocking issue (must fix)
- 🟡 Important issue (should fix)
- 🟢 Minor issue (optional)
- 💡 Suggestion (consider)
- ❓ Question (clarify)
- 👍 Praise (good work!)

### Review Time Budget

- Small PR (< 200 lines): 15-30 min
- Medium PR (200-500 lines): 30-60 min
- Large PR (> 500 lines): 1-2 hours
  - If longer, request split
