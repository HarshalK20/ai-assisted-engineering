---
name: artifact-review
description: Pre-reviews designs, documentation, or code for risks, unstated assumptions, and operational considerations before formal review. Use when preparing for code review, design review, or when the user mentions artifact review, design validation, or risk assessment.
---

# Artifact Review Accelerator

## Purpose

Pre-review designs, docs, or code for risks, assumptions, and gaps before formal human review.

## When to Use

- Before submitting design documents for formal review
- Prior to architecture review meetings
- Before creating pull requests (supplement to pre-PR check)
- When working under tight deadlines
- For comprehensive artifacts (large RFCs, system designs)
- Before stakeholder presentations

## Review Dimensions

### 1. Completeness

Is everything needed present?

```markdown
Missing elements checklist:
- [ ] Problem statement clearly defined
- [ ] Success criteria specified
- [ ] All stakeholders identified
- [ ] Dependencies documented
- [ ] Risks assessed
- [ ] Alternatives considered
- [ ] Testing strategy defined
- [ ] Rollout plan outlined
- [ ] Monitoring/observability plan
- [ ] Cost implications calculated
- [ ] Timeline with milestones
- [ ] Rollback procedure documented
```

### 2. Unstated Assumptions

What are we taking for granted?

```markdown
Common hidden assumptions:
- "Users have reliable internet" (what about offline?)
- "Database always available" (what about failures?)
- "Data fits in memory" (what about scale?)
- "Users understand English" (what about i18n?)
- "Current team maintains this" (what about turnover?)
- "Infrastructure costs stay constant" (what about growth?)
- "Third-party APIs reliable" (what about downtime?)
```

### 3. Scalability Risks

Will this work at 10x, 100x scale?

```markdown
Scalability questions:
- Current load: X requests/second
- Expected load: Y requests/second (when?)
- What breaks first at 10x load?
- Database capacity limits
- Network bandwidth requirements
- Memory footprint per user/request
- Storage growth rate
- Cost scaling (linear vs exponential?)
```

### 4. Operational Considerations

Day 2+ operations:

```markdown
Operational gaps:
- [ ] Deployment process documented
- [ ] Monitoring dashboards defined
- [ ] Alert thresholds specified
- [ ] On-call runbooks created
- [ ] Backup/restore procedures
- [ ] Disaster recovery plan
- [ ] Performance tuning guidelines
- [ ] Cost monitoring set up
- [ ] Log aggregation configured
- [ ] Debug/troubleshooting tools
```

### 5. Security Vulnerabilities

Common security gaps:

```markdown
Security review:
- [ ] Authentication required
- [ ] Authorization rules defined
- [ ] Input validation specified
- [ ] SQL injection prevented
- [ ] XSS prevented
- [ ] CSRF protection enabled
- [ ] Rate limiting configured
- [ ] Sensitive data encrypted
- [ ] PII handling compliant
- [ ] Audit logging enabled
- [ ] Secret management defined
- [ ] Dependency vulnerabilities checked
```

### 6. Edge Cases & Error Handling

What could go wrong:

```markdown
Error scenarios:
- [ ] Null/undefined inputs handled
- [ ] Network timeouts handled
- [ ] Database connection failures
- [ ] Third-party API failures
- [ ] Partial failures (some succeed, some fail)
- [ ] Retry logic with backoff
- [ ] Circuit breaker for cascading failures
- [ ] User-facing error messages
- [ ] Error reporting/alerting
```

### 7. Cost Implications

Total cost of ownership:

```markdown
Cost analysis:
- [ ] Infrastructure costs calculated
  - Compute (servers, containers, functions)
  - Storage (database, object storage, cache)
  - Network (bandwidth, data transfer)
  - Third-party services (APIs, SaaS)
- [ ] Operational costs estimated
  - Engineering time to maintain
  - On-call burden
  - Support tickets
- [ ] Cost per user/request calculated
- [ ] Cost scaling analyzed
- [ ] Budget approved
```

## Example Reviews

### Example 1: Design Document Review

**Artifact**: Caching Layer Design Doc

**Review Output**:

