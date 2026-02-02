# Code Quality Standards

This document defines code quality standards, review processes, and testing expectations.

## Code Review Standards

### Review Checklist

Every PR must be reviewed for:

#### 1. Correctness
- [ ] Logic is correct for all inputs
- [ ] Edge cases handled (null, empty, boundary values)
- [ ] Error conditions caught and handled appropriately
- [ ] No off-by-one errors
- [ ] Concurrency issues addressed (if applicable)

#### 2. Testing
- [ ] Unit tests for business logic (>80% coverage)
- [ ] Integration tests for API endpoints
- [ ] Edge case tests (null, empty, max values)
- [ ] Error case tests
- [ ] Tests are reliable (not flaky)
- [ ] Tests are readable (clear arrange/act/assert)

#### 3. Security
- [ ] Input validation on all user inputs
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (escaped output)
- [ ] Authentication required for protected endpoints
- [ ] Authorization checked (user can access resource)
- [ ] No secrets in code (use environment variables)
- [ ] Sensitive data not logged (passwords, tokens, PII)

#### 4. Performance
- [ ] No N+1 queries
- [ ] Database queries use appropriate indexes
- [ ] No unbounded loops or recursion
- [ ] Appropriate caching where needed
- [ ] Memory leaks prevented (cleanup resources)
- [ ] No blocking operations in critical path

#### 5. Maintainability
- [ ] Functions under 50 lines
- [ ] Clear, descriptive naming
- [ ] Complex logic has comments
- [ ] No magic numbers (extract to constants)
- [ ] Consistent with existing patterns
- [ ] No code duplication
- [ ] Appropriate abstraction level

#### 6. Code Style
- [ ] Follows team style guide
- [ ] No linter warnings
- [ ] Consistent formatting
- [ ] Type annotations present (if applicable)

### Review Response Time

- **Urgent**: < 2 hours
- **Normal**: < 24 hours
- **Large PR (>500 lines)**: < 48 hours

### PR Size Guidelines

- **Small** (< 200 lines): Ideal, easy to review
- **Medium** (200-500 lines): Acceptable if focused
- **Large** (500-1000 lines): Should be split if possible
- **Huge** (>1000 lines): Must be split (except auto-generated code)

### Approval Requirements

- **Standard PR**: 1 approval
- **Critical changes** (auth, payment, core logic): 2 approvals
- **Breaking changes**: Tech lead approval
- **Infrastructure changes**: Platform team approval

## Coding Standards

### Naming Conventions

```markdown
**Variables**:
- Use descriptive names (not x, tmp, data)
- Boolean: is/has/can prefix (isValid, hasPermission)
- Arrays/collections: plural (users, items)
- Constants: UPPER_SNAKE_CASE

**Functions**:
- Verb + noun (getUserById, calculateTotal)
- Descriptive of what they do
- No side effects in getter functions

**Classes**:
- Noun, PascalCase (UserService, OrderController)
- Single responsibility

**Files**:
- Match class/component name
- kebab-case for file names (user-service.ts)
```

### Function Guidelines

```markdown
**Size**: < 50 lines (ideally < 20)
**Parameters**: < 5 parameters (use object if more)
**Single purpose**: Function does one thing well
**No side effects**: Unless clearly named (e.g., saveUser)
**Return early**: Use guard clauses, avoid deep nesting
```

### Error Handling

```markdown
**Never swallow errors**:
❌ try { } catch (e) { }
✅ try { } catch (e) { logger.error(e); throw; }

**Specific exceptions**:
❌ catch (Exception e)
✅ catch (UserNotFoundException e)

**User-facing messages**:
❌ return "Error: NPE at line 42"
✅ return "User not found. Please check the ID and try again"

**Logging**:
- Log all errors with stack traces
- Include context (userId, requestId, etc.)
- Never log secrets or PII
```

### Comments

```markdown
**When to comment**:
- Complex algorithms (explain why, not what)
- Non-obvious behavior or workarounds
- Security considerations
- Performance optimizations
- TODOs (with ticket reference)

**When NOT to comment**:
- Obvious code (name explains it)
- What the code does (code shows that)
- Version history (use git)
- Commented-out code (delete it)
```

## Testing Standards

### Test Pyramid

