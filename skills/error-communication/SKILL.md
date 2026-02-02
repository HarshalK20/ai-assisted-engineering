---
name: error-communication
description: Translates complex backend validation logic and technical errors into clear, actionable user messages. Use when designing API errors, form validation UX, error state documentation, or when the user mentions error messages, validation, or user feedback.
---

# Backend Rules to User-Facing Error Communication

## Purpose

Translate complex validation logic and technical errors into clear, actionable messages that help users succeed.

## When to Use

- Designing API error responses
- Creating form validation messages
- Error state documentation
- User-facing error pages (404, 500, etc.)
- Mobile app error handling
- Payment and transaction flows

## Core Principles

### 1. Be Human

❌ **Technical**: `VALIDATION_ERROR_003: Field constraint violation`
✅ **Human**: `Email address is required`

### 2. Be Specific

❌ **Vague**: `Invalid input`
✅ **Specific**: `Password must be at least 8 characters`

### 3. Be Actionable

❌ **Dead end**: `Transaction failed`
✅ **Actionable**: `Transaction failed. Please check your payment method or try a different card`

### 4. Be Empathetic

❌ **Blaming**: `You entered an invalid date`
✅ **Empathetic**: `This date format isn't recognized. Try MM/DD/YYYY`

## Error Message Framework

Every error message should answer:

1. **What happened?** - Clear description of the error
2. **Why did it happen?** - Context (if helpful)
3. **What can I do?** - Specific next action

```
Format:
[What happened]. [Why]. [What to do].

Example:
"File upload failed. File size exceeds 5MB limit. Try compressing your image or choose a smaller file."
```

## Translation Examples

### Example 1: Complex Business Rule

**Backend Logic:**
```
Rule: Transaction amount cannot exceed daily limit AND 
must be within account balance AND cannot trigger fraud 
detection threshold (3 transactions > $500 in 1 hour)

Current error: VALIDATION_ERROR_003
```

**User Messages:**

```markdown
Scenario 1: Daily limit exceeded
❌ "Transaction violates daily limit constraint"
✅ "Daily spending limit reached ($2,000). Try again tomorrow or contact support to increase your limit."

Scenario 2: Insufficient balance
❌ "Account balance constraint violation"
✅ "Insufficient funds. Your balance is $450.23, but this transaction requires $500.00."

Scenario 3: Fraud threshold
❌ "Fraud detection threshold exceeded"
✅ "For your security, we've paused large transactions. Verify this transaction via the email we just sent you."

Scenario 4: Multiple issues
❌ "Multiple validation errors"
✅ "This transaction can't be completed because:
    • Amount exceeds your daily limit ($2,000)
    • Insufficient funds (need $500, have $450)
    Contact support if you need assistance."
```

### Example 2: Form Validation

**Backend Validation:**
```
Field: email
Rules:
- Required
- Valid email format
- Not already registered
- From allowed domain (@company.com only)
```

**User Messages:**

```markdown
❌ Empty field:
Bad: "Email validation failed"
Good: "Email address is required"

❌ Invalid format:
Bad: "Email format invalid"
Good: "Please enter a valid email address (e.g., name@company.com)"

❌ Already exists:
Bad: "Email already in database"
Good: "This email is already registered. Try logging in instead?"

❌ Wrong domain:
Bad: "Domain not allowed"
Good: "Please use your company email address (@company.com)"
```

### Example 3: API Error Responses

**Technical Error:**
```
HTTP 429 - Rate limit exceeded
Internal: "Client exceeded 100 requests per minute quota"
```

**User-Facing Error:**

```json
{
  "error": {
    "message": "Too many requests. Please wait a moment and try again.",
    "code": "RATE_LIMIT_EXCEEDED",
    "details": {
      "retryAfter": 45,
      "suggestion": "You can try again in 45 seconds."
    }
  }
}
```

**User Message Variations:**

```markdown
For developers (API docs):
"Rate limit: 100 requests/minute. Exceeded quota. Retry after 45 seconds. Check Retry-After header."

For end users (UI):
"We received too many requests. Please wait 45 seconds and try again."

For mobile app:
"Please slow down! Wait 45 seconds before trying again."
```

### Example 4: File Upload Errors

**Backend Rules:**
```
- Max size: 5MB
- Allowed: JPG, PNG, PDF
- No viruses
- Max dimensions: 4096x4096
- Valid file header
```

**User Messages:**

```markdown
File too large:
❌ "MAX_SIZE_EXCEEDED"
✅ "This file is too large (8.2MB). Maximum size is 5MB. Try compressing it or choose a different file."

Wrong format:
❌ "INVALID_FILE_TYPE"
✅ "This file type isn't supported. Please upload a JPG, PNG, or PDF file."

Virus detected:
❌ "SECURITY_SCAN_FAILED"
✅ "For security reasons, this file can't be uploaded. It may contain harmful content."

Corrupted file:
❌ "INVALID_FILE_HEADER"
✅ "This file appears to be corrupted. Try exporting it again or choose a different file."

Dimensions too large:
❌ "IMAGE_DIMENSIONS_EXCEEDED"
✅ "This image is too large (5000x5000). Maximum size is 4096x4096 pixels. Try resizing it first."
```

### Example 5: Payment Errors

**Backend Errors from Payment Provider:**

