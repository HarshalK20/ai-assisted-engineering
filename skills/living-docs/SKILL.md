---
name: living-docs
description: Keeps architecture documentation in sync with evolving system decisions and changes. Use when updating architecture after refactors, maintaining design docs, or when the user mentions documentation updates, architecture changes, or keeping docs current.
---

# Architecture to Living Documentation

## Purpose

Keep architecture documentation in sync with evolving decisions, ensuring docs reflect current reality rather than historical plans.

## When to Use

- After major refactors or system changes
- Following architectural decision implementations
- During regular documentation sprints
- When onboarding reveals doc gaps
- Post-incident when system behavior differed from docs

## Living Documentation Principles

### 1. Documentation as Code

Store docs in version control alongside code:

```
project/
├── src/
├── docs/
│   ├── architecture/
│   │   ├── README.md          # Current state overview
│   │   ├── decisions/         # ADRs
│   │   ├── diagrams/          # System diagrams
│   │   └── components/        # Component details
│   ├── api/
│   └── deployment/
└── tests/
```

### 2. Single Source of Truth

Each concept documented in ONE place:

❌ **Multiple locations**: README.md, Wiki, Confluence, Google Docs
✅ **One canonical location**: `docs/architecture/` in repository

### 3. Proximity to Code

Document near what it describes:

```
services/
├── auth-service/
│   ├── src/
│   ├── docs/
│   │   ├── API.md          # API documentation
│   │   ├── DATABASE.md     # Schema and migrations
│   │   └── DEPLOYMENT.md   # How to deploy
│   └── README.md           # Quick start
```

### 4. Automatic Updates Where Possible

- API docs generated from OpenAPI specs
- Database schema docs from migrations
- Component diagrams from code annotations
- Metrics dashboards from instrumentation

## Architecture Documentation Structure

### Master Overview (architecture/README.md)

```markdown
# System Architecture

**Last Updated**: February 2, 2026
**Status**: Current
**Reviewers**: @architecture-team

## System Overview
[High-level description of the system]

## Architecture Diagram
![Architecture Diagram](diagrams/system-overview.png)

## Key Components
- **API Gateway** - [Link to component docs](components/api-gateway.md)
- **Auth Service** - [Link to component docs](components/auth-service.md)
- **Order Service** - [Link to component docs](components/order-service.md)

## Technology Stack
| Layer | Technology | Version | Notes |
|-------|-----------|---------|-------|
| Frontend | React | 18.2 | TypeScript |
| API Gateway | Kong | 3.0 | Rate limiting, auth |
| Services | Node.js, Python | 18.x, 3.11 | Microservices |
| Database | PostgreSQL | 15 | One per service |
| Cache | Redis | 7.0 | Shared cache layer |
| Message Bus | Kafka | 3.0 | Event streaming |

## Architectural Decisions
See [decisions/](decisions/) for ADRs

Recent decisions:
- [ADR-015: Migrate to microservices](decisions/0015-microservices-migration.md)
- [ADR-016: Use Kafka for events](decisions/0016-kafka-event-bus.md)

## Getting Started
- [Development Setup](../development/SETUP.md)
- [Deployment Guide](../deployment/README.md)
- [API Documentation](../api/README.md)
```

### Component Documentation Template

