---
name: impact-summary
description: Transforms technical change logs and git commits into stakeholder-friendly impact summaries. Use when writing release notes, stakeholder updates, post-deployment communications, or when the user mentions changelog, release notes, or deployment summary.
---

# Change Logs to Impact Summary

## Purpose

Transform technical changes into stakeholder-friendly impact summaries that clearly communicate value delivered.

## When to Use

- Release notes for product managers and stakeholders
- Deployment notifications for operations teams
- Sprint review summaries for leadership
- Customer-facing changelog updates
- Post-deployment communication
- Quarterly achievement reports

## How to Use

### Input

Provide:
- Git commit history or pull requests
- Technical changelog entries
- List of tickets/issues completed
- Deployment details

### Output Structure

Every impact summary follows three categories:

```
1. User Impact - What end users will notice
2. System Impact - Performance, reliability, capacity changes
3. Operational Impact - What teams need to know
```

## Summary Format

### Standard Template

```markdown
# [Release Version] - [Date]

## Overview
[One paragraph: What shipped and primary value delivered]

## User Impact

### New Features
• [Feature name] - [User-facing benefit]
• [Feature name] - [User-facing benefit]

### Improvements
• [What improved] - [Benefit to users]
• [What improved] - [Benefit to users]

### Bug Fixes
• [What was fixed] - [How it helps users]

## System Impact

### Performance
• [Metric] improved by [X%]
• [Metric] reduced by [X%]

### Reliability
• [Improvement to uptime/stability]
• [Reduced errors/failures]

### Scalability
• [Increased capacity metric]

## Operational Impact

### For Engineering
• [What changed in deployment/tools]
• [New monitoring/alerts]

### For Support
• [New features to be aware of]
• [Known issues or limitations]

### For Operations
• [Infrastructure changes]
• [New dependencies or configurations]

## Breaking Changes
• [Change] - [Migration path]

## Known Issues
• [Issue] - [Workaround or timeline for fix]

## Next Release Preview
• [Upcoming feature/improvement]
```

## Example Transformations

### Example 1: Backend Refactoring

**Technical Changes (Git Log):**
```
- Refactored user authentication service
- Migrated from JWT to OAuth2
- Added Redis caching layer
- Optimized database queries in user profile endpoint
- Updated dependencies to latest versions
```

**Impact Summary:**

```markdown
# Release 2.5.0 - February 2, 2026

## Overview
Improved login security and performance through authentication system upgrade and caching implementation.

## User Impact

### Improvements
• **Faster profile loading** - Profile pages now load 60% faster (from 800ms to 300ms)
• **More secure login** - Enhanced authentication with industry-standard OAuth2 security
• **"Remember me" works longer** - Stay logged in for 30 days instead of 7 days

### No User-Visible Changes
• Authentication system upgraded (seamless transition, no action required)

## System Impact

### Performance
• User profile API response time: 800ms → 300ms (60% improvement)
• Database load reduced by 40% through caching
• Login endpoint throughput increased 3x

### Reliability
• Authentication service uptime improved to 99.95%
• Eliminated race condition causing occasional login failures
• Added automatic cache invalidation (prevents stale data)

### Security
• Upgraded to OAuth2 2.1 standard
• Removed deprecated JWT implementation
• All tokens now expire after 30 days of inactivity

## Operational Impact

### For Engineering
• New Redis instance deployed (us-east-1, 2GB cache)
• OAuth2 endpoints: `/oauth/authorize`, `/oauth/token`
• JWT endpoints deprecated, will be removed in v3.0

### For Support
• Users won't need to re-login after this update
• If users report login issues, check Redis cache status first
• Known issue: "Remember me" checkbox label unchanged (fix in v2.5.1)

### For Operations
• New dependency: Redis 7.0 (monitored via CloudWatch)
• Alert threshold: Cache hit rate < 85%
• Runbook updated: https://wiki.company.com/oauth2-troubleshooting

## Breaking Changes
• **API change**: JWT tokens issued before Feb 1 invalid after Feb 15
• **Migration**: Users will be prompted to log in again (one time only)
• **For API consumers**: Update to OAuth2 flow by March 1

## Next Release Preview (v2.6.0 - Feb 28)
• Single Sign-On (SSO) with Google/Microsoft
• Two-factor authentication option
```

