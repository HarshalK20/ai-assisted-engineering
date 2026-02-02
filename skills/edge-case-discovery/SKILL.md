---
name: edge-case-discovery
description: Expands requirements into comprehensive edge cases, failure modes, and boundary conditions. Use when planning features, during design reviews, test planning, risk assessment, or when the user mentions edge cases, testing, or requirement validation.
---

# Requirements to Edge-Case Discovery

## Purpose

Expand requirements into comprehensive edge cases and failure modes to build robust systems and thorough tests.

## When to Use

- Design reviews and architecture planning
- Test case generation and QA planning
- Risk assessment and threat modeling
- API design and contract definition
- Security review preparation
- Production readiness reviews

## Edge Case Categories

### 1. Boundary Cases

Test limits and extremes:

**Example Requirement**: "User can upload profile picture, max 5MB, JPG/PNG only"

```markdown
Boundary cases:
- Exactly 5MB (5,242,880 bytes)
- 4,999,999 bytes (just under limit)
- 5,242,881 bytes (just over limit)
- 0 bytes (empty file)
- 1 byte (minimum file)
- Maximum platform file size (varies by OS)
- Filename with exact max length (255 chars)
- Filename with no extension
```

### 2. Negative/Invalid Input

What happens with bad input:

```markdown
Invalid inputs:
- Wrong format (GIF, BMP, TIFF, WebP, SVG)
- Corrupted file (truncated, invalid header)
- File with wrong extension (virus.exe renamed to virus.jpg)
- No file provided (null/undefined)
- Multiple files when expecting one
- Non-image file (PDF, ZIP, TXT)
- Image with embedded malware (EXIF injection)
- File from untrusted source
```

### 3. Concurrent Operations

Multiple operations at once:

```markdown
Concurrency scenarios:
- Upload while another upload in progress
- Upload then immediately delete (race condition)
- Two tabs uploading simultaneously
- Upload during account deletion
- Upload while profile being viewed by others
- Server processing previous upload when new arrives
```

### 4. System Failures

What if components fail:

```markdown
Failure modes:
- Storage full (disk space exhausted)
- Network timeout during upload
- Database unavailable (can't save metadata)
- Image processing service down
- User logout mid-upload
- Browser crash during upload
- Server restart during processing
```

### 5. Security Cases

Malicious or security-relevant scenarios:

```markdown
Security cases:
- EXIF injection (malicious metadata)
- Path traversal (../../etc/passwd as filename)
- XXE attack via SVG
- Zip bomb (small file expands to TB)
- Scripts in filename ("><script>alert(1)</script>.jpg)
- Unicode homoglyph attacks in filename
- CSRF token missing/invalid
- Upload without authentication
- Upload to other user's profile (authorization bypass)
```

### 6. State Dependencies

Order and timing matter:

```markdown
State-dependent cases:
- Upload before email verified
- Upload after account suspended
- Upload during trial period vs paid subscription
- Upload with incomplete profile
- Upload before accepting terms of service
- Upload after profile picture already exists (replace vs error)
```

### 7. Data Edge Cases

Unusual but valid data:

```markdown
Data edge cases:
- Extremely high resolution (16000x16000px)
- Extremely low resolution (1x1px)
- Unusual aspect ratio (1:100)
- Monochrome image (1-bit color depth)
- 16-bit color depth PNG
- Progressive vs baseline JPEG
- Animated PNG (APNG)
- Transparent PNG vs opaque
- Image with ICC color profile
- Image with very long EXIF data
```

## Systematic Discovery Process

### Step 1: Decompose Requirements

Break requirement into components:

```markdown
Requirement: "Users can transfer money to contacts"

Components:
- Authentication (who can transfer?)
- Amount (how much?)
- Recipient (to whom?)
- Source account (from where?)
- Timing (when?)
- Validation (what checks?)
- Confirmation (what feedback?)
```

### Step 2: Apply CRUD + Search

For each component:
- **Create**: First transfer, new recipient
- **Read**: View pending transfers
- **Update**: Modify pending transfer
- **Delete**: Cancel transfer
- **Search**: Find past transfers

