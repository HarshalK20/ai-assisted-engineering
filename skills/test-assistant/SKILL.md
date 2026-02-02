---
name: test-assistant
description: Generates test scenarios and validation steps for code changes including edge cases and failure modes. Use when planning tests, during TDD, for QA handoff, or when the user mentions testing, test cases, or validation.
---

# Test & Run Assistant

## Purpose

Generate comprehensive test scenarios and validation steps for changes, ensuring thorough coverage.

## When to Use

- Pre-deployment validation planning
- Manual testing guidance for QA
- Test-driven development (TDD)
- QA handoff documentation
- Exploratory testing sessions
- Regression testing after changes

## Test Generation Process

### Step 1: Understand the Change

```markdown
Questions to answer:
- What was added/changed/removed?
- What's the expected behavior?
- What are the inputs and outputs?
- What can go wrong?
- What are the edge cases?
```

### Step 2: Identify Test Scenarios

```markdown
Test categories:
1. Happy path (expected usage)
2. Edge cases (boundary values)
3. Error cases (invalid inputs)
4. Failure modes (system failures)
5. Performance (under load)
6. Security (malicious inputs)
7. Integration (with other components)
```

### Step 3: Generate Test Cases

For each scenario, specify:
- **Given**: Initial state/preconditions
- **When**: Action performed
- **Then**: Expected outcome
- **How to verify**: Validation steps

## Example: User Registration Endpoint

### Change Description

```
Added POST /api/users endpoint for user registration
Accepts: email, password, name
Returns: user ID and JWT token
Validates: email format, password strength, unique email
```

### Generated Test Plan

#### 1. Happy Path Tests

```markdown
Test: Successful registration with valid data
Given: No user with email "test@example.com" exists
When: POST /api/users with:
  {
    "email": "test@example.com",
    "password": "SecurePass123!",
    "name": "John Doe"
  }
Then:
  - Response status: 201 Created
  - Response body contains: userId (UUID), token (JWT)
  - User saved in database
  - Email is normalized (lowercase)
  - Password is hashed (not plain text)
Verification:
  - Query database for user
  - Verify password hash is bcrypt
  - Decode JWT token, verify user ID matches
```

#### 2. Validation Tests

```markdown
Test: Invalid email format
Given: Clean state
When: POST /api/users with email "notanemail"
Then: 400 Bad Request with error:
  {
    "error": {
      "code": "INVALID_EMAIL",
      "message": "Please enter a valid email address"
    }
  }

---

Test: Weak password
Given: Clean state
When: POST /api/users with password "123"
Then: 400 Bad Request with error "Password must be at least 8 characters"

---

Test: Password requirements
Given: Clean state
When: POST /api/users with password "password" (no numbers/special chars)
Then: 400 Bad Request listing all requirements:
  - At least 8 characters
  - Contains at least one number
  - Contains at least one special character

---

Test: Missing required field (email)
Given: Clean state
When: POST /api/users without email field
Then: 400 Bad Request with error "Email is required"

---

Test: Missing required field (password)
Given: Clean state
When: POST /api/users without password field
Then: 400 Bad Request with error "Password is required"

---

Test: Missing required field (name)
Given: Clean state
When: POST /api/users without name field
Then: 400 Bad Request with error "Name is required"

---

Test: Empty string fields
Given: Clean state
When: POST /api/users with email = ""
Then: 400 Bad Request with error "Email is required"
```

#### 3. Edge Cases