### Example 2: Frontend UI Updates

**Technical Changes:**
```
- Redesigned dashboard layout
- Added dark mode toggle
- Implemented lazy loading for images
- Fixed responsive design issues on mobile
- Updated to React 18
```

**Impact Summary:**

```markdown
# Release 3.2.0 - February 2, 2026

## Overview
New dashboard design with dark mode and improved mobile experience.

## User Impact

### New Features
• **Dark mode** - Toggle dark theme in Settings → Appearance
• **Redesigned dashboard** - Cleaner layout with customizable widgets
• **Better mobile experience** - All features now work smoothly on phones

### Improvements
• **Faster image loading** - Images load progressively as you scroll
• **Smoother animations** - Reduced lag when switching between pages
• **Tablet support improved** - Optimized layout for iPad and tablets

### Bug Fixes
• Fixed navigation menu overlapping content on small screens
• Corrected date formatting in transaction history
• Resolved issue where charts didn't resize when window changed

## System Impact

### Performance
• Initial page load: 3.2s → 1.8s (44% faster)
• Images load on-demand (reduced initial bandwidth by 65%)
• Bundle size reduced from 1.2MB to 850KB

### User Experience
• Dark mode preference syncs across devices
• Dashboard layout customization saves automatically
• Reduced motion for users with accessibility preferences

## Operational Impact

### For Engineering
• Upgraded to React 18 (concurrent rendering enabled)
• New component library: @company/ui-components v2.0
• Storybook updated with dark mode variants

### For Support
• Dark mode toggle: Settings → Appearance → Theme
• To reset dashboard: Settings → Dashboard → Restore Defaults
• Known issue: Print preview doesn't respect dark mode yet

### For QA
• Test both light and dark mode for all new features
• Mobile testing required for all PR approvals
• Updated testing checklist in wiki

## Known Issues
• Dark mode print preview shows light theme (fix planned for v3.2.1)
• Custom dashboard layouts don't sync to mobile app yet
• Chrome 90-92 may show flash of light theme on load

## Next Release Preview (v3.3.0 - Mar 1)
• High contrast mode for accessibility
• Dashboard templates (pre-built layouts)
• Export dashboard as PDF
```

### Example 3: Infrastructure Update

**Technical Changes:**
```
- Migrated database to PostgreSQL 15
- Implemented database read replicas
- Added automated backup system
- Upgraded Kubernetes cluster
- Implemented blue-green deployment
```

**Impact Summary:**

```markdown
# Infrastructure Update - February 2, 2026

## Overview
Zero-downtime infrastructure upgrade enabling faster deployments and improved reliability.

## User Impact

### Improvements
• **More reliable service** - Automatic failover prevents outages during maintenance
• **Faster loading** - Database improvements reduce page load times by 25%
• **No more maintenance windows** - Future updates happen seamlessly without downtime

### No User-Visible Changes
• Backend infrastructure upgraded (no action required from users)

## System Impact

### Performance
• Read query latency: 150ms → 90ms (40% improvement)
• Write query latency: 200ms → 180ms (10% improvement)
• Concurrent user capacity: 10K → 25K (2.5x increase)

### Reliability
• Database backup every 4 hours (was 24 hours)
• Point-in-time recovery available (restore to any moment in last 7 days)
• Automated failover: 30 seconds (was 5 minutes manual)

### Scalability
• Read replicas distribute load across 3 servers
• Can scale horizontally to handle 100K users
• Storage auto-scales up to 10TB

## Operational Impact

### For Engineering
• Deployments now use blue-green strategy (instant rollback)
• Database connection pooling configured (max 100 connections)
• New monitoring dashboard: https://grafana.company.com/infra

### For Operations
• **Deployment process changed**: See new runbook
• **Rollback time**: < 30 seconds (was 10 minutes)
• **Health checks**: Every 10 seconds on all services
• **Alerts configured**: Database lag, replica sync status

### For Support
• No customer impact expected
• If database issues reported, check replica status first
• Escalation contact: Platform team (#platform-oncall)

## Breaking Changes
**None** - Fully backward compatible

## Monitoring & Alerts

New alerts configured:
• Replica lag > 5 seconds → Page on-call
• Backup failure → Email platform team
• Connection pool > 80% → Warning in Slack

## Rollback Plan
• Blue-green deployment enables instant rollback
• Database can revert to previous version in 15 minutes
• Tested rollback procedure on staging

## Next Steps
• Monitor replica performance for 1 week
• Tune connection pool based on actual usage
• Plan for multi-region setup in Q2
```

