---
name: self-review
description: Reviews own work as a neutral senior peer before sharing with others. Use when preparing design docs, before submitting PRs, post-implementation sanity checks, or when the user mentions self-review, code review, or quality checks.
---

# Self-Review Accelerator

## Purpose

Review your own work as a neutral senior peer would, catching issues before formal review.

## When to Use

- Before submitting design documents for team review
- Pre-PR self-check before requesting code review
- Post-implementation sanity check
- Before architectural presentations
- When working independently without pair programming
- After completing major refactoring

## Self-Review Mindset

### Shift Perspective

Review as if you're:
- A senior engineer seeing this for the first time
- Someone who will maintain this in 6 months
- A skeptical architect looking for problems
- Someone with no context about "why" decisions were made

### Common Cognitive Biases to Avoid

**Confirmation bias**: "This works for my use case" → Test edge cases
**Optimism bias**: "Users will understand this" → Assume they won't
**Curse of knowledge**: "This is obvious" → Add comments/docs
**Sunk cost fallacy**: "I've spent days on this" → Don't fear scrapping bad approaches

## Code Self-Review Checklist

### 1. Correctness

```markdown
- [ ] Logic is correct for all inputs
- [ ] Edge cases handled (null, empty, boundary values)
- [ ] Error conditions caught and handled
- [ ] No off-by-one errors
- [ ] Concurrency issues considered (if applicable)
- [ ] Asynchronous operations handled properly
```

### 2. Testing

```markdown
- [ ] Unit tests for business logic
- [ ] Integration tests for API endpoints
- [ ] Edge case tests (null, empty, max values)
- [ ] Error case tests (network failures, invalid input)
- [ ] Test coverage > 80% for new code
- [ ] Tests are readable and maintainable
- [ ] No flaky tests (run multiple times to verify)
```

### 3. Security

```markdown
- [ ] Input validation on all user inputs
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (escaped output)
- [ ] Authentication required for protected endpoints
- [ ] Authorization checked (user can access this resource?)
- [ ] No secrets in code (use environment variables)
- [ ] Sensitive data encrypted (passwords, PII)
- [ ] Rate limiting for public endpoints
- [ ] CSRF protection on state-changing operations
```

### 4. Performance

```markdown
- [ ] No N+1 queries
- [ ] Database queries indexed
- [ ] Large loops optimized or paginated
- [ ] Memory leaks prevented (listeners cleaned up)
- [ ] Caching used where appropriate
- [ ] API calls batched if possible
- [ ] No blocking operations in critical path
- [ ] Resource cleanup in finally blocks
```

### 5. Readability

```markdown
- [ ] Variable names descriptive (not x, tmp, data)
- [ ] Functions under 50 lines (ideally under 20)
- [ ] Each function does one thing
- [ ] Complex logic has comments
- [ ] Magic numbers extracted to constants
- [ ] Consistent naming conventions
- [ ] No commented-out code
- [ ] No TODO comments without tickets
```

### 6. Error Handling

```markdown
- [ ] All errors caught and handled
- [ ] Errors logged with context
- [ ] User-facing errors are clear
- [ ] Partial failures handled gracefully
- [ ] Retries with exponential backoff (if applicable)
- [ ] Circuit breaker for external services
- [ ] Fallback behavior defined
```

### 7. Observability

```markdown
- [ ] Important operations logged
- [ ] Errors logged with stack trace
- [ ] Metrics for key operations
- [ ] Distributed tracing context passed
- [ ] Logs include correlation IDs
- [ ] No sensitive data in logs
```

### 8. Dependencies

```markdown
- [ ] New dependencies justified
- [ ] Dependencies up to date (no known vulnerabilities)
- [ ] License compatible with project
- [ ] Dependency size reasonable
- [ ] Can we implement ourselves? (if small)
```

## Self-Review Process

### Step 1: Take a Break

⏰ **Wait 30 minutes** (or overnight for large changes)

Why: Fresh eyes catch more issues

### Step 2: Review Your Own PR/Code

Review as if someone else wrote it:

```markdown
Questions to ask:
- Would I approve this PR if I didn't write it?
- Is the approach clear without explanation?
- Can I understand this 6 months from now?
- Would a junior engineer understand this?
- What could go wrong?
```

### Step 3: Check Against Standards

