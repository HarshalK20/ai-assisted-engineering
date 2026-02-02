---
name: create-adr
description: Extracts architectural decisions and trade-offs from discussions into formal Architecture Decision Records (ADRs). Use when documenting design decisions, after architecture discussions, following design reviews, or when the user mentions ADR, architecture decisions, or trade-off analysis.
---

# Discussion to Architectural Decision Record (ADR)

## Purpose

Extract decisions and trade-offs from conversations into formal Architecture Decision Records for future reference and context.

## When to Use

- After architecture discussions or design review meetings
- Following Slack/email threads about technical trade-offs
- When choosing between technology options
- After evaluating architectural patterns
- When making significant technical decisions that affect multiple teams
- During incident postmortems that reveal architectural issues

## What is an ADR?

An Architecture Decision Record documents:
- **What** decision was made
- **Why** it was made (context and constraints)
- **What alternatives** were considered
- **What consequences** (positive and negative) we accept

## ADR Format (Michael Nygard Template)

```markdown
# [Number]. [Short Title in Active Voice]

Date: YYYY-MM-DD

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

## Context

What is the issue we're seeing that is motivating this decision or change?

## Decision

We will [decision in active voice].

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Trade-off 1]
- [Trade-off 2]

### Neutral
- [Neither positive nor negative, but noteworthy]
```

## Example ADR

### Input: Discussion Thread

```
From: Slack #architecture channel

Sarah: We need to decide on database strategy for microservices. 
Currently all services share one PostgreSQL database.

John: I vote for one database per service. Better isolation.

Mike: That's expensive. We'd need 12 databases. What about shared 
database but different schemas?

Sarah: Schemas still have shared connection pools and single point 
of failure. What about data consistency across services?

John: Use saga pattern for distributed transactions. We accept 
eventual consistency.

Mike: Worried about operational overhead of 12 databases.

Sarah: We can start with 3 critical services having their own DB, 
others share for now. Migrate gradually.

Team: Agreed. Let's do it.
```

### Output: ADR