```markdown
# [Component Name]

**Owner**: @team-name
**Status**: Production
**Last Updated**: February 2, 2026

## Purpose
[What this component does and why it exists]

## Responsibilities
- [Key responsibility 1]
- [Key responsibility 2]
- [Key responsibility 3]

## Architecture

### Component Diagram
[Mermaid or image showing internal structure]

### Dependencies
| Service | Purpose | Failure Mode |
|---------|---------|--------------|
| Auth Service | User authentication | Fail closed (deny) |
| Database | Order storage | Circuit breaker |
| Redis | Caching | Fail open (no cache) |

### Technology
- **Language**: Python 3.11
- **Framework**: FastAPI
- **Database**: PostgreSQL 15
- **Testing**: pytest

## API

### Endpoints
```
POST /orders           - Create new order
GET  /orders/:id       - Get order details
PUT  /orders/:id       - Update order
DELETE /orders/:id     - Cancel order
```

Full API docs: [API.md](API.md)

### Events Published
```
OrderCreated       - When order successfully created
OrderCancelled     - When order cancelled
OrderFulfilled     - When order shipped
```

### Events Consumed
```
PaymentCompleted   - Triggers order fulfillment
InventoryUpdated   - Updates stock availability
```

## Data

### Database Schema
See [DATABASE.md](DATABASE.md) for full schema

Key tables:
- `orders` - Order records
- `order_items` - Line items
- `order_status_history` - Audit trail

### Data Flow
[Diagram showing data in/out]

## Deployment

### Infrastructure
- **Hosting**: AWS ECS
- **Instances**: 3 (autoscale to 10)
- **Region**: us-east-1
- **Health Check**: `/health`

### Configuration
Environment variables:
```
DATABASE_URL         - PostgreSQL connection
REDIS_URL           - Redis connection
KAFKA_BROKERS       - Kafka cluster
AUTH_SERVICE_URL    - Auth service endpoint
```

### Monitoring
- **Metrics**: CloudWatch + Grafana
- **Logs**: CloudWatch Logs
- **Traces**: AWS X-Ray
- **Dashboard**: https://grafana.company.com/orders

### Alerts
| Alert | Threshold | Action |
|-------|-----------|--------|
| Error rate | > 5% | Page on-call |
| Latency p95 | > 500ms | Warning |
| Database connections | > 80% | Auto-scale |

## Operations

### Runbooks
- [Deployment](runbooks/deployment.md)
- [Scaling](runbooks/scaling.md)
- [Common Issues](runbooks/troubleshooting.md)

### On-Call
- **Team**: @orders-team
- **Schedule**: PagerDuty
- **Escalation**: @platform-team

## Development

### Local Setup
```bash
# Clone and install
git clone https://github.com/company/order-service
cd order-service
pip install -r requirements.txt

# Run locally
docker-compose up -d  # Dependencies
python -m uvicorn main:app --reload
```

### Testing
```bash
# Unit tests
pytest tests/unit/

# Integration tests
pytest tests/integration/

# E2E tests
pytest tests/e2e/
```

### Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md)

## Recent Changes

### v2.5.0 (Feb 2, 2026)
- Added order cancellation endpoint
- Implemented event-driven fulfillment
- Improved database query performance

### v2.4.0 (Jan 15, 2026)
- Migrated from monolith to microservice
- Added Kafka event publishing
- Implemented circuit breakers

See [CHANGELOG.md](CHANGELOG.md) for full history

## Future Plans
- [ ] Add order scheduling feature (Q2 2026)
- [ ] Implement subscription orders (Q3 2026)
- [ ] Multi-currency support (Q4 2026)

## References
- [Product Requirements](https://wiki.company.com/orders)
- [API Design Guidelines](../standards/api-guidelines.md)
- [Architecture Principles](../architecture/principles.md)
```

## Update Workflow

### 1. Trigger Events for Updates

Update docs when:
- ✓ Architecture Decision Record created
- ✓ Major refactoring completed
- ✓ New service deployed
- ✓ API contract changed
- ✓ Infrastructure modified
- ✓ Dependencies added/updated
- ✓ Monitoring/alerting changed

### 2. Update Process

```markdown
1. **Identify impact**
   - What components changed?
   - What docs need updates?
   - What diagrams need refresh?

2. **Update documentation**
   - Modify affected markdown files
   - Regenerate diagrams if needed
   - Update version numbers
   - Add to changelog

3. **Review changes**
   - Technical review by team
   - Architecture review for big changes
   - Ensure consistency across docs

4. **Commit with context**
   ```bash
   git add docs/
   git commit -m "docs: update order service architecture
   
   - Added Kafka event publishing
   - Updated component diagram
   - Added new monitoring alerts
   
   Relates to: ADR-016, PR-1234"
   ```

5. **Announce changes**
   - Post in engineering Slack
   - Email if major architectural change
   - Update wiki index if needed
```

### 3. Maintenance Schedule

```markdown
**Continuous** (with code changes):
- API documentation (OpenAPI)
- Component READMEs
- Deployment configs

**Weekly** (sprint ceremonies):
- Recent changes section
- Known issues list
- Runbook updates

**Monthly** (architecture review):
- System diagrams
- Technology stack versions
- Component responsibilities
- Dependency updates

**Quarterly** (planning):
- Strategic direction
- Deprecation notices
- Future plans
- Full doc review
```

## Documentation Patterns

### Pattern 1: Version History in Front Matter

```markdown
---
title: Order Service Architecture
version: 2.5.0
last_updated: 2026-02-02
status: current
reviewers:
  - @john-architect
  - @sarah-tech-lead
changes:
  - date: 2026-02-02
    version: 2.5.0
    changes: Added Kafka event publishing
  - date: 2026-01-15
    version: 2.4.0
    changes: Migrated from monolith
---

# Order Service Architecture
...
```