```markdown
- [ ] Follows team coding standards
- [ ] Matches existing patterns in codebase
- [ ] Naming consistent with similar code
- [ ] No style lint errors
- [ ] Tests follow team test patterns
```

### Step 4: Think Adversarially

What would a malicious user try:
```markdown
- [ ] Invalid inputs (null, negative, huge values)
- [ ] Authorization bypass attempts
- [ ] SQL injection in text fields
- [ ] Rate limit bypass
- [ ] Race conditions (concurrent requests)
```

### Step 5: Consider Failure Modes

```markdown
What if:
- [ ] Database is down?
- [ ] External API times out?
- [ ] Network is slow (3G)?
- [ ] Disk is full?
- [ ] Service restarts mid-request?
- [ ] User clicks button twice?
```

## Example: Code Self-Review

### Before Self-Review

```python
def process_order(order_id):
    order = db.query(f"SELECT * FROM orders WHERE id = {order_id}")
    if order:
        payment = requests.post(payment_url, json={"amount": order.total})
        if payment.status_code == 200:
            db.query(f"UPDATE orders SET status = 'paid' WHERE id = {order_id}")
            return True
    return False
```

### Self-Review Findings

```markdown
❌ **Issue 1**: SQL Injection vulnerability (line 2, 6)
- Lines use string interpolation for SQL
- Fix: Use parameterized queries

❌ **Issue 2**: No timeout on payment API call (line 4)
- Could hang indefinitely
- Fix: Add timeout parameter

❌ **Issue 3**: No error handling
- Payment failure not logged
- Network errors not caught
- Fix: Add try/except, log errors

❌ **Issue 4**: No idempotency
- Clicking twice processes payment twice
- Fix: Check order status before processing

❌ **Issue 5**: No observability
- No logging of payment attempts
- No metrics on success/failure rate
- Fix: Add structured logging and metrics

⚠️ **Issue 6**: Direct database access
- Bypasses ORM validation
- Hard to test
- Consider: Use ORM or repository pattern
```

### After Self-Review

```python
import logging
from typing import Optional
from sqlalchemy import select, update
from tenacity import retry, stop_after_attempt, wait_exponential

logger = logging.getLogger(__name__)

@retry(stop=stop_after_attempt(3), wait=wait_exponential(min=1, max=10))
def call_payment_api(amount: float, order_id: str) -> dict:
    """Call payment API with retry logic."""
    try:
        response = requests.post(
            payment_url,
            json={"amount": amount, "order_id": order_id},
            timeout=30
        )
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        logger.error(f"Payment API failed for order {order_id}", exc_info=True)
        raise

def process_order(order_id: str) -> bool:
    """
    Process payment for an order.
    
    Args:
        order_id: UUID of the order to process
        
    Returns:
        True if payment successful, False otherwise
        
    Raises:
        ValueError: If order not found or already paid
    """
    try:
        # Use parameterized query
        stmt = select(Order).where(Order.id == order_id).with_for_update()
        order = db.session.execute(stmt).scalar_one_or_none()
        
        if not order:
            raise ValueError(f"Order {order_id} not found")
            
        # Check idempotency
        if order.status == 'paid':
            logger.warning(f"Order {order_id} already paid")
            return True
            
        # Process payment with retry
        logger.info(f"Processing payment for order {order_id}, amount: {order.total}")
        payment_result = call_payment_api(order.total, order_id)
        
        # Update order status
        stmt = (
            update(Order)
            .where(Order.id == order_id)
            .values(status='paid', payment_id=payment_result['id'])
        )
        db.session.execute(stmt)
        db.session.commit()
        
        logger.info(f"Order {order_id} payment successful")
        metrics.increment('orders.payment.success')
        return True
        
    except ValueError:
        raise
    except Exception as e:
        logger.error(f"Failed to process order {order_id}", exc_info=True)
        metrics.increment('orders.payment.failure')
        db.session.rollback()
        return False
```

## Design Document Self-Review

### Checklist