```markdown
## Artifact Review: Redis Caching Layer

### ✅ Strengths
- Clear problem statement (P95 latency too high)
- Quantified goals (reduce from 800ms to 200ms)
- Technology choice justified (Redis vs Memcached)
- Cache invalidation strategy defined

### ⚠️ Unstated Assumptions

**Assumption 1**: "Redis instance will always be available"
- **Risk**: If Redis down, all requests hit database
- **Recommendation**: Add fallback logic, fail open (bypass cache on Redis error)

**Assumption 2**: "Cache hit rate will be 80%+"
- **Risk**: If hit rate lower, database load actually increases
- **Recommendation**: Add monitoring for hit rate, alert if < 70%

**Assumption 3**: "Hot keys evenly distributed"
- **Risk**: Some keys accessed 1000x more (celebrity problem)
- **Recommendation**: Consider separate cache tier for hot keys

### 🚨 Scalability Risks

**Risk 1**: Memory capacity
- **Current plan**: 8GB Redis instance
- **Analysis**: At 10KB per cached object, ~800K objects max
- **Question**: What happens at 1M objects? Document eviction policy.
- **Recommendation**: Define max objects, monitoring, auto-scaling strategy

**Risk 2**: Single point of failure
- **Current plan**: Single Redis instance
- **Analysis**: Downtime = cache miss storm → database overload
- **Recommendation**: Redis Sentinel (HA) or Redis Cluster (sharding)

### 🛠️ Operational Gaps

**Gap 1**: No cache warming strategy
- **Issue**: After deploy, all cache misses → database spike
- **Recommendation**: Pre-warm cache with top N queries on startup

**Gap 2**: No cache monitoring defined
- **Missing metrics**: 
  - Hit/miss rate
  - Eviction rate
  - Memory usage
  - Latency P50/P95/P99
- **Recommendation**: Add metrics, create dashboard

**Gap 3**: No runbook for cache issues
- **Scenarios not covered**:
  - Cache consistently returns stale data
  - Cache memory full (thrashing)
  - Cache much slower than expected
- **Recommendation**: Create troubleshooting runbook

### 💰 Cost Implications

**Current cost estimate**: $200/month (8GB instance)
- **At 10x scale**: $2,000/month (80GB or cluster)
- **At 100x scale**: $20,000/month
- **Missing**: Cost comparison vs database scaling
- **Recommendation**: Include ROI analysis (cache cost vs database cost savings)

### 🔒 Security Considerations

**Issue 1**: No authentication mentioned
- **Risk**: Unprotected Redis accessible from network
- **Recommendation**: Enable Redis AUTH, network isolation

**Issue 2**: Cached data may contain PII
- **Risk**: Compliance issues (GDPR, CCPA)
- **Recommendation**: Document PII handling, TTL for sensitive data

### 📊 Missing Information

- [ ] Rollback plan (if caching makes things worse)
- [ ] A/B test strategy (gradual cache rollout)
- [ ] Cache key naming convention
- [ ] TTL strategy per data type
- [ ] Cache invalidation on data updates (how?)
- [ ] Performance benchmarks (expected improvement)

### ✅ Recommendations Summary

**Before approval**:
1. Add fallback logic for Redis unavailability
2. Define monitoring metrics and alerts
3. Create operational runbook
4. Document cache warming strategy
5. Include security (auth, network isolation)
6. Add cost analysis at different scales

**Nice to have**:
7. Consider HA setup (Redis Sentinel)
8. A/B test plan for gradual rollout
9. Performance benchmarks

### Overall Assessment
**Status**: ⚠️ **Needs revisions before approval**
**Effort to address**: ~2 days
**Risk if not addressed**: Medium-High (operational issues, downtime)
```

### Example 2: Code Review Pre-Check

**Artifact**: Pull Request for Payment Processing

**Review Output**:

```markdown
## PR Pre-Review: Payment Processing Refactor

### ✅ Code Quality
- Well-structured, follows coding standards
- Good test coverage (85%)
- Clear variable names

### ⚠️ Potential Issues

**Issue 1: Unhandled Network Timeout**
\`\`\`python
# Line 45
response = requests.post(payment_api_url, data=payment_data)
\`\`\`
**Problem**: No timeout specified, could hang indefinitely
**Fix**: Add timeout parameter
\`\`\`python
response = requests.post(payment_api_url, data=payment_data, timeout=30)
\`\`\`

**Issue 2: SQL Injection Risk**
\`\`\`python
# Line 78
query = f"SELECT * FROM payments WHERE user_id = {user_id}"
\`\`\`
**Problem**: String interpolation vulnerable to SQL injection
**Fix**: Use parameterized query
\`\`\`python
query = "SELECT * FROM payments WHERE user_id = %s"
cursor.execute(query, (user_id,))
\`\`\`

**Issue 3: Missing Error Logging**
\`\`\`python
# Line 102
except Exception as e:
    return {"error": "Payment failed"}
\`\`\`
**Problem**: Exception swallowed, no logging
**Fix**: Log exception before returning
\`\`\`python
except Exception as e:
    logger.error(f"Payment failed for user {user_id}", exc_info=True)
    return {"error": "Payment failed"}
\`\`\`

### 🔒 Security Concerns

**Concern 1**: Credit card data in logs
\`\`\`python
# Line 55
logger.info(f"Processing payment: {payment_data}")
\`\`\`
**Risk**: PCI-DSS violation, sensitive data in logs
**Fix**: Redact sensitive fields
\`\`\`python
logger.info(f"Processing payment for user {user_id}")
\`\`\`

**Concern 2**: No rate limiting
**Risk**: User can submit 1000 payment requests/second
**Fix**: Add rate limiting decorator

### 🎯 Missing Test Cases

**Untested scenarios**:
- Payment provider timeout
- Payment provider returns 500 error
- Duplicate payment (same idempotency key)
- Amount = 0
- Amount > account limit
- Invalid currency code
- Network disconnection mid-request

### 📊 Observability Gaps

**Missing metrics**:
- Payment success/failure rate
- Payment processing latency
- Provider error breakdown by type

**Recommendation**: Add metrics
\`\`\`python
metrics.increment('payment.attempts', tags={'provider': provider_name})
metrics.histogram('payment.latency', duration)
\`\`\`

### ✅ Before Merging

**Must fix** (blocking):
1. Fix SQL injection vulnerability (line 78)
2. Add timeout to API call (line 45)
3. Remove sensitive data from logs (line 55)

**Should fix** (strong recommendation):
4. Add error logging (line 102)
5. Add missing test cases
6. Add observability metrics

**Nice to have**:
7. Add rate limiting
8. Refactor large function (processPayment 150 lines)

### Overall Assessment
**Status**: 🚨 **Do not merge** (security issues)
**Estimated fix time**: 2-3 hours
```

## Review Templates

### Design Document Review Template

```markdown
## Design Review: [Title]

### Summary
[One paragraph: What is this and your overall assessment]

### Strengths
- [What's done well]
- [Clear aspects]

### Unstated Assumptions
1. [Assumption] → [Risk if wrong] → [Recommendation]
2. [Assumption] → [Risk if wrong] → [Recommendation]

### Scalability Concerns
- **Current scale**: [Numbers]
- **Expected scale**: [Numbers + timeline]
- **Breaks at**: [What fails first, at what scale]
- **Recommendation**: [How to address]

### Operational Gaps
- [ ] [Missing operational aspect]
- [ ] [Missing monitoring/alerting]
- [ ] [Missing runbook]

### Security Issues
- 🔒 [Security concern] → [Recommendation]

### Cost Analysis
- **Current estimate**: $X/month
- **At 10x scale**: $Y/month
- **Missing**: [Cost aspects not covered]

### Missing Information
- [ ] [What's not documented]

### Recommendations
**Must address before approval**:
1. [Critical item]

**Should address**:
2. [Important item]

**Nice to have**:
3. [Optional improvement]

### Overall Assessment
**Status**: [✅ Approved | ⚠️ Needs Revisions | 🚨 Major Issues]
**Confidence**: [High/Medium/Low]
**Estimated effort to address**: [Time]
```

## STRIDE Threat Model

For security-critical components:

- **S**poofing: Can attacker impersonate user/system?
- **T**ampering: Can attacker modify data in transit/rest?
- **R**epudiation: Can user deny actions they performed?
- **I**nformation Disclosure: Can attacker access sensitive data?
- **D**enial of Service: Can attacker make system unavailable?
- **E**levation of Privilege: Can attacker gain higher access?

## Resources

### Review Frameworks
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Google SRE Book - Design Reviews](https://sre.google/sre-book/design-for-reliability/)
- [Microsoft Security Development Lifecycle](https://www.microsoft.com/en-us/securityengineering/sdl)

### Threat Modeling
- [STRIDE Threat Model](https://en.wikipedia.org/wiki/STRIDE_(security))
- [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling)

### Code Review
- [Google Engineering Practices](https://google.github.io/eng-practices/review/)
- [Code Review Best Practices](https://phauer.com/2018/code-review-guidelines/)

## Quick Checklist

- [ ] Problem clearly stated
- [ ] Success criteria defined
- [ ] Assumptions identified and validated
- [ ] Scalability analyzed (10x, 100x)
- [ ] Operational plan (deploy, monitor, debug)
- [ ] Security reviewed (STRIDE)
- [ ] Edge cases considered
- [ ] Cost calculated (now and at scale)
- [ ] Dependencies documented
- [ ] Risks assessed with mitigation
- [ ] Rollback plan exists
- [ ] Testing strategy defined
- [ ] Documentation complete
