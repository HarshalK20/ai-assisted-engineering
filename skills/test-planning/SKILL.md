---
name: test-planning
description: Creates comprehensive testing strategies including test pyramid, coverage targets, and quality gates. Use when planning testing approach, defining QA strategy, or when the user mentions test strategy, test planning, or quality assurance.
---

# Test Planning and Strategy

## Purpose

Create comprehensive testing strategies that balance coverage, speed, and confidence.

## When to Use

- Planning testing approach for new features
- Defining QA strategy for projects
- Establishing quality gates for CI/CD
- Test coverage planning
- QA resource allocation
- Pre-production readiness reviews

## Test Pyramid

Optimal test distribution:

```
       /\
      /E2E\         10% - End-to-End (slow, expensive, brittle)
     /------\
    / Integr.\      20% - Integration (medium speed, medium cost)
   /----------\
  / Unit Tests \    70% - Unit (fast, cheap, focused)
 /--------------\
```

### Why This Distribution?

```markdown
**Unit Tests (70%)**:
- Fast (milliseconds)
- Cheap (no infrastructure)
- Focused (one function)
- Easy to maintain
- High confidence in logic

**Integration Tests (20%)**:
- Medium speed (seconds)
- Test component interactions
- Database, API calls
- More realistic
- Catch integration bugs

**E2E Tests (10%)**:
- Slow (minutes)
- Expensive (full environment)
- Brittle (many dependencies)
- High confidence in UX
- Catch workflow bugs
```

## Test Planning Framework

### Step 1: Define Scope

```markdown
What needs testing:
- [ ] New features
- [ ] Modified code
- [ ] Integration points
- [ ] API contracts
- [ ] UI workflows
- [ ] Performance characteristics
- [ ] Security vulnerabilities
```

### Step 2: Identify Test Types

```markdown
For each component:
- **Unit tests**: Business logic, utilities, pure functions
- **Integration tests**: Database, external APIs, services
- **E2E tests**: Critical user journeys
- **Performance tests**: Load, stress, scalability
- **Security tests**: Vulnerabilities, penetration
- **Accessibility tests**: WCAG compliance
```

### Step 3: Set Coverage Targets

```markdown
Recommended targets:
- Unit test coverage: > 80%
- Integration coverage: > 60%
- E2E coverage: Critical paths only
- Mutation test score: > 75% (if used)
```

### Step 4: Define Quality Gates

```markdown
CI/CD gates:
- [ ] All tests passing
- [ ] Coverage thresholds met
- [ ] No critical security vulnerabilities
- [ ] Performance benchmarks met
- [ ] No linter errors
```

## Example: User Registration Feature

### Feature Overview

```
Feature: User Registration
- POST /api/users endpoint
- Email, password, name fields
- Email verification flow
- Rate limiting (10 requests/minute)
```

### Test Plan

#### 1. Unit Tests (70% of effort)

```markdown
**Backend - Validation Logic**:

Email Validation (5 tests):
- Valid email formats accepted
- Invalid formats rejected (no @, no domain, etc.)
- Email normalized to lowercase
- Whitespace trimmed
- Max length enforced (255 chars)

Password Validation (6 tests):
- Minimum length (8 chars) enforced
- Requires number
- Requires special character
- Rejects common passwords
- Max length (72 chars for bcrypt)
- Unicode characters handled

User Creation Logic (8 tests):
- User object created correctly
- Password hashed (never plain text)
- Default values set (email_verified = false)
- Unique email enforced
- Timestamps set correctly
- Returns user ID
- Handles database errors gracefully
- Transactional (rollback on error)

Token Generation (3 tests):
- Token is cryptographically secure
- Token is unique
- Token has correct format (UUID)

---

**Frontend - Form Logic** (if applicable):

Form Validation (4 tests):
- Required fields enforced client-side
- Email format validated
- Password strength indicator works
- Error messages display correctly

State Management (3 tests):
- Registration state updated
- Loading state handled
- Error state handled

Total Unit Tests: ~30 tests
Estimated time: 8 hours to write
Run time: < 10 seconds
```

