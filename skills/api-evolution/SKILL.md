---
name: api-evolution
description: Validates API changes for contract safety and consumer impact, including versioning strategies and backward compatibility. Use when creating new endpoints, modifying existing APIs, or when the user mentions API changes, versioning, or breaking changes.
---

# API / Endpoint Evolution

## Purpose

Validate API changes for contract safety, consumer impact, and ensure smooth evolution without breaking existing clients.

## When to Use

- Creating new API endpoints
- Modifying existing API contracts
- API versioning decisions
- Deprecating old endpoints
- Major version releases
- API gateway configuration changes

## API Evolution Principles

### 1. Backward Compatibility First

❌ **Breaking**: Change existing field type
✅ **Compatible**: Add new optional field

### 2. Explicit Versioning

Options:
- URL versioning: `/v1/users`, `/v2/users`
- Header versioning: `Accept: application/vnd.api+json;version=2`
- Query parameter: `/users?version=2`

### 3. Graceful Deprecation

- Announce deprecation timeline
- Provide migration guide
- Support old version during transition
- Monitor usage before removal

## API Change Validation Checklist

### Adding New Endpoint

```markdown
✅ **Safe additions**:
- New endpoint path
- New optional query parameters
- New optional request headers
- New response fields
- New error codes

⚠️ **Considerations**:
- [ ] OpenAPI spec updated
- [ ] Authentication/authorization rules defined
- [ ] Rate limiting configured
- [ ] Monitoring/alerts set up
- [ ] Documentation published
- [ ] Client SDKs updated (if applicable)
```

### Modifying Existing Endpoint

```markdown
❌ **Breaking changes** (require new version):
- Removing fields from response
- Renaming fields
- Changing field types (string → number)
- Making optional field required
- Changing error response structure
- Removing query parameters
- Changing URL path
- Changing HTTP method

✅ **Non-breaking changes**:
- Adding optional fields to response
- Adding optional query parameters
- Adding optional request headers
- Making required field optional
- Adding new error codes (with same structure)
- Performance improvements (same contract)

⚠️ **Potentially breaking** (test with consumers):
- Changing validation rules (stricter)
- Changing rate limits (lower)
- Changing response size (larger)
- Adding pagination (when previously unpaged)
- Changing default values
```

## API Versioning Strategies

### Strategy 1: URL Versioning (Recommended)

```
GET /v1/users
GET /v2/users
```

**Pros**:
- Explicit and visible
- Easy to route in API gateway
- Clear deprecation path
- Cache-friendly

**Cons**:
- Version in every URL
- More routes to maintain

**Best for**: Public APIs, REST APIs

### Strategy 2: Header Versioning

```
GET /users
Accept: application/vnd.company.v2+json
```

**Pros**:
- URLs stay clean
- Content negotiation standard
- Can version resources independently

**Cons**:
- Less visible (hidden in headers)
- Harder to test (need header tools)
- Cache complexity

**Best for**: Internal APIs, GraphQL

### Strategy 3: Query Parameter

```
GET /users?api_version=2
```

**Pros**:
- Easy to implement
- URLs relatively clean
- Optional (default to latest)

**Cons**:
- Inconsistent (different from REST conventions)
- Query params usually for filtering, not versioning

**Best for**: Transition period, backward compatibility layer

### Strategy 4: No Versioning (Evolutionary)

Always backward compatible, never break contracts.

**Pros**:
- Simplest for clients
- No version management overhead

**Cons**:
- Constrains changes significantly
- Can't fix past mistakes
- API becomes bloated over time

**Best for**: Internal microservices, GraphQL schemas

## Example: API Change Analysis

### Scenario: Update User Endpoint

**Current (v1)**:
```json
GET /v1/users/123

Response:
{
  "id": "123",
  "name": "John Doe",
  "email": "john@example.com",
  "created": "2024-01-15"
}
```

**Proposed Changes**:
1. Add `preferences` object
2. Change `created` from string to ISO timestamp
3. Split `name` into `firstName` and `lastName`
4. Add `isActive` boolean

### Analysis

```markdown
## Change Assessment

### Change 1: Add `preferences` object
**Type**: Addition (optional field)
**Breaking**: ❌ No
**Impact**: None (clients ignore unknown fields)
**Recommendation**: ✅ Add to v1

### Change 2: Change `created` format
**Type**: Modification (data format change)
**Breaking**: ✅ Yes
**Impact**: High - clients parsing dates will break
**Recommendation**: ⚠️ Requires new version

### Change 3: Split `name` field
**Type**: Removal + Addition
**Breaking**: ✅ Yes
**Impact**: Critical - clients using `name` will break
**Recommendation**: ⚠️ Requires new version

### Change 4: Add `isActive` boolean
**Type**: Addition (optional field)
**Breaking**: ❌ No
**Impact**: None
**Recommendation**: ✅ Add to v1
```

