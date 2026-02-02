---
name: executive-narrative
description: Transforms unstructured technical thoughts into crisp executive communications. Use when preparing leadership presentations, architecture reviews, proposal documents, post-incident summaries, or when the user needs executive-level communication.
---

# Raw Thinking to Executive Narrative

## Purpose

Transform unstructured technical thoughts into crisp, actionable executive communications that drive decisions.

## When to Use

- Architecture review presentations for leadership
- Proposal documents for VP/C-level executives
- Post-incident executive summaries
- Quarterly planning documents
- Technical strategy communications
- Budget justification for technical initiatives

## How to Use

### Input Format

Provide your raw technical notes, including:
- Technical problems and context
- Solution approaches considered
- Trade-offs and decisions made
- Cost/resource implications
- Timeline estimates
- Risk factors

### Output Structure

All executive narratives follow this proven structure:

```
1. Problem (What's wrong/needed)
2. Solution (What we're doing)
3. Impact (Why it matters)
```

## The Pyramid Principle

Structure communications top-down:
1. **Lead with the answer** - Don't build up to the conclusion
2. **Support with grouped arguments** - 3-5 key points maximum
3. **Each point stands alone** - Executive can stop reading at any level

## Example Transformation

### Raw Input (Engineer's Notes)

```
We've been having performance issues with the database. Response times 
are getting slow during peak hours. We looked at several options:
1. Upgrade database instance (costs more)
2. Add caching layer with Redis
3. Optimize queries

We think Redis caching is best because it's cheaper than upgrading and 
faster to implement than query optimization. We can get it done in 
3 weeks. It will cost about $5K in infra. We tested it and got 70% 
reduction in response times.
```

### Executive Output

```
**Database Performance Solution**

**Problem**: Peak-hour database response times have degraded 3x over the 
past quarter, risking user experience and potential SLA violations.

**Solution**: Implement Redis caching layer to reduce database load by 70%.

**Impact**:
• User experience: Response times return to sub-200ms targets
• Cost: $5K one-time + $2K/year operational (vs $50K database upgrade)
• Timeline: 3-week implementation with zero downtime
• Risk mitigation: Prevents projected SLA penalty exposure of $100K/year

**Next Steps**: Approve $5K infrastructure investment for immediate implementation.
```

## Format Templates

### 1-Page Executive Summary

```markdown
# [Initiative Name]

## Executive Summary
[One paragraph: Problem + Solution + Expected outcome]

## Business Context
• Why this matters now
• What happens if we don't act
• Strategic alignment

## Proposed Solution
• High-level approach
• Key components
• Differentiation from alternatives

## Expected Impact
• Quantified business outcomes
• Timeline to value
• Resource requirements

## Risks & Mitigation
• Top 3 risks
• How we'll address each

## Decision Required
[Specific ask with deadline]
```

### Post-Incident Executive Summary

```markdown
# [Incident Name] - Executive Summary

## Impact
• Duration: [X hours]
• Affected users: [X% or count]
• Revenue impact: [$X or none]
• SLA status: [Met/Breached]

## Root Cause
[One sentence technical cause + business impact]

## Immediate Actions Taken
• [Action 1 with timestamp]
• [Action 2 with timestamp]
• [Action 3 with timestamp]

## Prevention Plan
• Short-term (this week): [Action]
• Medium-term (this month): [Action]
• Long-term (this quarter): [Investment needed]

## Lessons Learned
[Top 3 systemic insights]
```

### Architecture Decision Proposal

```markdown
# [Architecture Decision]: [Brief Title]

## Current State Problem
[What's not working and why it matters to business]

## Proposed Architecture
[High-level solution - save technical details for appendix]

## Business Impact
• Performance: [Quantified improvement]
• Scalability: [Growth capacity gained]
• Cost: [Net change with ROI timeline]
• Developer velocity: [Impact on feature delivery]

## Alternatives Considered
| Option | Pros | Cons | Cost | Timeline |
|--------|------|------|------|----------|
| A      | ...  | ...  | ...  | ...      |
| B      | ...  | ...  | ...  | ...      |

**Recommendation**: [Option X] because [business reason]

## Implementation Plan
• Phase 1 (Month 1): [Milestone]
• Phase 2 (Month 2): [Milestone]
• Phase 3 (Month 3): [Milestone]

## Decision Needed
[Specific approval request with deadline]
```

## Writing Guidelines

### Lead with Impact

❌ **Avoid**: "We implemented a microservices architecture..."
✅ **Better**: "New architecture enables 10x faster feature deployment..."

### Use Business Language

| Technical Term | Executive Translation |
|----------------|----------------------|
| "Refactor the codebase" | "Reduce technical debt to improve feature velocity" |
| "Add monitoring" | "Improve system visibility to prevent outages" |
| "Upgrade framework" | "Maintain security compliance and vendor support" |
| "Optimize queries" | "Reduce infrastructure costs by 40%" |

### Quantify Everything

- Response time improvement: "70% faster" not "much faster"
- Cost savings: "$50K annual reduction" not "saves money"
- Timeline: "3-week implementation" not "relatively quick"
- Risk: "Prevents $100K SLA penalty exposure" not "reduces risk"

### Keep It Concise

- **One page maximum** for summaries
- **3-5 bullet points** per section
- **One idea per sentence**
- **Short paragraphs** (3-4 lines max)

## Audience-Specific Adjustments

### For CEO/Board
- Focus on: Business outcomes, competitive advantage, strategic alignment
- Include: Revenue impact, market position, risk to business
- Skip: Technical implementation details

### For VP Engineering
- Focus on: Team impact, technical strategy, resource allocation
- Include: Architectural decisions, team efficiency, quality metrics
- Balance: Technical depth with business justification

### For Product Leadership
- Focus on: Feature velocity, user experience, time-to-market
- Include: Product capability improvements, customer impact
- Skip: Infrastructure details unless affecting product

### For CFO/Finance
- Focus on: ROI, cost efficiency, budget impact
- Include: Detailed cost breakdown, payback period, ongoing costs
- Must have: Clear financial justification

## Common Pitfalls to Avoid

1. **Building suspense**: Don't save conclusion for the end
2. **Technical jargon**: Translate to business terms
3. **Burying the ask**: State decision needed upfront
4. **Vague benefits**: Always quantify impact
5. **Missing the "why now"**: Explain urgency or opportunity cost
6. **Too many options**: Max 3 alternatives, recommend one
7. **Lack of confidence**: Be clear and decisive

## Resources

### Communication Frameworks
- [The Pyramid Principle](https://www.barbaraminto.com/) by Barbara Minto
- [Amazon's 6-page narrative structure](https://writingcooperative.com/the-anatomy-of-an-amazon-6-pager-fc79f31a41c9)
- [McKinsey's SCQA Framework](https://www.craftingcases.com/scqa-framework/) (Situation, Complication, Question, Answer)

### Writing Tools
- [Hemingway Editor](http://www.hemingwayapp.com/) - Simplify complex writing
- [Grammarly](https://www.grammarly.com/) - Professional tone and clarity

## Quick Checklist

Before sending your executive narrative:

- [ ] Lead with the answer/recommendation
- [ ] Problem statement is business-focused
- [ ] All benefits are quantified
- [ ] Technical terms translated to business language
- [ ] Specific decision or approval requested
- [ ] Timeline is clear with milestones
- [ ] Risks are identified with mitigation
- [ ] Under 300 words for summaries (under 1 page)
- [ ] No jargon that requires technical background
- [ ] Proofread for clarity and grammar