### Step 3: Apply Boundary Value Analysis

For numeric/string fields:

```markdown
Amount field:
- Zero: $0.00
- Minimum: $0.01
- Just below limit: $9,999.99 (if limit $10,000)
- At limit: $10,000.00
- Just above limit: $10,000.01
- Maximum: Account balance
- Above maximum: Balance + $0.01
- Negative: -$100.00
- Decimal precision: $10.001, $10.999
- Very large: $999,999,999.99
- Scientific notation: 1e10
- Non-numeric: "abc", null, undefined, NaN
```

### Step 4: Check Dependencies

What must be true first:

```markdown
Prerequisites:
✓ User authenticated
✓ Account verified (KYC)
✓ Sufficient balance
✓ Recipient valid
✓ No fraud flags
✓ Daily limit not exceeded
✓ Account not frozen

What if not true?
✗ Anonymous user attempts transfer
✗ Unverified account attempts transfer
✗ Insufficient balance
✗ Recipient account closed
✗ User flagged for fraud
✗ Daily limit already hit today
✗ Account temporarily frozen
```

### Step 5: Consider Timing

When does it happen:

```markdown
Timing scenarios:
- During business hours vs night
- Weekday vs weekend vs holiday
- Just before midnight (day boundary)
- During maintenance window
- High traffic period (Black Friday)
- Low traffic period (3am)
- Daylight saving time change
- Leap second/leap day
- Year rollover (Dec 31 → Jan 1)
```

### Step 6: Think Maliciously

What would attacker try:

```markdown
Attack vectors:
- SQL injection in recipient name
- XSS in transfer note
- CSRF token bypass
- Session hijacking
- Authorization bypass (transfer from others' accounts)
- Rate limit bypass (automated transfers)
- Integer overflow in amount
- Race condition (double spending)
- Replay attack (resubmit same request)
```

## Example: Comprehensive Edge Case Analysis

### Requirement
"User can search for products by name, with pagination (20 results per page), sorted by relevance or price"

### Edge Case Analysis

#### Search Query

```markdown
Boundary cases:
- Empty search ("") 
- Single character ("a")
- Very long query (10,000 characters)
- Special characters only ("@#$%")
- SQL injection attempt ("'; DROP TABLE products--")
- XSS attempt ("<script>alert(1)</script>")
- Unicode/emoji ("😀 product")
- Multiple spaces ("product    name")
- Leading/trailing spaces (" product ")
- Case variations ("Product", "PRODUCT", "pRoDuCt")

Valid edge cases:
- Common typos ("prodcut" for "product")
- Partial matches ("prod" matching "product")
- Multiple words ("blue shirt")
- Hyphenated words ("t-shirt")
- Numbers ("iPhone 15")
- Brand names with special chars ("L'Oréal")
```

#### Pagination

```markdown
Boundary cases:
- Page 1 (first page)
- Page 0 (before first)
- Page -1 (negative)
- Last valid page (e.g., page 50 if 1000 results)
- Beyond last page (page 51 if only 50 pages)
- Page number as decimal (page 1.5)
- Page number as non-numeric ("abc")
- Page number very large (999999)
- Page size = 0
- Page size = 1
- Page size = 20 (default)
- Page size = 1000 (very large)
- Page size negative (-20)

Data edge cases:
- Zero results (empty result set)
- Exactly 20 results (one page)
- 21 results (spans two pages)
- Odd number results (e.g., 57 results)
```

#### Sorting

```markdown
Boundary cases:
- Sort by relevance (default)
- Sort by price ascending
- Sort by price descending
- Sort parameter missing
- Invalid sort parameter ("color")
- Multiple sort parameters ("price,name")

Data edge cases:
- Products with same price (tie-breaking)
- Products with no price (null/undefined)
- Products with price = 0
- Products with very high price ($999,999)
- Products with price in different currencies
- Products with sale price vs regular price
```

#### Concurrent Operations

```markdown
Race conditions:
- Search while products being added
- Search while products being deleted
- Search while prices being updated
- Multiple searches from same user simultaneously
- Search during database reindex
- Search during cache refresh
```