### Recommended Approach

**Option A: Create v2 with all changes**

```json
GET /v2/users/123

Response:
{
  "id": "123",
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "created": "2024-01-15T10:30:00Z",
  "isActive": true,
  "preferences": {
    "theme": "dark",
    "language": "en"
  }
}
```

**Option B: Gradual evolution (backward compatible)**

```json
GET /v1/users/123

Response:
{
  "id": "123",
  "name": "John Doe",           // Keep for compatibility
  "firstName": "John",           // Add new fields
  "lastName": "Doe",
  "email": "john@example.com",
  "created": "2024-01-15",       // Keep old format
  "createdAt": "2024-01-15T10:30:00Z",  // Add new format
  "isActive": true,
  "preferences": {
    "theme": "dark",
    "language": "en"
  }
}
```

Deprecation notice:
```json
Response Headers:
Deprecation: true
Sunset: Sat, 1 June 2026 23:59:59 GMT
Link: </v2/users/123>; rel="successor-version"
```

## Consumer Impact Analysis

### Identify Consumers

```markdown
**Known consumers**:
1. Web App (React) - 100% traffic
2. Mobile App (iOS/Android) - 40% traffic
3. Partner API (3 partners) - 5% traffic
4. Internal Admin Tool - 2% traffic
5. Analytics Pipeline - Batch, nightly

**Consumer versions**:
- Web App: Auto-updates (always latest)
- Mobile App: iOS 95% on v3.2+, Android 88% on v2.1+
- Partners: Unknown versions (need to contact)
- Admin Tool: v1.5 (6 months old)
- Analytics: Hardcoded v1 schema
```

### Impact Assessment Matrix

| Consumer | Version | Breaking Change Impact | Migration Effort | Timeline |
|----------|---------|------------------------|------------------|----------|
| Web App | Latest | Low (auto-update) | 1 week | Can migrate immediately |
| Mobile iOS | v3.2+ | Medium (app store delay) | 2 weeks | 2 weeks + store approval |
| Mobile Android | v2.1+ | Medium (phased rollout) | 2 weeks | 2 weeks + rollout |
| Partner APIs | Unknown | High (need coordination) | Unknown | 3+ months |
| Admin Tool | v1.5 | Medium (infrequent updates) | 1 week | 1 month deployment cycle |
| Analytics | Hardcoded | High (batch job) | 1 week | Next sprint |

**Conclusion**: Need 3-month transition period for partner migration

### Migration Plan

```markdown
## Timeline

**T-90 days** (March 1):
- Announce v2, deprecate v1
- Publish migration guide
- Email all known consumers
- Set sunset date: June 1

**T-60 days** (April 1):
- Contact partners directly
- Offer migration support
- Track v1 vs v2 usage

**T-30 days** (May 1):
- Add deprecation headers to v1
- Warning logs for v1 usage
- Reminder emails

**T-0 days** (June 1):
- Disable v1 for new requests
- Return 410 Gone with migration link

**T+30 days** (July 1):
- Remove v1 completely (if usage < 1%)
- Decommission infrastructure
```

## API Contract Validation

### OpenAPI Specification

**v1 Spec**:
```yaml
/v1/users/{id}:
  get:
    parameters:
      - name: id
        in: path
        required: true
        schema:
          type: string
    responses:
      '200':
        description: User found
        content:
          application/json:
            schema:
              type: object
              required:
                - id
                - name
                - email
                - created
              properties:
                id:
                  type: string
                name:
                  type: string
                email:
                  type: string
                  format: email
                created:
                  type: string
                  format: date
```

**Breaking Change Detection**:
```bash
# Use openapi-diff tool
npx openapi-diff v1-spec.yaml v2-spec.yaml

Output:
Breaking changes detected:
- Removed required field: 'name' in GET /users/{id} response
- Changed type: 'created' from 'string' to 'string (date-time)'
```

### Contract Testing