- **70% Unit tests**: Fast, focused on logic
- **20% Integration tests**: API endpoints, database
- **10% E2E tests**: Critical user journeys

### Test Coverage Targets

```markdown
**Critical components** (95%+):
- Authentication/Authorization
- Payment processing
- Data integrity (financial, health, PII)

**Important components** (80-95%):
- Core business logic
- API endpoints
- Database operations

**Standard components** (70-80%):
- UI components
- Utilities
- Helper functions
```

### Test Structure

```javascript
// Arrange-Act-Assert pattern
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', () => {
      // Arrange
      const userData = { email: 'test@example.com', name: 'Test' };
      
      // Act
      const user = userService.createUser(userData);
      
      // Assert
      expect(user.id).toBeDefined();
      expect(user.email).toBe('test@example.com');
    });
  });
});
```

### Test Best Practices

- **Isolated**: Each test independent (no shared state)
- **Fast**: Unit tests < 1s total, integration < 10s
- **Reliable**: No flaky tests (use deterministic data)
- **Clear names**: Test name describes what's tested
- **One assertion focus**: Test one thing (or related things)
- **Readable**: Easy to understand test purpose

## API Standards

### REST API Conventions

```markdown
**HTTP Methods**:
- GET: Read (idempotent, no side effects)
- POST: Create (not idempotent)
- PUT: Full update (idempotent)
- PATCH: Partial update
- DELETE: Delete (idempotent)

**Status Codes**:
- 200 OK: Successful GET/PUT/PATCH
- 201 Created: Successful POST
- 204 No Content: Successful DELETE
- 400 Bad Request: Invalid input
- 401 Unauthorized: Not authenticated
- 403 Forbidden: Not authorized
- 404 Not Found: Resource doesn't exist
- 409 Conflict: Duplicate or concurrent edit
- 429 Too Many Requests: Rate limit exceeded
- 500 Internal Server Error: Server error
- 503 Service Unavailable: Temporarily down

**Naming**:
- Use nouns, not verbs (/users not /getUsers)
- Plural nouns (/users not /user)
- Kebab-case (/user-profiles not /userProfiles)
- Nested resources (/users/123/orders)

**Versioning**:
- URL versioning: /v1/users, /v2/users
- Major version only (v1, v2, not v1.1)
- Deprecation period: 6 months minimum
```

### API Response Format

```json
{
  "data": {
    "id": "123",
    "name": "John Doe",
    "email": "john@example.com"
  },
  "meta": {
    "requestId": "req_abc123",
    "timestamp": "2026-02-02T10:30:00Z"
  }
}
```

### Error Response Format

```json
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with ID 123 not found",
    "details": {
      "userId": "123",
      "suggestedAction": "Verify the user ID and try again"
    },
    "timestamp": "2026-02-02T10:30:00Z",
    "requestId": "req_abc123"
  }
}
```

## Database Standards

### Schema Design

- Use foreign keys to enforce referential integrity
- Add indexes for commonly queried columns
- Use appropriate column types (not all VARCHAR)
- Avoid nullable columns when possible (use defaults)
- Include created_at and updated_at timestamps
- Use UUIDs for public IDs (not sequential integers)

### Query Guidelines

```markdown
**Always**:
- Use parameterized queries (prevent SQL injection)
- Add indexes for WHERE, JOIN, ORDER BY columns
- Limit results (use pagination)
- Use transactions for multi-table operations
- Handle connection failures gracefully

**Never**:
- SELECT * (specify columns)
- String interpolation in queries (SQL injection risk)
- Unbounded queries (always limit)
- N+1 queries (use JOINs or batch loading)
```

### Migration Standards

```markdown
**Requirements**:
- Migrations are reversible (write down migration)
- Test on copy of production data
- Backward compatible (old code works with new schema)
- Include rollback procedure
- Document any manual steps

**Naming**:
YYYYMMDDHHMMSS_descriptive_name.sql
Example: 20260202103000_add_email_verification.sql
```

## Git Standards

### Commit Messages

Format: `<type>(<scope>): <subject>`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting (no code change)
- `refactor`: Code change (no behavior change)
- `test`: Adding tests
- `chore`: Maintenance (deps, config)