### Pattern 2: Status Badges

```markdown
# Authentication Service

![Status](https://img.shields.io/badge/status-production-green)
![Last Updated](https://img.shields.io/badge/updated-2026--02--02-blue)
![Owner](https://img.shields.io/badge/owner-@auth--team-purple)
```

### Pattern 3: Deprecation Warnings

```markdown
## Authentication Methods

### OAuth2 (Current) ✅
Use OAuth2 for all new integrations...

### JWT (Deprecated) ⚠️
> **Deprecated**: JWT auth will be removed in v3.0 (June 2026)
> **Migration Guide**: See [oauth2-migration.md](oauth2-migration.md)

Legacy JWT authentication...
```

### Pattern 4: Decision Log

```markdown
## Recent Decisions

| Date | Decision | Rationale | ADR |
|------|----------|-----------|-----|
| 2026-02-01 | Use Kafka for events | Scalability needs | [ADR-016](decisions/0016-kafka.md) |
| 2026-01-15 | Migrate to microservices | Team autonomy | [ADR-015](decisions/0015-microservices.md) |
```

### Pattern 5: Auto-Generated Sections

Use comments to mark auto-generated content:

```markdown
## API Endpoints

<!-- AUTO-GENERATED: Do not edit manually -->
<!-- Generated from: src/routes/openapi.yaml -->
<!-- Last generated: 2026-02-02 10:30:00 -->

### POST /orders
...

<!-- END AUTO-GENERATED -->
```

## Tools for Living Documentation

### Documentation Generators
- **OpenAPI/Swagger** - API docs from specifications
- **JSDoc/TypeDoc** - Code documentation from comments
- **Sphinx** - Python documentation
- **Javadoc** - Java documentation

### Diagram Generators
- **Structurizr** - C4 diagrams from code
- **PlantUML** - Diagrams from text
- **Mermaid** - Diagrams in Markdown

### Link Checkers
- **markdown-link-check** - Verify internal links
- **linkinator** - Find broken links

### CI/CD Integration

```yaml
# .github/workflows/docs.yml
name: Documentation

on:
  pull_request:
    paths:
      - 'docs/**'
      - 'src/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Check links
        run: markdown-link-check docs/**/*.md
      
      - name: Generate API docs
        run: npm run generate-api-docs
      
      - name: Validate diagrams
        run: mmdc -i docs/diagrams/*.mmd
      
      - name: Check for outdated content
        run: |
          # Flag docs not updated in 6 months
          find docs -name "*.md" -mtime +180
```

## Common Pitfalls

### 1. Over-Documentation

❌ **Too much**: Document every function, every variable
✅ **Right amount**: Document architecture decisions, system interactions, non-obvious logic

### 2. Stale Documentation

❌ **Problem**: Docs updated separately from code
✅ **Solution**: Update docs in same PR as code changes

### 3. Scattered Documentation

❌ **Problem**: Wiki, Google Docs, Confluence, Slack, Email
✅ **Solution**: Single source of truth in repository

### 4. No Ownership

❌ **Problem**: "Someone should update the docs"
✅ **Solution**: Component owner responsible for docs

### 5. Too Abstract

❌ **Problem**: "This service handles business logic"
✅ **Better**: "Order Service validates orders, checks inventory, processes payments"

## Resources

### Documentation Frameworks
- [Arc42](https://arc42.org/) - Architecture documentation template
- [Docs as Code](https://www.writethedocs.org/guide/docs-as-code/) - Philosophy and practices
- [Divio Documentation System](https://documentation.divio.com/) - 4-part doc structure

### Tools
- [MkDocs](https://www.mkdocs.org/) - Project documentation
- [Docusaurus](https://docusaurus.io/) - Documentation websites
- [GitBook](https://www.gitbook.com/) - Team documentation

### Best Practices
- [Write the Docs](https://www.writethedocs.org/) - Community and resources
- [Google Technical Writing Course](https://developers.google.com/tech-writing)

## Quick Checklist

- [ ] Documentation in version control
- [ ] Single source of truth established
- [ ] Component ownership assigned
- [ ] Update process documented
- [ ] Regular review schedule set
- [ ] Auto-generation where applicable
- [ ] Links verified (not broken)
- [ ] Diagrams current
- [ ] ADRs linked from docs
- [ ] Recent changes tracked
- [ ] Future plans documented
- [ ] Deprecation warnings clear
