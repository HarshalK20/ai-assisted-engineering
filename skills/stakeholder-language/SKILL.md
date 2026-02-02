---
name: stakeholder-language
description: Adapts technical solutions for different audiences (engineers, product, leadership, operations). Use when preparing cross-functional presentations, multi-level approval documents, or when the user mentions adapting content for different teams or stakeholders.
---

# Technical Content to Stakeholder-Specific Language

## Purpose

Reframe the same technical solution for different audiences, optimizing message for each stakeholder's priorities and context.

## When to Use

- Cross-functional alignment meetings
- Multi-level approval processes (team → manager → VP → C-level)
- Documentation for different teams
- Proposal presentations requiring multiple stakeholder buy-in
- Architecture reviews with diverse attendees
- Budget justifications involving technical and business stakeholders

## The Core Insight

**Same solution, different framing:**
- Engineers care about: How it's built, technical quality
- Product cares about: Feature velocity, user value
- Leadership cares about: Business outcomes, ROI
- Operations cares about: Stability, deployment process

## Translation Framework

For each audience, answer their core questions:

| Audience | Core Question | Focus Areas |
|----------|---------------|-------------|
| **Engineering** | How does it work? | Architecture, tech stack, implementation |
| **Product** | What can we build? | Features enabled, velocity, user impact |
| **Leadership** | What's the business value? | ROI, strategic alignment, competitive advantage |
| **Operations** | What do I need to do? | Deployment, monitoring, incident response |
| **Security** | Is it safe? | Vulnerabilities, compliance, data protection |
| **Finance** | What does it cost? | Capex, opex, ROI, payback period |

## Example: Microservices Migration

### Original Technical Description

```
We propose migrating from our monolithic architecture to microservices 
using Kubernetes for orchestration. Each service will have its own 
database (database-per-service pattern). We'll use gRPC for inter-service 
communication and implement service mesh with Istio for observability. 
Migration will happen incrementally using strangler fig pattern.
```

### For Engineering Team

**Focus**: Implementation details, technical quality, developer experience

```markdown
## Microservices Migration: Technical Approach

### Architecture
• Decompose monolith into 12 bounded services (user, auth, order, etc.)
• Each service: Independent database, API, deployment
• Communication: gRPC for sync, Kafka for async events
• Orchestration: Kubernetes (EKS) with Istio service mesh

### Implementation Strategy
• **Strangler fig pattern**: Incrementally extract services
• **Shared library**: Common utilities, auth helpers
• **API Gateway**: Kong for routing, rate limiting
• **Observability**: Distributed tracing (Jaeger), centralized logging (ELK)

### Developer Experience Impact
✓ Independent deployments (no waiting for full release cycle)
✓ Technology flexibility per service (right tool for the job)
✓ Faster CI/CD (test/deploy only changed service)
✗ Increased complexity (distributed debugging, testing)
✗ Learning curve (Kubernetes, gRPC, service patterns)

### Technical Debt Payoff
• Eliminates 3-year-old tight coupling issues
• Enables proper separation of concerns
• Facilitates A/B testing and feature flags
• Foundation for multi-region deployment

### Migration Plan
1. **Phase 1** (Month 1-2): Extract auth service (lowest risk)
2. **Phase 2** (Month 3-4): User and order services
3. **Phase 3** (Month 5-6): Remaining services, decommission monolith

### Team Enablement
• 2-day Kubernetes training
• Service template repository with best practices
• Internal documentation site
• Weekly architecture office hours
```

### For Product Team

**Focus**: Feature velocity, user value, product capabilities