```markdown
**Clarity**:
- [ ] Problem clearly stated
- [ ] Solution easy to understand
- [ ] No jargon (or jargon explained)
- [ ] Diagrams included where helpful

**Completeness**:
- [ ] All components identified
- [ ] Dependencies documented
- [ ] Data model defined
- [ ] API contracts specified
- [ ] Error handling strategy
- [ ] Testing approach
- [ ] Deployment plan
- [ ] Rollback procedure

**Assumptions**:
- [ ] All assumptions stated explicitly
- [ ] Assumptions validated or flagged as risky
- [ ] Alternative approaches considered
- [ ] Trade-offs explained

**Risk**:
- [ ] Technical risks identified
- [ ] Mitigation strategies defined
- [ ] Failure scenarios considered
- [ ] Performance implications analyzed
- [ ] Security implications reviewed

**Operational**:
- [ ] Monitoring plan defined
- [ ] Alerting thresholds set
- [ ] Runbooks needed identified
- [ ] On-call impact assessed
- [ ] Cost implications calculated
```

## Self-Review Red Flags

Watch for these warning signs:

### Code Smells

```markdown
🚩 Functions > 50 lines
🚩 Deeply nested conditionals (> 3 levels)
🚩 Duplicated code blocks
🚩 Magic numbers (hardcoded values)
🚩 Generic names (data, info, temp, helper)
🚩 Commented-out code
🚩 Empty catch blocks
🚩 God classes (hundreds of methods)
```

### Design Smells

```markdown
🚩 "It should be fine" (no analysis)
🚩 "We'll fix it later" (technical debt)
🚩 "It works on my machine" (environment-specific)
🚩 "Users won't do that" (untested assumption)
🚩 Single point of failure
🚩 No rollback plan
🚩 "Just add a TODO" (without ticket)
```

## Self-Review Tools

### Automated Tools

```bash
# Linting
eslint src/
pylint src/
rubocop

# Security scanning
npm audit
pip-audit
snyk test

# Code coverage
jest --coverage
pytest --cov=src

# Static analysis
mypy src/
flow check
```

### Manual Review Tools

```markdown
**Print it out**: Physical review catches different issues
**Read aloud**: Hear awkward naming or logic
**Rubber duck**: Explain code to inanimate object
**Diff review**: Review git diff, not just files
**Trace execution**: Walk through code with example inputs
```

## Common Mistakes in Self-Review

### 1. Reviewing Too Soon

❌ Review immediately after writing
✅ Wait 30+ minutes (or overnight)

### 2. Skipping Tests

❌ "Tests look fine, didn't run them"
✅ Run full test suite, add new tests

### 3. Ignoring Tools

❌ "Linter is wrong, I know better"
✅ Investigate warnings, fix or disable with comment

### 4. Assuming Context

❌ "Obviously this is for X"
✅ Add comment explaining why

### 5. Focusing Only on Happy Path

❌ Test only successful scenarios
✅ Test failures, edge cases, concurrency

## Resources

### Code Review Best Practices
- [Google Code Review Guidelines](https://google.github.io/eng-practices/review/)
- [Code Review Checklist](https://github.com/mgreiler/code-review-checklist)
- [Conventional Comments](https://conventionalcomments.org/)

### Security
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Security Code Review Guide](https://owasp.org/www-pdf-archive/OWASP_Code_Review_Guide_v2.pdf)

### Clean Code
- [Clean Code Principles](https://www.freecodecamp.org/news/clean-coding-for-beginners/)
- [Refactoring Catalog](https://refactoring.guru/refactoring/catalog)

## Quick Reference Card

```markdown
Before submitting:
□ Run all tests
□ Check linter
□ Review your own diff
□ Add missing tests
□ Check security (input validation, auth, injection)
□ Verify error handling
□ Add logging/metrics
□ Update documentation
□ Remove debug code
□ Clean up comments

Ask yourself:
? Would I approve this PR?
? Can I understand this in 6 months?
? What could go wrong?
? Are all edge cases handled?
? Is this the simplest solution?
```

## Self-Review Checklist Summary

- [ ] **Correctness**: Logic is right for all inputs
- [ ] **Testing**: Good coverage, including edge cases
- [ ] **Security**: Input validation, no injection, auth checked
- [ ] **Performance**: No obvious bottlenecks
- [ ] **Readability**: Clear names, comments where needed
- [ ] **Error handling**: All errors caught and logged
- [ ] **Observability**: Logging and metrics added
- [ ] **Standards**: Follows team conventions
- [ ] **Failure modes**: Considered what could go wrong
- [ ] **Documentation**: Updated if needed