#### 2. Integration Tests (20% of effort)

```markdown
**API Integration** (10 tests):

Happy Path:
- POST /api/users with valid data returns 201
- Response includes userId and token
- User saved to database
- Email verification sent (mocked)

Error Cases:
- Duplicate email returns 409
- Invalid email returns 400 with error details
- Missing required field returns 400
- Weak password returns 400
- Rate limit exceeded returns 429

Edge Cases:
- Concurrent registration with same email (one succeeds)
- Database connection failure returns 503

---

**Database Integration** (5 tests):
- User persisted with correct fields
- Password is hashed (not plain text)
- Unique constraint enforced
- Timestamps auto-populated
- Transaction rollback on error

---

**Email Service Integration** (3 tests):
- Email service called with correct params
- Email service failure handled gracefully
- Email retry logic works

Total Integration Tests: ~18 tests
Estimated time: 6 hours to write
Run time: 30-60 seconds
```

#### 3. E2E Tests (10% of effort)

```markdown
**Critical User Journeys** (3 tests):

Test 1: Successful Registration Flow
- Navigate to /register
- Fill in form (email, password, name)
- Submit form
- See "Check your email" message
- Verify email sent (check test mailbox)
- Click verification link
- Redirected to dashboard
- User is logged in

Test 2: Duplicate Email Flow
- Try to register with existing email
- See "Email already registered" error
- "Login instead" link works

Test 3: Validation Error Flow
- Try to submit with weak password
- See password requirements error
- Fix password
- Successfully register

Total E2E Tests: 3 tests
Estimated time: 4 hours to write + setup
Run time: 3-5 minutes
```

#### 4. Performance Tests

```markdown
**Load Tests** (using k6 or Artillery):

Test 1: Normal Load
- 10 registrations/second for 5 minutes
- Expected: P95 latency < 500ms, 0% errors

Test 2: Peak Load
- 50 registrations/second for 2 minutes
- Expected: P95 latency < 1000ms, < 1% errors

Test 3: Rate Limiting
- 15 registrations/second from single IP
- Expected: After 10, return 429 Too Many Requests

Total Performance Tests: 3 scenarios
Estimated time: 3 hours to write
Run time: 10 minutes
```

#### 5. Security Tests

```markdown
**Automated Security Scans**:

OWASP Top 10:
- SQL injection attempts (parameterized queries verified)
- XSS attempts in name field (output escaping verified)
- CSRF protection (if session-based auth)
- Security headers present (CSP, X-Frame-Options, etc.)
- No secrets in logs

Authentication & Authorization:
- JWT token properly signed
- Token expiration enforced
- Unauthorized access blocked

Input Validation:
- Buffer overflow attempts rejected
- Very long inputs rejected
- Null byte injection blocked

Total Security Tests: ~15 automated checks
Estimated time: 4 hours to write
Run time: 1-2 minutes
```

#### 6. Accessibility Tests

```markdown
**Automated A11y Checks** (using axe-core):

Registration Form:
- Form inputs have labels
- Error messages associated with fields
- Keyboard navigation works
- Focus indicators visible
- Color contrast meets WCAG AA
- Screen reader compatible

Total A11y Tests: ~6 checks
Estimated time: 2 hours to write
Run time: 30 seconds
```

### Test Summary

```markdown
Total Test Count: ~75 tests
Total Estimated Effort: 27 hours

By Type:
- Unit: 30 tests (8 hours)
- Integration: 18 tests (6 hours)
- E2E: 3 tests (4 hours)
- Performance: 3 scenarios (3 hours)
- Security: 15 checks (4 hours)
- Accessibility: 6 checks (2 hours)

Total Run Time:
- Fast suite (unit + integration): < 2 minutes
- Full suite (all tests): ~ 10 minutes

CI/CD Strategy:
- Fast suite: Every commit
- Full suite: Before merge to main
- Performance: Nightly
- Security: Weekly + before release
```