```markdown
## Microservices Migration: Product Impact

### Why This Matters for Product
Current monolith slows feature development. Every deploy requires full 
regression testing and coordination across all teams. This limits our 
ability to experiment and deliver value quickly.

### Impact on Feature Velocity
**Today**: 2-week release cycles, high-risk deploys
**After**: Deploy features independently, multiple times per day

✓ **Faster experimentation**: A/B test new features without full deploy
✓ **Reduced time-to-market**: Ship order improvements without touching user management
✓ **Lower risk**: Bug in one feature doesn't take down entire site
✓ **Better scaling**: Handle Black Friday traffic spikes in checkout without over-provisioning everything

### New Capabilities Enabled
1. **Personalization engine**: Run ML models for recommendations without impacting core app
2. **Third-party integrations**: Add partner APIs without monolith dependencies
3. **Mobile-first APIs**: Optimize endpoints for mobile app needs
4. **Feature flags**: Gradual rollouts, instant rollbacks

### Product Roadmap Impact
**Unblocked initiatives**:
• Real-time inventory (requires event-driven architecture)
• International expansion (service-level localization)
• Mobile app v2 (needs dedicated API layer)
• Partner marketplace (isolated integration layer)

### During Migration (6 months)
• **Months 1-2**: Limited feature work (30% capacity)
• **Months 3-6**: Normal feature velocity resumes
• **Post-migration**: 2x faster feature delivery

### User-Facing Improvements
• Faster page loads (optimize each service independently)
• More reliable (failures isolated to specific features)
• Personalized experiences (ML services scale independently)

### Risks to Product
• 6-month investment before velocity gains
• Temporary feature freeze during critical migrations
• Complexity may slow new team member onboarding

**Mitigation**: Maintain small "quick wins" backlog for customer-facing improvements during migration
```

### For Leadership (VP Engineering, CTO)

**Focus**: Business outcomes, strategic value, ROI, competitive advantage

```markdown
## Microservices Migration: Strategic Business Case

### Executive Summary
Migrate to microservices architecture to enable 2x faster feature delivery, 
support international expansion, and reduce infrastructure costs by 35%.

**Investment**: $450K over 6 months (3 engineers full-time)
**Payback**: 9 months
**Strategic value**: Enables $5M+ revenue initiatives currently blocked

### Business Problem
Current monolithic architecture limits growth:
• **Feature velocity**: 2-week release cycles miss market opportunities
• **Scalability**: Can't efficiently scale for international growth
• **Cost**: Over-provisioning for peak loads costs $200K/year
• **Risk**: Single points of failure threaten 99.9% SLA commitment
• **Talent**: Modern engineers expect cloud-native architecture

### Strategic Benefits

**1. Revenue Enablement** ($5M+ opportunity)
• **International expansion**: Launch in EU, Asia (service-level localization)
• **Marketplace platform**: Partner integrations (isolated ecosystem)
• **Enterprise tier**: White-label capability (multi-tenant services)

**2. Operational Efficiency** ($400K annual savings)
• Infrastructure: 35% cost reduction through right-sizing
• Developer productivity: 50% less time on deployment coordination
• Incident resolution: 70% faster (isolated blast radius)

**3. Competitive Advantage**
• **Time-to-market**: Deploy features 2x faster than monolith cycle
• **Innovation**: Experiment rapidly with lower risk
• **Reliability**: 99.95% uptime (vs 99.7% today)

**4. Risk Mitigation**
• Eliminates single point of failure
• Reduces vendor lock-in (cloud-agnostic services)
• Improves disaster recovery (service-level backup/restore)

### Financial Analysis

**Investment**:
• Engineering: $360K (3 engineers × 6 months)
• Infrastructure: $50K (Kubernetes, testing environments)
• Training: $40K (team enablement)
• **Total**: $450K

**Annual Benefits**:
• Infrastructure savings: $200K/year
• Developer productivity: $180K/year (less coordination overhead)
• Incident reduction: $100K/year (faster resolution, less downtime)
• **Total**: $480K/year

**ROI**: 107% annual return
**Payback**: 9 months

### Strategic Alignment
✓ Supports 2026 goal: International expansion
✓ Enables enterprise tier launch (Q3 roadmap)
✓ Addresses technical debt (audit recommendation)
✓ Attracts top engineering talent (modern stack)

### Risks & Mitigation

**Risk 1**: Migration takes longer than estimated
→ Mitigation: Incremental approach, can pause after any phase

**Risk 2**: Feature velocity drops during migration
→ Mitigation: Maintain small team on customer-facing quick wins

**Risk 3**: Increased operational complexity
→ Mitigation: $50K investment in monitoring/observability tools

**Risk 4**: Team expertise gaps
→ Mitigation: Training program + 1 senior consultant

### Timeline & Milestones
• **Month 2**: First service deployed (de-risk approach)
• **Month 4**: Core services migrated (50% complete)
• **Month 6**: Monolith decommissioned, cost savings begin
• **Month 12**: Full ROI realized

### Competitive Context
• Competitor A: Already on microservices, shipping 3x faster
• Industry trend: 70% of SaaS companies migrated in last 2 years
• Talent acquisition: Modern architecture is recruiting advantage

### Decision Needed
Approve $450K investment for Q1-Q2 implementation, enabling:
1. International expansion in Q3
2. 2x feature velocity improvement
3. $480K annual cost savings starting Q3
```