```markdown
# 15. Implement Database-per-Service Pattern for Microservices

Date: 2026-02-02

## Status

Accepted

## Context

We are migrating from a monolithic application to microservices architecture. 
Currently, all application logic shares a single PostgreSQL database, which 
creates several issues:

- **Tight coupling**: Services cannot evolve data models independently
- **Blast radius**: Database issues affect all services simultaneously
- **Scalability**: Cannot scale data storage per service needs
- **Team autonomy**: Teams must coordinate schema changes
- **Technology lock-in**: All services must use PostgreSQL

As we decompose the monolith into 12 microservices (auth, user, order, 
inventory, payment, notification, analytics, reporting, admin, partner, 
shipping, support), we need to decide on database strategy.

## Decision

We will implement the **database-per-service** pattern, where each microservice 
owns its data and no other service accesses it directly.

**Implementation approach**:
1. Phase 1: Extract databases for 3 critical services (auth, order, payment)
2. Phase 2: Migrate 6 core services (user, inventory, notification, shipping, admin, support)
3. Phase 3: Extract remaining services (analytics, reporting, partner)
4. Services communicate through APIs and events, not database queries
5. Use saga pattern for distributed transactions requiring multi-service coordination
6. Implement eventual consistency where immediate consistency not required

**Technology choices**:
- Continue using PostgreSQL for most services (team expertise)
- Allow service teams to choose alternative databases if justified (e.g., MongoDB for analytics)
- Implement shared database infrastructure via Terraform modules

## Alternatives Considered

### Alternative 1: Shared Database with Schemas
**Approach**: All services share one PostgreSQL instance, each service owns a schema

**Pros**:
- Lower infrastructure cost (1 database vs 12)
- Easier to implement initially
- Simpler operational overhead
- ACID transactions work natively

**Cons**:
- Shared connection pool limits (contention during high load)
- Single point of failure (database down = all services down)
- Cannot scale per-service (must scale entire database)
- Schema migrations require coordination
- Technology lock-in (all services must use PostgreSQL)

**Why not chosen**: Does not provide sufficient service isolation for our scale

### Alternative 2: Shared Database with Logical Separation
**Approach**: Single database, services access only their tables by convention

**Pros**:
- Lowest cost option
- No migration needed
- Simple queries across service boundaries

**Cons**:
- No enforcement of boundaries (developers can accidentally query other services' tables)
- Same scalability and failure issues as shared database
- Defeats purpose of microservices (no true service autonomy)

**Why not chosen**: Does not enforce service boundaries, negates benefits of microservices

### Alternative 3: Immediate Full Migration (All 12 Services)
**Approach**: Extract all 12 service databases simultaneously

**Pros**:
- Achieves end state immediately
- No intermediate complexity

**Cons**:
- High risk (big bang migration)
- 6+ month timeline with feature freeze
- Difficult to rollback if issues arise
- Team bandwidth insufficient

**Why not chosen**: Too risky and resource-intensive

## Consequences

### Positive

- **Service autonomy**: Teams can evolve data models independently
- **Failure isolation**: Database issues isolated to single service
- **Scalability**: Can scale databases independently based on service needs
- **Technology flexibility**: Services can choose optimal database technology
- **Performance**: Eliminate cross-service joins, force efficient API design
- **Security**: Better data isolation and access control per service

### Negative

- **Increased cost**: 12 databases vs 1 ($200/month → $2,400/month estimated)
- **Operational complexity**: More databases to monitor, backup, upgrade
- **Eventual consistency**: Cannot rely on ACID transactions across services
- **Data duplication**: Some data replicated across service boundaries
- **Complex queries**: Reporting requires aggregation from multiple services
- **Migration effort**: 6-month timeline with partial team allocation

### Neutral

- **New patterns required**: Must implement saga pattern for distributed transactions
- **Tooling needed**: Service mesh for inter-service communication, event bus for async updates
- **Team training**: Developers need education on distributed data patterns
- **Monitoring updates**: Must track distributed transactions across services

## Implementation Notes

### Phase 1 (Month 1-2): Critical Services
- Auth Service: User authentication and authorization data
- Order Service: Order and order history data
- Payment Service: Payment transactions and methods

**Rationale**: These services have highest autonomy needs and clearest bounded contexts

### Phase 2 (Month 3-4): Core Services
- User Service, Inventory Service, Notification Service, Shipping Service, Admin Service, Support Service

### Phase 3 (Month 5-6): Remaining Services
- Analytics Service (may use MongoDB), Reporting Service, Partner Service

### Data Consistency Strategy

**Immediate consistency** (synchronous calls):
- Payment processing (order → payment)
- Authentication (any service → auth)

**Eventual consistency** (event-driven):
- Order fulfillment (order → inventory → shipping)
- Notifications (any service → notification)
- Analytics updates (any service → analytics)

### Migration Safety

- **Dual writes**: Write to both old and new database during transition
- **Incremental cutover**: Route read traffic gradually (10% → 50% → 100%)
- **Rollback plan**: Can revert to shared database within 24 hours
- **Data validation**: Compare old vs new database results during parallel run

## References

- [Martin Fowler: Database per Service](https://martinfowler.com/bliki/DatabasePerService.html)
- [Microservices.io: Database patterns](https://microservices.io/patterns/data/database-per-service.html)
- [Saga Pattern Documentation](https://microservices.io/patterns/data/saga.html)
- Our migration plan: `docs/migrations/database-per-service.md`

## Related Decisions

- [ADR-014: Migrate to Microservices](0014-microservices-migration.md) - Parent decision
- [ADR-016: Use Kafka for Event Bus](0016-kafka-event-bus.md) - Enables eventual consistency
- [ADR-017: Implement Saga Pattern](0017-saga-pattern.md) - Handles distributed transactions

## Review

- **Proposed**: 2026-01-25 by @sarah-architect
- **Discussed**: 2026-01-28 architecture review meeting
- **Accepted**: 2026-02-02 by engineering leadership
- **Reviewers**: @john-principal, @mike-tech-lead, @sarah-architect
```

## ADR Numbering and Organization

### File Structure

```
docs/
└── decisions/
    ├── README.md                          # Index of all ADRs
    ├── 0001-use-markdown-for-adrs.md
    ├── 0002-use-postgresql-as-database.md
    ├── 0003-implement-microservices.md
    ├── ...
    └── 0015-database-per-service.md
```

### Numbering Convention

- **Sequential**: 0001, 0002, 0003 (with leading zeros)
- **Never reuse**: Even if ADR superseded, keep number
- **No gaps**: Next ADR uses next number

### Status Workflow

```
Proposed → Accepted → [Deprecated | Superseded]
           ↓
         Rejected
```

- **Proposed**: Under discussion, not yet decided
- **Accepted**: Team agreed, being implemented
- **Deprecated**: No longer recommended, but not replaced
- **Superseded**: Replaced by newer ADR (link to it)
- **Rejected**: Considered but explicitly not chosen