Examples:
```
feat(auth): add email verification
fix(orders): handle null payment method
docs(api): update endpoint documentation
refactor(users): extract validation logic
```

### Branch Naming

```
<type>/<short-description>

Examples:
feature/email-verification
bugfix/null-pointer-in-orders
hotfix/security-vulnerability
refactor/extract-user-validation
```

### PR Guidelines

```markdown
**Title**: Clear, descriptive (same as commit message format)
**Description**: 
- What changed and why
- Link to ticket/issue
- Testing done
- Screenshots (for UI changes)

**Size**: < 400 lines ideal (split if larger)
**Review**: Request from appropriate reviewer
**CI**: All checks must pass before merge
```

## Security Standards

### Input Validation

```markdown
- Validate all user inputs (type, format, range)
- Whitelist, don't blacklist
- Sanitize before use (escape for context)
- Reject invalid input (don't try to fix it)
```

### Authentication

```markdown
- Use industry standards (OAuth2, OIDC, JWT)
- Hash passwords (bcrypt, Argon2) - never plain text
- Implement rate limiting on auth endpoints
- Use secure session management
- Implement MFA for admin accounts
```

### Authorization

```markdown
- Check authorization at every endpoint
- Implement RBAC (Role-Based Access Control)
- Principle of least privilege
- Never trust client-side authorization
```

### Data Protection

```markdown
- Encrypt sensitive data at rest (AES-256)
- Use TLS 1.3+ for data in transit
- Never log secrets (passwords, tokens, API keys)
- Mask PII in logs (email, phone, address)
- Implement data retention policies
```

### Dependency Management

```markdown
- Run security scans daily (npm audit, pip-audit)
- Update dependencies regularly
- Pin versions in production
- Review dependency licenses
- Minimize dependencies (only what's needed)
```

## Performance Standards

### Response Time Targets

- Web pages: < 2 seconds (P95)
- API endpoints: < 500ms (P95)
- Database queries: < 100ms (P95)

### Optimization Guidelines

```markdown
- Profile before optimizing (measure first)
- Optimize hot paths (biggest impact)
- Use caching appropriately
- Lazy load when possible
- Minimize network requests
- Compress responses (gzip, brotli)
- Use CDN for static assets
```

## Monitoring & Logging

### Logging Standards

```markdown
**Use structured logging** (JSON):
{
  "level": "info",
  "timestamp": "2026-02-02T10:30:00Z",
  "message": "User logged in",
  "userId": "123",
  "requestId": "req_abc123"
}

**Log levels**:
- ERROR: Exceptions, failed operations
- WARN: Recoverable issues, deprecations
- INFO: Important state changes
- DEBUG: Detailed diagnostic info

**Include**:
- Correlation IDs (requestId, traceId)
- User context (userId, sessionId)
- Operation context (endpoint, action)

**Never log**:
- Passwords, tokens, API keys
- Credit card numbers
- PII (unless required and encrypted)
```

### Metrics Standards

```markdown
**Track**:
- Request rate (requests/second)
- Error rate (errors/total requests)
- Latency (P50, P95, P99)
- Resource utilization (CPU, memory, disk)
- Business metrics (sign-ups, orders, revenue)

**Name metrics consistently**:
service.operation.metric_type
Example: api.users.request_count
```

## Code Review Severity Levels

```markdown
🔴 **Blocking** (must fix):
- Security vulnerabilities
- Critical bugs
- Data integrity issues
- Breaking changes without migration

🟡 **Important** (should fix):
- Performance issues
- Missing tests for critical logic
- Architectural deviations
- Poor error handling

🟢 **Minor** (optional):
- Style nitpicks
- Optional optimizations
- Non-critical refactoring
```

## Definition of Done

Before marking work as done:
- [ ] Code written and reviewed
- [ ] Tests added/updated (coverage targets met)
- [ ] Linter passes (no warnings)
- [ ] Security scan clean
- [ ] Documentation updated
- [ ] API docs updated (if API changes)
- [ ] Manual testing completed
- [ ] Deployed to staging
- [ ] QA approved
- [ ] Performance acceptable
- [ ] Monitoring/alerts configured

## Resources

- [Google Code Review Guide](https://google.github.io/eng-practices/review/)
- [Clean Code](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)
- [Conventional Commits](https://www.conventionalcommits.org/)