### For Operations Team

**Focus**: Deployment, monitoring, incident response, day-to-day management

```markdown
## Microservices Migration: Operations Guide

### What's Changing
Moving from single monolithic application to 12 independent services 
on Kubernetes. Each service deploys independently with its own database, 
monitoring, and alerting.

### Impact on Your Day-to-Day

**Deployments**:
• **Before**: One big deploy every 2 weeks, 2-hour maintenance window
• **After**: Multiple small deploys daily, zero downtime
• **Your role**: Monitor deploy dashboards, approve production releases

**Monitoring**:
• **Before**: Single app to monitor (CPU, memory, errors)
• **After**: 12 services + Kubernetes cluster + service mesh
• **New tools**: Grafana dashboards, Jaeger tracing, Prometheus alerts

**Incident Response**:
• **Before**: Entire app down = all hands on deck
• **After**: Usually single service down = isolated impact
• **Your role**: Identify affected service, route to owning team

### New Tools & Dashboards

**Primary Dashboard**: https://grafana.company.com/overview
• Service health (green/yellow/red status)
• Request rates and latencies
• Error rates and types
• Resource utilization

**Kubernetes Dashboard**: https://k8s.company.com
• Pod health and restart counts
• Node resource usage
• Deployment status

**Distributed Tracing**: https://jaeger.company.com
• Track requests across services
• Identify bottlenecks
• Debug complex issues

### Deployment Process

**Old Process** (2 hours, high stress):
1. Announce maintenance window
2. Deploy monolith
3. Run smoke tests
4. Monitor for issues
5. Rollback entire app if problems

**New Process** (10 minutes, low risk):
1. Developer deploys service via CI/CD
2. Automated tests run in staging
3. Gradual traffic shift (10% → 50% → 100%)
4. Automatic rollback if error rate spikes
5. Ops notified only if rollback fails

**Your new workflow**:
• Monitor #deployments Slack channel for notifications
• Check Grafana dashboard during business-hours deploys
• Approve production deploys for high-risk changes
• Investigate rollback alerts (rare, auto-handled)

### Incident Response Runbook

**Step 1**: Identify affected service
→ Check Grafana overview dashboard
→ Look for red status or error rate spikes

**Step 2**: Assess user impact
→ How many users affected? (check metrics)
→ Which features down? (check service map)

**Step 3**: Route to owning team
→ Page on-call for affected service (PagerDuty)
→ Post in service Slack channel

**Step 4**: Consider immediate mitigation
→ Can we route traffic around the service?
→ Should we rollback recent deploy?

**Step 5**: Monitor and coordinate
→ Track incident in status page
→ Communicate with stakeholders
→ Update customers if customer-facing

### Training & Onboarding

**Required training** (scheduled):
• Kubernetes basics (2 hours, March 5)
• Observability tools (3 hours, March 12)
• Incident response with microservices (2 hours, March 19)

**Self-paced resources**:
• Internal wiki: https://wiki.company.com/microservices-ops
• Video walkthroughs: https://training.company.com/ops
• Hands-on lab environment: https://lab.company.com

**Buddy system**:
• Assigned: Senior SRE for first 30 days
• Shadow deploys and incidents
• Ask questions anytime

### Common Scenarios

**Scenario 1**: Service shows yellow status
→ Degraded but functional, not urgent
→ Create ticket for owning team
→ Monitor, page if turns red

**Scenario 2**: Service shows red status
→ Down or critical errors
→ Immediate page to on-call
→ Follow incident response runbook

**Scenario 3**: Deploy fails automated checks
→ Auto-rollback triggered
→ Developer notified automatically
→ No ops action needed unless repeated failures

**Scenario 4**: Entire cluster has issues
→ Infrastructure problem (not service-specific)
→ Page platform team immediately
→ May need to failover to backup cluster

### On-Call Changes

**Before**: One on-call rotation for entire app
**After**: On-call per service + platform on-call

**You own**: Platform/infrastructure on-call
• Kubernetes cluster health
• Network and DNS issues
• Cross-service coordination

**Service teams own**: Service-specific on-call
• Service logic bugs
• Database issues
• API performance

### Alerts You'll Receive

**High priority** (immediate page):
• Kubernetes cluster CPU/memory > 90%
• Multiple services down simultaneously
• DNS or network failures
• Database cluster failover

**Medium priority** (Slack notification):
• Single service error rate spike
• Pod restart loops
• Certificate expiration warnings (7 days)

**Low priority** (email):
• Resource utilization trends
• Non-critical health checks
• Weekly summary reports

### Migration Timeline

**Phase 1** (Weeks 1-4): Setup
• You: Review new tools, attend training
• Impact: None yet, all changes in staging

**Phase 2** (Weeks 5-8): First services migrate
• You: Shadow deployments, learn new process
• Impact: Increased monitoring during business hours

**Phase 3** (Weeks 9-16): Full migration
• You: Gradual handoff, confidence building
• Impact: More frequent (but easier) deploys

**Phase 4** (Week 17+): Normal operations
• You: Fully autonomous with new system
• Impact: More efficient, less stressful on-call

### Support & Escalation

**Platform team**: #platform-team (Slack)
• Kubernetes, infrastructure, networking questions
• On-call: platform-oncall@company.com

**Service teams**: See wiki for each service owner
• Service-specific issues, deploy questions

**Emergency**: 1-800-555-ONCALL
• After-hours critical incidents
• When Slack is down

### Rollback Plan

If migration causes major issues:
• Can revert to monolith in 30 minutes
• Data syncs both ways during transition
• Tested rollback procedure weekly
• Your role: Initiate rollback if critical incident

### Feedback Welcome

This is new for everyone. Share concerns:
• Weekly ops sync: Fridays 2pm
• Anonymous feedback: https://forms.company.com/ops-feedback
• Direct message: Platform lead @john

### Quick Reference Card

**Service status**: grafana.company.com/overview
**Deploy logs**: jenkins.company.com/services  
**Runbook**: wiki.company.com/incident-response
**Training**: training.company.com/ops
**Emergency**: platform-oncall@company.com
```