#### System Failures

```markdown
Failure modes:
- Database unavailable (connection timeout)
- Search index (Elasticsearch) down
- Cache (Redis) unavailable
- API response timeout
- Network interruption mid-request
- Load balancer failure
- Rate limit exceeded
```

#### Performance Edge Cases

```markdown
Performance scenarios:
- Search for very common term ("the") → millions of results
- Search for very rare term ("xyzabc123") → zero results
- Search with many filters applied
- Rapid pagination (clicking next 100 times)
- Concurrent searches from 10,000 users
- Search query triggering slow database query
```

#### Security Cases

```markdown
Security scenarios:
- Unauthenticated search (should it work?)
- Search for restricted products (admin-only)
- Search revealing hidden/draft products
- Search bypassing regional restrictions
- Enumeration attack (discover all products)
- Information disclosure via error messages
- Timing attack (deduce product existence)
```

## Testing Categories Mapping

Use edge cases to generate tests:

### Unit Tests
- Boundary values
- Invalid inputs
- Null/undefined handling
- Type coercion
- Error conditions

### Integration Tests
- Component interactions
- API contracts
- Database transactions
- External service calls
- Error propagation

### E2E Tests
- User workflows
- Multi-step scenarios
- Cross-component flows
- Real data variations

### Performance Tests
- High load scenarios
- Concurrent operations
- Large datasets
- Timeout scenarios

### Security Tests
- Authentication bypass
- Authorization issues
- Injection attacks
- XSS/CSRF
- Data exposure

## Edge Case Checklist

Use this checklist for any requirement:

- [ ] **Boundary values** - Min, max, zero, just above/below limits
- [ ] **Empty/null** - Missing data, empty strings, null, undefined
- [ ] **Invalid input** - Wrong type, wrong format, malicious content
- [ ] **Excessive input** - Very long strings, very large numbers, deep nesting
- [ ] **Concurrent access** - Race conditions, simultaneous operations
- [ ] **Failure modes** - Network errors, database down, timeouts
- [ ] **State dependencies** - Order of operations, prerequisites
- [ ] **Timing issues** - Date boundaries, time zones, DST, leap seconds
- [ ] **Security vectors** - Injection, XSS, CSRF, authorization bypass
- [ ] **Performance extremes** - Large datasets, high concurrency
- [ ] **Data variations** - Unicode, special chars, case sensitivity
- [ ] **Browser/platform differences** - Cross-browser, mobile vs desktop
- [ ] **Localization** - Different languages, currencies, date formats
- [ ] **Accessibility** - Screen readers, keyboard navigation

## Resources

### Testing Techniques
- [Boundary Value Analysis](https://www.guru99.com/boundary-value-testing.html)
- [Equivalence Partitioning](https://www.softwaretestinghelp.com/what-is-equivalence-partitioning/)
- [Pairwise Testing](https://www.pairwise.org/)

### Security Testing
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

### Tools
- [Hypothesis](https://hypothesis.readthedocs.io/) - Property-based testing (Python)
- [fast-check](https://github.com/dubzzz/fast-check) - Property-based testing (JavaScript)
- [OWASP ZAP](https://www.zaproxy.org/) - Security testing

## Quick Reference

### Common Boundary Values

**Integers:**
- 0, 1, -1
- MIN_INT (-2,147,483,648)
- MAX_INT (2,147,483,647)
- Just before/after any business limit

**Strings:**
- "" (empty)
- " " (whitespace)
- Single character
- Exactly at max length
- One over max length
- Unicode characters

**Arrays:**
- [] (empty)
- [single item]
- At capacity
- Over capacity

**Dates:**
- Jan 1, 1970 (epoch)
- Dec 31, 9999 (far future)
- Today's date
- Yesterday/tomorrow
- Month/year boundaries
- Leap day (Feb 29)
- DST transitions

**Money:**
- $0.00
- $0.01 (minimum)
- Negative amounts
- Very large amounts
- Fractional cents ($10.001)