## ADR Index (README.md)

```markdown
# Architecture Decision Records

## Active Decisions

| ADR | Title | Date | Status |
|-----|-------|------|--------|
| [0015](0015-database-per-service.md) | Database-per-Service Pattern | 2026-02-02 | Accepted |
| [0014](0014-microservices-migration.md) | Migrate to Microservices | 2026-01-15 | Accepted |
| [0013](0013-use-typescript.md) | Use TypeScript for Frontend | 2025-12-10 | Accepted |

## Deprecated Decisions

| ADR | Title | Date | Status | Superseded By |
|-----|-------|------|--------|---------------|
| [0007](0007-use-jwt-auth.md) | Use JWT for Authentication | 2024-06-15 | Deprecated | [0012](0012-oauth2-auth.md) |

## Rejected Decisions

| ADR | Title | Date | Status |
|-----|-------|------|--------|
| [0011](0011-use-graphql.md) | Adopt GraphQL for APIs | 2025-09-20 | Rejected |
```

## When to Write an ADR

### ✅ Write an ADR for:

- **Architectural patterns**: Microservices, event-driven, CQRS
- **Technology selections**: Database choice, framework, cloud provider
- **Cross-cutting concerns**: Authentication, logging, monitoring
- **Infrastructure decisions**: Deployment strategy, scaling approach
- **Data strategies**: Storage patterns, consistency models
- **Significant trade-offs**: Performance vs cost, simplicity vs flexibility

### ❌ Don't write an ADR for:

- **Implementation details**: How a function works (use code comments)
- **Temporary workarounds**: Short-term fixes (use TODO comments)
- **Obvious choices**: Industry-standard practices with no alternatives considered
- **Team processes**: Stand-up schedule (use team handbook)
- **Small local changes**: Refactoring within a service

## Tips for Better ADRs

### 1. Be Specific About Context

❌ **Vague**: "We need better performance"
✅ **Specific**: "API p95 latency increased from 200ms to 800ms as user base grew from 10K to 50K"

### 2. Quantify When Possible

```markdown
## Context
- Current: Single PostgreSQL instance, $200/month
- Load: 50K users, 1M requests/day
- Growth: 50% quarterly
- SLA: 99.9% uptime (43 minutes downtime/month acceptable)
```

### 3. Show Real Trade-Offs

❌ **One-sided**: Only list benefits
✅ **Balanced**: Show both upsides and downsides

### 4. Link to Evidence

```markdown
## Context
Per our load testing [results](https://wiki.company.com/load-test-2026-01), 
current database will hit capacity at 75K users (Q3 2026).
```

### 5. Make Decision Falsifiable

❌ **Unfalsifiable**: "This will be better"
✅ **Falsifiable**: "This will reduce p95 latency below 200ms"

### 6. Update Status

When circumstances change:

```markdown
## Status

~~Accepted~~
**Deprecated** (2027-01-15)

This decision has been superseded by [ADR-025: Move to Serverless](0025-serverless.md) 
due to changing cost structure and team expertise.
```

## Resources

### ADR Templates
- [Michael Nygard's template](https://github.com/joelparkerhenderson/architecture-decision-record/blob/main/templates/decision-record-template-by-michael-nygard/index.md) - Original, widely used
- [Markdown Any Decision Records](https://adr.github.io/madr/) - Alternative template
- [Y-Statements](https://medium.com/olzzio/y-statements-10eb07b5a177) - Brief format

### Tools
- [adr-tools](https://github.com/npryce/adr-tools) - CLI for managing ADRs
- [log4brains](https://github.com/thomvaill/log4brains) - ADR management with web UI

### Examples
- [Spotify ADRs](https://github.com/joelparkerhenderson/architecture-decision-record#examples)
- [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/welcome.html)

### Further Reading
- [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) - Original blog post
- [ADRs at Scale](https://engineering.atspotify.com/2020/04/when-should-i-write-an-architecture-decision-record/)

## Quick Checklist

- [ ] Title describes decision in active voice
- [ ] Date and status included
- [ ] Context explains why decision needed
- [ ] Decision stated clearly in active voice
- [ ] At least 2 alternatives considered
- [ ] Each alternative has pros/cons
- [ ] Consequences listed (positive, negative, neutral)
- [ ] Quantified impact where possible
- [ ] Related decisions linked
- [ ] References provided
- [ ] Reviewers listed
- [ ] File numbered sequentially
- [ ] Added to ADR index