```markdown
Test: Email case insensitivity
Given: User exists with email "Test@Example.com"
When: POST /api/users with email "test@example.com"
Then: 409 Conflict with error "Email already registered"
Note: Emails should be normalized to lowercase

---

Test: Extra whitespace in email
Given: Clean state
When: POST /api/users with email " test@example.com "
Then: Should trim and succeed (201) OR reject with "Invalid email format"
Decision needed: Which behavior?

---

Test: Very long name (boundary test)
Given: Clean state
When: POST /api/users with name of 500 characters
Then: 
  - If max length defined: 400 Bad Request
  - If no limit: 201 Created
  - Check database field length limit

---

Test: Unicode characters in name
Given: Clean state
When: POST /api/users with name "José García 李明"
Then: 201 Created (should support international names)
Verify: Name stored correctly in database

---

Test: Special characters in name
Given: Clean state
When: POST /api/users with name "O'Brien-Smith Jr."
Then: 201 Created
Verify: Characters not escaped/mangled

---

Test: Maximum password length
Given: Clean state
When: POST /api/users with 1000-character password
Then: 201 Created (no arbitrary max length)
OR: 400 if reasonable max length enforced
```

#### 4. Duplicate Registration Tests

```markdown
Test: Duplicate email
Given: User exists with "test@example.com"
When: POST /api/users with same email
Then: 409 Conflict with error "Email already registered"

---

Test: Concurrent registration (race condition)
Given: No user exists
When: Two simultaneous POST requests with same email
Then: One succeeds (201), one fails (409)
Verify: Only one user in database
Note: Tests database unique constraint
```

#### 5. Security Tests

```markdown
Test: SQL injection in email
Given: Clean state
When: POST /api/users with email "test@example.com'; DROP TABLE users--"
Then: 400 Bad Request (invalid email) OR 201 if stored safely
Verify: Database tables intact

---

Test: XSS in name
Given: Clean state
When: POST /api/users with name "<script>alert('xss')</script>"
Then: 201 Created
Verify: Name is escaped when returned in API responses

---

Test: Very long input (buffer overflow attempt)
Given: Clean state
When: POST /api/users with 1MB name field
Then: 400 Bad Request with error "Input too large"
OR: 413 Payload Too Large

---

Test: Password not logged
Given: Clean state
When: POST /api/users with any data
Then: Check application logs
Verify: Password not present in any log entries

---

Test: Rate limiting
Given: Clean state
When: 100 registration requests in 1 minute from same IP
Then: After threshold (e.g., 10), return 429 Too Many Requests
Verify: Legitimate users from other IPs not affected
```

#### 6. System Failure Tests

```markdown
Test: Database unavailable
Given: Database connection fails
When: POST /api/users
Then: 503 Service Unavailable
Verify: Error logged, user gets clear message

---

Test: Email service down (if sending confirmation email)
Given: Email service fails
When: POST /api/users
Then: 
  - User still created (201)
  - Email sent asynchronously, retried later
OR:
  - 500 error, transaction rolled back
Decision needed: Which behavior?

---

Test: Timeout during database write
Given: Database very slow
When: POST /api/users
Then: Request times out after configured timeout
Verify: No partial data in database

---

Test: Disk full (can't write)
Given: Database disk at capacity
When: POST /api/users
Then: 500 Internal Server Error
Verify: Error logged, no data corruption
```

#### 7. Integration Tests

```markdown
Test: End-to-end registration flow
Given: Clean state
When: 
  1. POST /api/users (register)
  2. POST /api/auth/login with same credentials
Then:
  1. Registration returns 201 with token
  2. Login returns 200 with token
  3. Both tokens are valid JWT
  4. Tokens can be used to access protected endpoints

---

Test: Registration then profile access
Given: Clean state
When:
  1. Register user
  2. Use token to GET /api/users/me
Then: Profile returned with correct data
```

## Manual Testing Guide

### Pre-Deployment Checklist

```markdown
Environment Setup:
- [ ] Test in staging environment (production-like)
- [ ] Database seeded with test data
- [ ] External services (email, etc.) configured
- [ ] Test user accounts ready

Tools Needed:
- [ ] API client (Postman, Insomnia, curl)
- [ ] Browser with dev tools
- [ ] Database client (for verification)
- [ ] Log viewer
```

### Test Execution Steps