## General Guidelines

### Know Your Audience's Time Constraints

- **C-level**: 1-paragraph summary + decision ask
- **VP/Director**: 1-page with exec summary
- **Manager**: 2-3 pages with details
- **IC**: Full technical depth

### Lead with What They Care About

```markdown
❌ Engineering-first:
"We'll use Kubernetes with Istio service mesh..."

✅ Audience-first:

For product: "Ship features 2x faster with lower risk..."
For leadership: "Enable $5M revenue initiatives while reducing costs 35%..."
For ops: "Easier deploys, better tools, clearer ownership..."
```

### Use Their Metrics

| Audience | Their Metrics |
|----------|---------------|
| Engineering | Code quality, tech debt, developer velocity |
| Product | Feature delivery, user satisfaction, adoption |
| Leadership | Revenue, cost, market position, strategic goals |
| Operations | Uptime, incident count, MTTR, on-call burden |

### Adjust Technical Depth

```markdown
High depth (Engineering):
"Using gRPC for synchronous inter-service communication 
with Protobuf serialization for type safety..."

Medium depth (Product/Ops):
"Services communicate using modern, efficient protocols..."

Low depth (Leadership):
"Architecture enables independent scaling and deployment..."
```

## Resources

### Communication Frameworks
- [The Pyramid Principle](https://medium.com/lessons-from-mckinsey/the-pyramid-principle-f0885dd3c5c7)
- [Writing for Busy Readers](https://mitpress.mit.edu/9780262539753/writing-for-busy-readers/)

### Presentation Skills
- [Storytelling with Data](https://www.storytellingwithdata.com/) - For executives
- [The Back of the Napkin](https://www.amazon.com/Back-Napkin-Solving-Problems-Pictures/dp/1591842697) - Visual explanations

## Quick Checklist

- [ ] Identified all stakeholder audiences
- [ ] Led with what each audience cares about
- [ ] Used audience-appropriate metrics
- [ ] Adjusted technical depth appropriately
- [ ] Answered their core question
- [ ] Consistent facts across all versions
- [ ] Clear call-to-action for each audience
- [ ] Appropriate length for each audience
- [ ] Proofread for jargon (especially non-engineering versions)