```typescript
// Consumer-driven contract test (Pact)
describe('User API v1', () => {
  it('returns expected user structure', async () => {
    const response = await api.get('/v1/users/123');
    
    expect(response.data).toMatchSchema({
      id: expect.any(String),
      name: expect.any(String),
      email: expect.stringMatching(/^\S+@\S+$/),
      created: expect.stringMatching(/^\d{4}-\d{2}-\d{2}$/)
    });
  });
});
```

## Error Model Consistency

### Standardized Error Response

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

### Error Evolution

```markdown
✅ **Safe changes**:
- Add new error codes
- Add optional fields to error object
- Improve error messages
- Add `details` field

❌ **Breaking changes**:
- Remove error codes clients depend on
- Change error structure shape
- Change HTTP status codes for errors
- Remove required error fields
```

## Versioning Best Practices

### 1. Semantic Versioning for APIs

- **Major** (v1 → v2): Breaking changes
- **Minor** (v2.1 → v2.2): New features, backward compatible
- **Patch** (v2.2.1 → v2.2.2): Bug fixes, no API changes

### 2. Deprecation Headers

```http
HTTP/1.1 200 OK
Deprecation: true
Sunset: Sat, 1 Jun 2026 23:59:59 GMT
Link: </v2/users/123>; rel="successor-version"
```

### 3. Version Discovery

```http
GET /

Response:
{
  "versions": {
    "v1": {
      "status": "deprecated",
      "sunset": "2026-06-01",
      "docs": "https://api.company.com/docs/v1"
    },
    "v2": {
      "status": "current",
      "docs": "https://api.company.com/docs/v2"
    }
  }
}
```

### 4. Monitor Version Usage

```javascript
// Track API version usage
app.use((req, res, next) => {
  const version = extractVersion(req); // v1, v2, etc.
  metrics.increment('api.version', { version });
  
  if (version === 'v1') {
    logger.warn('v1 API usage', {
      endpoint: req.path,
      consumer: req.headers['user-agent'],
      ip: req.ip
    });
  }
  
  next();
});
```

## Migration Guide Template

```markdown
# Migration Guide: v1 → v2

## Overview
v2 introduces improved data consistency and better field naming.

## Breaking Changes

### 1. `name` field split into `firstName` and `lastName`

**v1**:
\`\`\`json
{ "name": "John Doe" }
\`\`\`

**v2**:
\`\`\`json
{ 
  "firstName": "John",
  "lastName": "Doe"
}
\`\`\`

**Migration**:
\`\`\`javascript
// Old code
const fullName = user.name;

// New code
const fullName = `${user.firstName} ${user.lastName}`;
\`\`\`

### 2. `created` field now ISO 8601 timestamp

**v1**: `"2024-01-15"` (date only)
**v2**: `"2024-01-15T10:30:00Z"` (full timestamp)

**Migration**:
\`\`\`javascript
// Old code
const date = new Date(user.created);

// New code (same, but more precise)
const date = new Date(user.createdAt);
\`\`\`

## New Features

### `preferences` object
New optional field for user preferences:
\`\`\`json
{
  "preferences": {
    "theme": "dark",
    "language": "en"
  }
}
\`\`\`

### `isActive` boolean
Indicates if user account is active:
\`\`\`json
{ "isActive": true }
\`\`\`

## Timeline
- **Now**: v1 and v2 both supported
- **March 1**: v1 deprecated
- **June 1**: v1 removed

## Support
Questions? Contact api-support@company.com
```

## Resources

### API Versioning
- [Stripe API Versioning](https://stripe.com/blog/api-versioning) - Industry best practice
- [REST API Versioning Strategies](https://www.baeldung.com/rest-versioning)
- [Semantic Versioning](https://semver.org/)

### API Design
- [API Design Patterns](https://www.apiscene.io/api-design/)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [Google API Design Guide](https://cloud.google.com/apis/design)

### Tools
- [OpenAPI Diff](https://github.com/OpenAPITools/openapi-diff) - Detect breaking changes
- [Pact](https://pact.io/) - Consumer-driven contract testing
- [Spectral](https://stoplight.io/open-source/spectral) - OpenAPI linting

## Quick Checklist

- [ ] Change type identified (breaking vs compatible)
- [ ] OpenAPI spec updated
- [ ] Contract tests updated
- [ ] All consumers identified
- [ ] Impact assessed per consumer
- [ ] Migration effort estimated
- [ ] Deprecation timeline set (if breaking)
- [ ] Migration guide written
- [ ] Deprecation headers added
- [ ] Usage monitoring configured
- [ ] Communication sent to consumers
- [ ] Rollback plan documented
