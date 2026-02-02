# Architecture Standards

This document defines architecture standards, patterns, and decision-making frameworks for the team.

## Architecture Decision Records (ADRs)

### When to Create an ADR

Create an ADR for:
- Architectural patterns (microservices, event-driven, CQRS, etc.)
- Technology selections (database choice, framework, cloud provider)
- Cross-cutting concerns (authentication, logging, monitoring)
- Infrastructure decisions (deployment strategy, scaling approach)
- Data strategies (storage patterns, consistency models)
- Significant trade-offs (performance vs cost, simplicity vs flexibility)

### ADR Format

Use the Michael Nygard template:

```markdown
# [Number]. [Title]

Date: YYYY-MM-DD

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

## Context
[What is the issue motivating this decision?]

## Decision
[What we will do - in active voice]

## Consequences
### Positive
- [Benefit 1]

### Negative
- [Trade-off 1]

### Neutral
- [Noteworthy aspect]
```

### ADR Location

Store ADRs in: `docs/decisions/`

Naming: `NNNN-short-title.md` (e.g., `0015-database-per-service.md`)

## Architecture Documentation

### Documentation Structure

```
docs/
├── architecture/
│   ├── README.md          # System overview
│   ├── decisions/         # ADRs
│   ├── diagrams/          # System diagrams
│   └── components/        # Component details
└── api/                   # API documentation
```

### C4 Model for Diagrams

Use C4 model for architecture diagrams:
1. **Context**: System in relation to users and external systems
2. **Container**: Major technology choices and communication
3. **Component**: Components within a container
4. **Code**: Class/module level (rarely needed)

### Diagram Tools

Prefer text-based diagrams for version control:
- **Mermaid** - For simple to moderate diagrams
- **PlantUML** - For complex diagrams
- **Draw.io** - For presentations (export as PNG + source XML)

## Architecture Principles

### 1. Evolutionary Architecture

- Design for change, not perfection
- Make decisions reversible when possible
- Defer decisions until the last responsible moment
- Prove with small experiments before big commitments

### 2. Separation of Concerns

- Each component has a single, well-defined purpose
- Loose coupling, high cohesion
- Dependencies point toward stability
- No circular dependencies

### 3. API-First Design

- Define APIs before implementation
- Use OpenAPI/Swagger for REST APIs
- Version APIs explicitly
- Backward compatibility by default

### 4. Observability by Design

- Every service emits metrics, logs, and traces
- Correlation IDs throughout request chain
- Alerts defined alongside features
- Dashboards created before production deployment

### 5. Security by Default

- Authentication required unless explicitly public
- Authorization checked at every boundary
- Input validation on all user inputs
- No secrets in code (use secret management)
- Least privilege principle

### 6. Data Ownership

- Each service owns its data
- No direct database access between services
- Communicate through APIs or events
- Accept eventual consistency where appropriate

## Architecture Patterns

### Microservices

When to use:
- Team size > 20 engineers
- Need independent deployment
- Different scaling requirements per component
- Clear bounded contexts

Trade-offs:
- ✅ Independent deployment and scaling
- ✅ Technology flexibility
- ❌ Increased operational complexity
- ❌ Distributed system challenges

### Monolith

When to use:
- Small team (< 10 engineers)
- Early stage product
- Unclear domain boundaries
- Simple deployment preferred

Trade-offs:
- ✅ Simple deployment and development
- ✅ Easy to understand and test
- ❌ Scaling requires scaling entire app
- ❌ Technology lock-in

### Event-Driven Architecture

When to use:
- Loose coupling needed
- Asynchronous processing acceptable
- Scalability requirements
- Multiple consumers of same event

Trade-offs:
- ✅ Decoupled components
- ✅ Horizontal scalability
- ❌ Eventual consistency
- ❌ Debugging complexity

## Technology Selection Criteria

### Evaluation Framework

For each technology choice, evaluate:

1. **Maturity**: Production-ready? Stable API?
2. **Community**: Active development? Good documentation?
3. **Performance**: Meets requirements? Benchmarked?
4. **Scalability**: Handles expected load? Growth path?
5. **Cost**: Initial + operational costs? ROI?
6. **Team Fit**: Team expertise? Learning curve?
7. **Support**: Commercial support available? SLAs?
8. **Security**: Security track record? Patching cadence?
9. **Compliance**: Meets regulatory requirements?
10. **Lock-in**: Migration path? Vendor dependency?