## Test Strategy by Component Type

### API Endpoints

```markdown
Must have:
- [ ] Happy path (200/201 responses)
- [ ] Authentication required (401 if missing)
- [ ] Authorization checked (403 if unauthorized)
- [ ] Validation errors (400 with details)
- [ ] Not found (404)
- [ ] Rate limiting (429)
- [ ] Server errors handled (500)
- [ ] Idempotency (safe to retry)

Nice to have:
- [ ] Response format matches OpenAPI spec
- [ ] Headers correct (Content-Type, etc.)
- [ ] CORS configured
- [ ] Request/response logging
```

### Database Operations

```markdown
Must have:
- [ ] CRUD operations work
- [ ] Transactions rollback on error
- [ ] Unique constraints enforced
- [ ] Foreign keys work
- [ ] Indexes used (query performance)
- [ ] Connection pooling works
- [ ] Handles connection failures

Nice to have:
- [ ] Query optimization tested
- [ ] N+1 query detection
- [ ] Migration reversible
```

### Frontend Components

```markdown
Must have:
- [ ] Renders without errors
- [ ] Props validated
- [ ] User interactions work (click, type)
- [ ] Error states render
- [ ] Loading states render

Nice to have:
- [ ] Accessibility compliant
- [ ] Responsive design works
- [ ] Animation performance acceptable
- [ ] Snapshot tests (visual regression)
```

## Quality Gates

### Pre-Commit

```markdown
Local development:
- [ ] Linter passes
- [ ] Unit tests pass
- [ ] Type checking passes (if applicable)
```

### Pre-PR

```markdown
Before creating pull request:
- [ ] All tests pass (unit + integration)
- [ ] Coverage > threshold
- [ ] No linter warnings
- [ ] Self-reviewed
```

### Pre-Merge

```markdown
Before merging to main:
- [ ] PR approved by reviewer
- [ ] All CI checks pass
- [ ] E2E tests pass
- [ ] No merge conflicts
- [ ] Branch up to date with main
```

### Pre-Deploy

```markdown
Before production deployment:
- [ ] Full test suite passes
- [ ] Performance benchmarks met
- [ ] Security scan clean
- [ ] Smoke tests pass in staging
- [ ] Rollback plan tested
```

## Test Data Management

### Test Fixtures

```markdown
**Approach 1: In-memory fixtures**
- Store test data in code
- Fast, no dependencies
- Version controlled
- Limited to small datasets

**Approach 2: Factory pattern**
- Generate test data programmatically
- Flexible, customizable
- Avoids data duplication
- Example: Factory.createUser({ email: "test@example.com" })

**Approach 3: Seed data**
- Load from JSON/SQL files
- Realistic data
- Reusable across tests
- Slower to load
```

### Database Strategy

```markdown
**Unit tests**: Mock database
**Integration tests**: Test database (SQLite in-memory or containerized)
**E2E tests**: Staging database (reset between tests)

Best practices:
- Isolate tests (each test independent)
- Clean up after tests (or use transactions)
- Use factories for test data
- Seed reference data (countries, categories, etc.)
```

## Test Environments

```markdown
**Local**:
- Developer machines
- Fast feedback
- Unit + integration tests
- Limited external dependencies (mocked)

**CI/CD**:
- Automated pipeline
- Run on every commit
- Full test suite
- Isolated per PR

**Staging**:
- Production-like environment
- E2E tests
- Manual QA
- Performance testing

**Production**:
- Smoke tests post-deploy
- Monitoring and alerts
- Synthetic transactions
- Canary deployments
```

## Test Coverage Targets

### By Component Type

```markdown
**Critical Components** (95%+):
- Authentication
- Authorization
- Payment processing
- Data integrity (financial, health, PII)

**Important Components** (80-95%):
- Core business logic
- API endpoints
- Database operations
- State management

**Standard Components** (70-80%):
- UI components
- Utilities
- Helper functions

**Low Priority** (50-70%):
- Configuration
- Constants
- Generated code
```