```bash
# 1. Test happy path
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123!",
    "name": "Test User"
  }'

# Expected: 201 Created with userId and token
# Verify: Check database for new user
# Verify: Check logs for successful registration

# 2. Test duplicate email
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Different123!",
    "name": "Another User"
  }'

# Expected: 409 Conflict with "Email already registered"

# 3. Test invalid email
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "notanemail",
    "password": "SecurePass123!",
    "name": "Test User"
  }'

# Expected: 400 Bad Request with validation error

# 4. Test weak password
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test2@example.com",
    "password": "123",
    "name": "Test User"
  }'

# Expected: 400 Bad Request with password requirements

# 5. Test missing fields
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test3@example.com"
  }'

# Expected: 400 Bad Request listing missing required fields

# 6. Test SQL injection
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com'\'' DROP TABLE users--",
    "password": "SecurePass123!",
    "name": "Test User"
  }'

# Expected: 400 Bad Request (invalid email) OR safely stored
# Verify: Check database - tables should be intact

# 7. Test XSS
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test4@example.com",
    "password": "SecurePass123!",
    "name": "<script>alert(\"xss\")</script>"
  }'

# Expected: 201 Created
# Verify: GET user profile, check if script is escaped
```

### Validation Checklist

```markdown
For each test:
- [ ] Response status code correct
- [ ] Response body structure matches API docs
- [ ] Error messages are clear and actionable
- [ ] Database state is correct
- [ ] No errors in application logs (except expected)
- [ ] No sensitive data in logs
- [ ] Performance acceptable (< 500ms)
```

## Test Types

### Unit Tests

```javascript
// Example: Testing password validation
describe('User Registration', () => {
  describe('Password Validation', () => {
    it('should reject password shorter than 8 characters', () => {
      const result = validatePassword('short1!');
      expect(result.valid).toBe(false);
      expect(result.error).toContain('at least 8 characters');
    });
    
    it('should reject password without number', () => {
      const result = validatePassword('NoNumbers!');
      expect(result.valid).toBe(false);
      expect(result.error).toContain('at least one number');
    });
    
    it('should reject password without special character', () => {
      const result = validatePassword('NoSpecial123');
      expect(result.valid).toBe(false);
      expect(result.error).toContain('special character');
    });
    
    it('should accept strong password', () => {
      const result = validatePassword('SecurePass123!');
      expect(result.valid).toBe(true);
    });
  });
});
```

### Integration Tests

```javascript
// Example: Testing API endpoint
describe('POST /api/users', () => {
  beforeEach(async () => {
    await clearDatabase();
  });
  
  it('should create user with valid data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        password: 'SecurePass123!',
        name: 'John Doe'
      });
      
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('userId');
    expect(response.body).toHaveProperty('token');
    
    // Verify database
    const user = await db.users.findOne({ email: 'test@example.com' });
    expect(user).toBeDefined();
    expect(user.name).toBe('John Doe');
  });
  
  it('should reject duplicate email', async () => {
    // Create first user
    await createUser({ email: 'test@example.com' });
    
    // Try to create duplicate
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        password: 'SecurePass123!',
        name: 'Jane Doe'
      });
      
    expect(response.status).toBe(409);
    expect(response.body.error.code).toBe('EMAIL_ALREADY_REGISTERED');
  });
});
```

### E2E Tests

```javascript
// Example: Full user journey
describe('User Registration Flow', () => {
  it('should complete registration and login', async () => {
    // 1. Register
    const registerResponse = await page.goto('/register');
    await page.fill('#email', 'test@example.com');
    await page.fill('#password', 'SecurePass123!');
    await page.fill('#name', 'Test User');
    await page.click('#submit');
    
    await page.waitForNavigation();
    expect(page.url()).toContain('/dashboard');
    
    // 2. Verify logged in
    const userName = await page.textContent('#user-name');
    expect(userName).toBe('Test User');
    
    // 3. Logout
    await page.click('#logout');
    await page.waitForNavigation();
    expect(page.url()).toContain('/login');
    
    // 4. Login with created credentials
    await page.fill('#email', 'test@example.com');
    await page.fill('#password', 'SecurePass123!');
    await page.click('#login');
    
    await page.waitForNavigation();
    expect(page.url()).toContain('/dashboard');
  });
});
```