### Technology Radar

Categorize technologies:
- **Adopt**: Proven, recommended for use
- **Trial**: Worth trying in non-critical projects
- **Assess**: Interesting, keep watching
- **Hold**: Avoid for new projects

Maintain list at: `docs/tech-radar.md`

## Architecture Review Process

### When to Review

Require architecture review for:
- New services or major components
- Significant architectural changes
- Technology changes (new database, framework, etc.)
- Cross-team initiatives
- Security-critical changes

### Review Checklist

- [ ] Problem clearly stated
- [ ] Alternatives considered
- [ ] Trade-offs documented
- [ ] Scalability analyzed
- [ ] Security reviewed
- [ ] Operational plan (deploy, monitor, debug)
- [ ] Cost calculated
- [ ] Team consensus

### Review Forum

- **Weekly**: Architecture Review Meeting (1 hour)
- **Async**: RFC in `docs/rfcs/` (for comment period)
- **Emergency**: Ad-hoc for urgent decisions

## Performance Standards

### Response Time Targets

- **Web Pages**: < 2 seconds (P95)
- **API Endpoints**: < 500ms (P95)
- **Background Jobs**: Complete within SLA
- **Database Queries**: < 100ms (P95)

### Scalability Requirements

Design for:
- **Current + 10x**: Architecture should handle 10x current load
- **Growth**: Annual growth rate + buffer
- **Spikes**: 3x normal load without degradation

### Performance Testing

- Load test before production
- Set performance budgets
- Monitor degradation over time
- Optimize hot paths

## Reliability Standards

### Availability Targets

- **Critical Services**: 99.9% (43 min downtime/month)
- **Important Services**: 99.5% (3.6 hours downtime/month)
- **Internal Tools**: 99% (7.2 hours downtime/month)

### Failure Handling

- **Circuit breakers**: For external dependencies
- **Timeouts**: On all network calls
- **Retries**: With exponential backoff
- **Graceful degradation**: Fallback behavior
- **Bulkheads**: Isolate failures

### Deployment Safety

- **Blue-green deployment**: Zero-downtime
- **Canary releases**: Gradual rollout
- **Feature flags**: Kill switch for new features
- **Rollback plan**: Tested before deployment
- **Health checks**: Automated verification

## Monitoring & Observability

### Golden Signals

Monitor these for every service:
1. **Latency**: How long requests take
2. **Traffic**: Number of requests
3. **Errors**: Rate of failed requests
4. **Saturation**: Resource utilization

### Logging Standards

- Use structured logging (JSON)
- Include correlation IDs
- Log at appropriate levels (ERROR, WARN, INFO, DEBUG)
- Never log secrets or PII
- Centralized log aggregation

### Metrics Standards

- Use standard naming (Prometheus style)
- Tag with environment, service, instance
- Track business metrics, not just technical
- Set alert thresholds
- Create dashboards before production

### Distributed Tracing

- Pass trace context through all services
- Sample appropriately (not 100%)
- Use standard format (OpenTelemetry)
- Include in incident investigations

## Security Standards

### Authentication

- Use industry standards (OAuth2, OIDC)
- MFA for admin access
- Token expiration enforced
- Secure session management

### Authorization

- Role-based access control (RBAC)
- Principle of least privilege
- Check at every boundary
- Audit authorization decisions

### Data Protection

- Encrypt sensitive data at rest
- Encrypt in transit (TLS 1.3+)
- Hash passwords (bcrypt, Argon2)
- Mask PII in logs
- Data retention policies

### Secure Development

- Security code review for critical changes
- Dependency scanning (daily)
- Static analysis (SAST)
- Dynamic analysis (DAST)
- Penetration testing (annually)

## Compliance

- GDPR (data privacy)
- SOC 2 (security controls)
- HIPAA (if handling health data)
- PCI DSS (if handling payments)

Maintain compliance documentation at: `docs/compliance/`

## References

- [C4 Model](https://c4model.com/)
- [Architecture Decision Records](https://adr.github.io/)
- [Microservices Patterns](https://microservices.io/patterns/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Google SRE Book](https://sre.google/books/)