## Writing Guidelines

### Focus on Impact, Not Activity

❌ **Activity-focused**: "Refactored authentication service"
✅ **Impact-focused**: "Login now 60% faster with enhanced security"

❌ **Activity-focused**: "Updated dependencies"
✅ **Impact-focused**: "Closed 3 security vulnerabilities through library updates"

### Use Concrete Metrics

| Vague | Concrete |
|-------|----------|
| "Much faster" | "60% faster (800ms → 300ms)" |
| "More reliable" | "Uptime improved from 99.5% to 99.95%" |
| "Better performance" | "Page load reduced from 3.2s to 1.8s" |
| "Reduced errors" | "Login failures down 85% (150/day → 22/day)" |

### Translate Technical Terms

| Technical | Stakeholder-Friendly |
|-----------|---------------------|
| "Implemented caching layer" | "Faster page loads through smart data storage" |
| "Migrated to microservices" | "More reliable system that can be updated without downtime" |
| "Added horizontal scaling" | "Can now handle 3x more users during peak times" |
| "Refactored database queries" | "Reduced server costs by 30% through efficiency improvements" |

### Group Related Changes

```markdown
❌ Scattered:
• Fixed bug in user profile
• Updated UI colors
• Fixed bug in dashboard
• Added dark mode
• Fixed mobile menu bug

✅ Grouped:
### New Features
• Added dark mode toggle

### Improvements
• Updated UI colors for better accessibility

### Bug Fixes
• Fixed issues in user profile, dashboard, and mobile menu
```

## Audience-Specific Versions

### For End Users (Public Changelog)

Focus on:
- New features they can use
- Improvements they'll notice
- Bugs that affected them

Skip:
- Technical implementation details
- Internal tooling changes
- Non-user-facing performance improvements

### For Product Managers

Include:
- Feature completion status
- User-facing changes with metrics
- Customer impact assessment
- Alignment with roadmap goals

### For Engineering Team

Include:
- Technical changes and rationale
- New tools or processes
- Breaking changes with migration guides
- Performance benchmarks

### For Operations/Support

Include:
- Deployment changes
- New monitoring/alerts
- Known issues and workarounds
- Escalation procedures

## Resources

### Standards
- [Keep a Changelog](https://keepachangelog.com/) - Changelog format standard
- [Semantic Versioning](https://semver.org/) - Version numbering system

### Examples
- [GitHub Changelog](https://github.blog/changelog/) - Product changelog examples
- [Stripe API Changelog](https://stripe.com/docs/upgrades) - API versioning

### Tools
- [Conventional Commits](https://www.conventionalcommits.org/) - Structured commit messages
- [Release Notes Generator](https://github.com/release-drafter/release-drafter) - Automate from PRs

## Quick Checklist

- [ ] Organized into User/System/Operational impact
- [ ] Metrics are specific (percentages, timings)
- [ ] Technical terms translated to business language
- [ ] Breaking changes clearly highlighted
- [ ] Known issues with workarounds listed
- [ ] Next steps or upcoming changes noted
- [ ] Appropriate level of detail for audience
- [ ] Action items clearly called out
- [ ] Contacts/escalation paths provided
- [ ] Links to documentation included