### Coverage vs Confidence

```markdown
❌ False sense of security:
- 100% line coverage but no assertions
- Tests that always pass
- Tests that don't test edge cases

✅ Real confidence:
- 80% coverage with meaningful assertions
- Tests for edge cases and errors
- Integration tests for critical paths
- E2E tests for user journeys
```

## Test Execution Strategy

### Fast Feedback Loop

```markdown
**Tier 1: Instant (< 10s)**
- Unit tests
- Linters
- Type checking
- Run on: Every file save (with watch mode)

**Tier 2: Quick (< 2 min)**
- Integration tests
- API contract tests
- Run on: Every commit (pre-push hook)

**Tier 3: Full (5-10 min)**
- E2E tests
- Security scans
- Run on: PR creation, before merge

**Tier 4: Extended (30-60 min)**
- Performance tests
- Full security audit
- Cross-browser testing
- Run on: Nightly, before release
```

### Parallel Execution

```markdown
Speed up tests:
- Run tests in parallel (use all CPU cores)
- Distribute across multiple machines (CI)
- Shard E2E tests (run in parallel containers)

Example with Jest:
\`\`\`bash
jest --maxWorkers=4  # Use 4 parallel workers
\`\`\`

Example with Playwright:
\`\`\`bash
playwright test --workers=3  # 3 parallel browsers
\`\`\`
```

## Test Maintenance

### Keep Tests Fast

```markdown
Techniques:
- Mock external services
- Use in-memory databases
- Minimize setup/teardown
- Run in parallel
- Skip slow tests in development (tag as @slow)
```

### Keep Tests Reliable

```markdown
Avoid flaky tests:
- No hardcoded waits (use smart waiting)
- Isolate tests (no shared state)
- Clean up after tests
- Mock time/dates
- Avoid race conditions
```

### Keep Tests Maintainable

```markdown
Best practices:
- Clear test names (describe what's tested)
- Arrange-Act-Assert pattern
- One assertion per test (or related assertions)
- DRY (extract common setup to helpers)
- Delete obsolete tests
```

## Resources

### Testing Frameworks
- [Jest](https://jestjs.io/) - JavaScript testing
- [pytest](https://pytest.org/) - Python testing
- [JUnit](https://junit.org/) - Java testing
- [RSpec](https://rspec.info/) - Ruby testing

### E2E Testing
- [Playwright](https://playwright.dev/) - Modern browser automation
- [Cypress](https://www.cypress.io/) - E2E testing framework
- [Selenium](https://www.selenium.dev/) - Browser automation

### Performance Testing
- [k6](https://k6.io/) - Modern load testing
- [Artillery](https://www.artillery.io/) - Load testing toolkit
- [Gatling](https://gatling.io/) - Performance testing

### Security Testing
- [OWASP ZAP](https://www.zaproxy.org/) - Security scanner
- [Burp Suite](https://portswigger.net/burp) - Web security testing
- [npm audit](https://docs.npmjs.com/cli/v8/commands/npm-audit) - Dependency scanning

### Test Strategy
- [Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html) by Martin Fowler
- [Testing Strategies](https://testing.googleblog.com/) by Google Testing Blog
- [Mutation Testing](https://en.wikipedia.org/wiki/Mutation_testing)

## Quick Checklist

Test Plan Completeness:
- [ ] Test pyramid balanced (70/20/10)
- [ ] Coverage targets defined
- [ ] Quality gates established
- [ ] Test environments identified
- [ ] Test data strategy defined
- [ ] CI/CD integration planned
- [ ] Performance testing included
- [ ] Security testing included
- [ ] Accessibility testing included
- [ ] Test maintenance plan

For Each Feature:
- [ ] Unit tests for logic
- [ ] Integration tests for APIs
- [ ] E2E tests for critical paths
- [ ] Edge cases covered
- [ ] Error cases covered
- [ ] Security cases covered
- [ ] Performance acceptable
- [ ] Accessibility compliant