## Test Data Management

### Test Fixtures

```javascript
// fixtures/users.js
export const validUsers = [
  {
    email: 'john@example.com',
    password: 'SecurePass123!',
    name: 'John Doe'
  },
  {
    email: 'jane@example.com',
    password: 'AnotherPass456!',
    name: 'Jane Smith'
  }
];

export const invalidEmails = [
  'notanemail',
  '@example.com',
  'test@',
  'test @example.com',
  'test@example',
];

export const weakPasswords = [
  'short',
  '12345678',
  'noNumbers!',
  'NoSpecialChar123'
];
```

### Test Database Setup

```javascript
// tests/setup.js
beforeAll(async () => {
  // Connect to test database
  await connectDatabase(process.env.TEST_DATABASE_URL);
  // Run migrations
  await runMigrations();
});

beforeEach(async () => {
  // Clear database before each test
  await clearDatabase();
  // Seed with required data
  await seedDatabase();
});

afterAll(async () => {
  // Cleanup
  await disconnectDatabase();
});
```

## Performance Testing

### Load Test Scenarios

```markdown
Scenario 1: Normal load
- 10 requests/second for 5 minutes
- Expected: P95 latency < 500ms, 0% errors

Scenario 2: Peak load
- 100 requests/second for 2 minutes
- Expected: P95 latency < 1000ms, < 1% errors

Scenario 3: Spike
- 1000 requests/second for 30 seconds
- Expected: Rate limiting kicks in, system stable

Scenario 4: Sustained load
- 50 requests/second for 1 hour
- Expected: No memory leaks, consistent performance
```

### Load Test Script (k6)

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '1m', target: 10 },  // Ramp up
    { duration: '5m', target: 10 },  // Stay at 10
    { duration: '1m', target: 0 },   // Ramp down
  ],
};

export default function () {
  const payload = JSON.stringify({
    email: `test-${__VU}-${__ITER}@example.com`,
    password: 'SecurePass123!',
    name: 'Load Test User'
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const res = http.post('http://localhost:3000/api/users', payload, params);

  check(res, {
    'status is 201': (r) => r.status === 201,
    'response time < 500ms': (r) => r.timings.duration < 500,
    'has userId': (r) => JSON.parse(r.body).userId !== undefined,
  });

  sleep(1);
}
```

## Resources

### Testing Frameworks
- [Jest](https://jestjs.io/) - JavaScript testing
- [pytest](https://pytest.org/) - Python testing
- [JUnit](https://junit.org/) - Java testing
- [RSpec](https://rspec.info/) - Ruby testing

### API Testing
- [Postman](https://www.postman.com/) - API client and testing
- [Insomnia](https://insomnia.rest/) - API client
- [Supertest](https://github.com/visionmedia/supertest) - HTTP assertions

### Load Testing
- [k6](https://k6.io/) - Modern load testing
- [Artillery](https://www.artillery.io/) - Load testing toolkit
- [JMeter](https://jmeter.apache.org/) - Traditional load testing

### E2E Testing
- [Playwright](https://playwright.dev/) - Browser automation
- [Cypress](https://www.cypress.io/) - E2E testing framework
- [Selenium](https://www.selenium.dev/) - Browser automation

## Quick Checklist

Test Coverage:
- [ ] Happy path (successful operation)
- [ ] Validation errors (invalid inputs)
- [ ] Edge cases (boundary values, special chars)
- [ ] Error handling (system failures)
- [ ] Security (injection, XSS, auth)
- [ ] Performance (under load)
- [ ] Integration (with other components)
- [ ] Idempotency (safe to retry)
- [ ] Concurrency (race conditions)
- [ ] Backward compatibility (if applicable)

Before Deployment:
- [ ] All tests passing
- [ ] Manual smoke test performed
- [ ] Performance acceptable
- [ ] Security scan clean
- [ ] Rollback procedure tested