```markdown
Card declined:
❌ "PAYMENT_DECLINED_05"
✅ "Your card was declined. Please check your card details or try a different payment method."

Insufficient funds:
❌ "INSUFFICIENT_FUNDS_51"
✅ "Payment failed due to insufficient funds. Please use a different card or payment method."

Expired card:
❌ "CARD_EXPIRED_54"
✅ "This card has expired. Please update your card information or use a different card."

CVV mismatch:
❌ "CVV_VERIFICATION_FAILED"
✅ "Security code doesn't match. Please check the 3-digit code on the back of your card."

3D Secure failed:
❌ "3DS_AUTHENTICATION_FAILED"
✅ "Card verification failed. Contact your bank to enable online transactions or try a different card."
```

## Error Message Patterns

### Pattern 1: Validation Errors

```
Template:
"[Field] [problem]. [Requirement]."

Examples:
• "Email address is invalid. Please enter a valid email."
• "Password is too short. Use at least 8 characters."
• "Start date must be before end date. Please adjust your dates."
```

### Pattern 2: Permission Errors

```
Template:
"You don't have permission to [action]. [What to do]."

Examples:
• "You don't have permission to delete this file. Contact the owner to request access."
• "This feature requires admin privileges. Ask your team admin for access."
• "You've reached your plan limit. Upgrade to continue using this feature."
```

### Pattern 3: System Errors

```
Template:
"Something went wrong [where]. [Reassurance]. [What to do]."

Examples:
• "Something went wrong saving your changes. Don't worry, your work is safe. Please try again."
• "We couldn't load this page. This is temporary. Refresh the page or try again in a moment."
• "Connection lost. Check your internet connection and we'll retry automatically."
```

### Pattern 4: Not Found Errors

```
Template:
"[Item] not found. [Possible reason]. [What to do]."

Examples:
• "Page not found. This link may be outdated. Return to homepage or search for what you need."
• "User not found. They may have deleted their account. Double-check the username."
• "File not found. It may have been moved or deleted. Check with the owner."
```

## Microcopy Best Practices

### Use Plain Language

| Technical | Plain Language |
|-----------|----------------|
| "Authentication failed" | "Incorrect password" |
| "Null value not permitted" | "This field is required" |
| "Integer overflow" | "This number is too large" |
| "Database connection timeout" | "We're having connection issues" |
| "Malformed request syntax" | "Something's wrong with this request" |

### Be Consistent

Use the same terms across your product:

- Always "email address" not mixing with "email", "e-mail"
- Always "password" not mixing with "passcode", "PIN"
- Always "username" not mixing with "user name", "login"

### Show Progress

For multi-step validations:

```markdown
❌ Generic:
"Form validation failed"

✅ Specific:
"2 fields need attention:
 • Email address is required
 • Password must be at least 8 characters"
```

### Use Positive Language

```markdown
❌ Negative:
"Don't use special characters"

✅ Positive:
"Use only letters, numbers, and underscores"

❌ Negative:
"File upload prohibited"

✅ Positive:
"Choose a file under 5MB to upload"
```

## Technical Implementation

### Error Message Structure (JSON)

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Password must be at least 8 characters",
    "field": "password",
    "severity": "error",
    "help": "Choose a password with at least 8 characters, including letters and numbers",
    "documentation": "https://docs.example.com/password-requirements"
  }
}
```

### Error Severity Levels

```markdown
1. **Info** (FYI, no action needed)
   "Your session will expire in 5 minutes"

2. **Warning** (Action recommended)
   "Your storage is 90% full. Consider deleting old files"

3. **Error** (Action required)
   "Password is required. Please enter your password"

4. **Critical** (Blocking, urgent)
   "Your account has been locked. Contact support immediately"
```

## Internationalization Considerations

### Keep It Simple for Translation

❌ **Complex**: "You've got to enter a valid email or we can't proceed"
✅ **Simple**: "Please enter a valid email address"

### Avoid Idioms and Slang

❌ **Idiom**: "Oops! That didn't fly"
✅ **Clear**: "Upload failed"

### Use Placeholders for Dynamic Content

```
❌ Hard-coded:
"File must be smaller than 5MB"

✅ Parameterized:
"File must be smaller than {maxSize}MB"
```

## Accessibility

### Screen Reader Friendly

```html
<!-- Associate error with field -->
<input 
  type="email" 
  id="email"
  aria-describedby="email-error"
  aria-invalid="true"
>
<span id="email-error" role="alert">
  Please enter a valid email address
</span>
```

### Visual Indicators

- ✓ Use color + icon (not color alone)
- ✓ Position error near the field
- ✓ Use sufficient contrast (WCAG AA)

## Resources

### Guidelines
- [Nielsen Norman Group: Error Messages](https://www.nngroup.com/articles/error-message-guidelines/)
- [Material Design: Error Messages](https://material.io/design/communication/writing.html#error-messages)
- [GOV.UK Design System: Error Messages](https://design-system.service.gov.uk/components/error-message/)

### Tools
- [Hemingway Editor](http://www.hemingwayapp.com/) - Simplify complex messages
- [Readable.com](https://readable.com/) - Check readability score

## Quick Checklist

- [ ] Message explains what happened
- [ ] Tells user what to do next
- [ ] Uses plain language (no jargon)
- [ ] Is specific (not generic "error")
- [ ] Is empathetic (doesn't blame user)
- [ ] Is concise (one or two sentences)
- [ ] Suggests solution or next step
- [ ] Consistent with other messages
- [ ] Accessible (screen reader friendly)
- [ ] Ready for translation (if applicable)
