# Planning Standards

This document defines planning standards, task breakdown principles, and execution frameworks.

## Sprint Planning

### Sprint Duration

- **Standard**: 2 weeks
- **Planning**: First Monday of sprint (2 hours)
- **Review**: Last Friday (1 hour)
- **Retrospective**: Last Friday (30 minutes)

### Sprint Goals

Every sprint must have:
- **Clear goal**: What we're achieving (not just list of tasks)
- **Success criteria**: How we know we succeeded
- **Capacity**: Team capacity minus 20% buffer
- **Dependencies**: External blockers identified

### Sprint Planning Process

1. **Review backlog** (30 min)
   - Product owner presents priorities
   - Team asks clarifying questions

2. **Task breakdown** (60 min)
   - Break epics into stories
   - Estimate story points
   - Identify dependencies

3. **Commit** (30 min)
   - Team commits to sprint goal
   - Assign tasks
   - Identify risks

## Task Breakdown

### INVEST Criteria

Good tasks are:
- **I**ndependent - Can be worked on separately
- **N**egotiable - Details can be discussed
- **V**aluable - Delivers value
- **E**stimable - Can estimate effort
- **S**mall - Completable in reasonable time (< 2 days)
- **T**estable - Clear acceptance criteria

### Task Template

```markdown
## [Task ID]: [Action-Oriented Title]

### Description
[What needs to be done and why]

### Acceptance Criteria
- [ ] Criterion 1 (specific, testable)
- [ ] Criterion 2
- [ ] Criterion 3

### Dependencies
- Depends on: [Task IDs]
- Blocks: [Task IDs]

### Estimated Effort
[Story points or hours]

### Assignee
[Name or skill level needed]

### Testing Strategy
[How to verify this works]
```

### Task Sizing

```markdown
**Extra Small (XS)** - 1-2 hours:
- Minor bug fixes
- Documentation updates
- Simple configuration changes

**Small (S)** - 2-4 hours:
- Add validation to form
- Write unit tests for function
- Update API documentation

**Medium (M)** - 4-8 hours:
- Create new API endpoint
- Implement feature with clear requirements
- Refactor module with guidance

**Large (L)** - 1-2 days:
- Complex feature implementation
- Database migration
- Integration with external service

**Extra Large (XL)** - >2 days:
- Should be broken down further
- Exception: Spikes, research tasks
```

### Delegation by Skill Level

```markdown
**Junior Developer** (< 1 year):
- Size: XS-S (1-4 hours)
- Type: Well-defined, low ambiguity
- Pairing: With mid/senior for L tasks

**Mid-Level Developer** (1-3 years):
- Size: S-M (2-8 hours)
- Type: Moderate complexity
- Review: Senior review for architectural changes

**Senior Developer** (3+ years):
- Size: M-L (4 hours - 2 days)
- Type: High complexity, design decisions
- Autonomy: Can work independently
```

## Estimation

### Story Points

Use Fibonacci sequence: 1, 2, 3, 5, 8, 13, 21

Relative sizing:
- **1 point**: Trivial (< 2 hours)
- **2 points**: Small (2-4 hours)
- **3 points**: Medium (4-8 hours)
- **5 points**: Large (1 day)
- **8 points**: Very large (2 days)
- **13+ points**: Too large (break down)

### Planning Poker

1. Product owner explains story
2. Team discusses and asks questions
3. Each person secretly estimates
4. Reveal estimates simultaneously
5. Discuss differences
6. Re-estimate until consensus

### Velocity Tracking

- Track completed story points per sprint
- Calculate average velocity (last 3 sprints)
- Use for future planning
- Adjust for team changes

## Risk Management

### Risk Register

For each risk:
- **Description**: What could go wrong
- **Impact**: High/Medium/Low
- **Likelihood**: High/Medium/Low
- **Mitigation**: How to prevent/minimize
- **Owner**: Who's responsible
- **Status**: Monitor/Mitigated/Accepted

### Risk Matrix

```
        High Impact
            │
    🔴  │  🔴  │  🔴
   ─────┼─────┼─────
    🟡  │  🔴  │  🔴
   ─────┼─────┼─────
    🟢  │  🟡  │  🔴
            │
        Low Impact
    
    Low ← Likelihood → High

🔴 High Risk: Address immediately
🟡 Medium Risk: Monitor and plan mitigation
🟢 Low Risk: Accept or deprioritize
```

### Risk Response Strategies

- **Avoid**: Change plan to eliminate risk
- **Mitigate**: Reduce probability or impact
- **Transfer**: Shift risk to third party
- **Accept**: Acknowledge and monitor

## Capacity Planning

### Team Capacity

Calculate available hours per sprint:

```
Capacity = (Team Size × Work Days × Hours per Day) × Focus Factor

Example:
- 5 developers
- 10 work days (2-week sprint)
- 6 productive hours per day
- 0.7 focus factor (meetings, support, etc.)

Capacity = 5 × 10 × 6 × 0.7 = 210 hours
```

### Focus Factor

Adjust for:
- Meetings (stand-ups, planning, reviews)
- Support/on-call duties
- Code reviews
- Unplanned work
- Learning/training

Typical focus factor: 0.6-0.8

### Buffer Time

Always include buffer:
- **10-20%** for known unknowns
- **Additional 10%** for unknown unknowns
- **More buffer** for high-risk projects

## Project Planning

### Project Phases

```markdown
**Phase 1: Discovery** (10-20% of timeline)
- Define problem and success criteria
- Identify constraints and risks
- Evaluate approaches
- Create high-level design
- Go/no-go decision

**Phase 2: Foundation** (20-30%)
- Core infrastructure
- Database schema
- API design
- Critical path items

**Phase 3: Implementation** (40-50%)
- Feature development
- Integration
- Testing
- Bug fixing

**Phase 4: Launch** (10-20%)
- Beta testing
- Performance tuning
- Documentation
- Rollout
```

### Critical Path

Identify critical path:
1. List all tasks
2. Identify dependencies
3. Calculate longest path from start to finish
4. Focus optimization on critical path

### Parallel Workstreams

Maximize parallelization:
- Independent teams work simultaneously
- Clear interfaces between components
- Regular synchronization points
- Shared understanding of goals

## Agile Ceremonies

### Daily Standup (15 min)

Format:
- **Yesterday**: What I completed
- **Today**: What I'm working on
- **Blockers**: What's in my way

Rules:
- Start on time
- Stand up (keeps it short)
- Park detailed discussions
- Timebox to 15 minutes

### Sprint Review (1 hour)

Agenda:
1. **Demo**: Show completed work (30 min)
2. **Metrics**: Velocity, completed points (10 min)
3. **Feedback**: Stakeholder input (15 min)
4. **Next Sprint**: Preview upcoming work (5 min)

### Sprint Retrospective (30 min)

Format (Start-Stop-Continue):
- **Start**: What should we start doing?
- **Stop**: What should we stop doing?
- **Continue**: What should we keep doing?

Action items:
- Identify 1-3 improvements
- Assign owners
- Track in next retrospective

### Backlog Refinement (1 hour weekly)

Activities:
- Break down epics into stories
- Estimate stories
- Clarify requirements
- Identify dependencies
- Prioritize backlog

## Prioritization

### Eisenhower Matrix

```
    Urgent │ Not Urgent
   ────────┼────────────
Important │    DO FIRST    │  SCHEDULE
         │  (Crises)      │  (Planning)
   ────────┼────────────
Not Impt  │   DELEGATE     │   ELIMINATE
         │  (Interrupts)  │  (Time wasters)
```

### Value vs Effort

```
     High Value
         │
    🟢  │  🟢  │  🟡
   ─────┼─────┼─────
    🟢  │  🟡  │  🔴
   ─────┼─────┼─────
    🟡  │  🔴  │  🔴
         │
     Low Value
    
    Low ← Effort → High

🟢 High priority: High value, low effort
🟡 Medium priority: Consider trade-offs
🔴 Low priority: Defer or eliminate
```

### RICE Framework

Score = (Reach × Impact × Confidence) / Effort

- **Reach**: How many users affected (per quarter)
- **Impact**: How much it helps (3=Massive, 2=High, 1=Medium, 0.5=Low, 0.25=Minimal)
- **Confidence**: How sure we are (100%=High, 80%=Medium, 50%=Low)
- **Effort**: Person-months required

## Roadmap Planning

### Quarterly Planning

Timeline:
- **6 weeks before quarter**: Initial planning
- **4 weeks before**: Stakeholder review
- **2 weeks before**: Finalize and commit
- **First week of quarter**: Kickoff

### Roadmap Format

```markdown
# Q2 2026 Roadmap

## Theme
[Overarching focus for the quarter]

## Goals
1. [Measurable goal 1]
2. [Measurable goal 2]
3. [Measurable goal 3]

## Initiatives

### Initiative 1: [Name]
- **Owner**: [Team/Person]
- **Timeline**: [Weeks 1-4]
- **Success Metrics**: [How we measure]
- **Dependencies**: [What we need]

### Initiative 2: [Name]
...
```

## Dependency Management

### Dependency Types

```markdown
**Internal Dependencies**:
- Team A needs API from Team B
- Frontend blocked by backend work
- Testing blocked by feature completion

**External Dependencies**:
- Third-party API integration
- Legal/compliance approval
- Infrastructure provisioning
- Security review
```

### Dependency Tracking

For each dependency:
- **Blocker**: What we need
- **Provider**: Who provides it
- **Due Date**: When we need it
- **Status**: On track/At risk/Blocked
- **Impact**: What happens if delayed

## Scope Management

### Scope Definition

```markdown
**Must Have** (MVP):
✅ Core functionality required for launch
✅ Non-negotiable features
✅ Critical for user value

**Should Have** (Target):
⚠️ Important but can defer if needed
⚠️ Adds significant value
⚠️ Flexible timeline

**Won't Have** (Out of Scope):
❌ Explicitly not included
❌ Future consideration
❌ Keeps project focused
```

### Scope Creep Prevention

- Clear acceptance criteria
- Change request process
- Impact assessment for changes
- Stakeholder alignment
- Regular scope reviews

## Communication Cadence

### Team Communication

- **Daily**: Standup (15 min)
- **Weekly**: Backlog refinement (1 hour)
- **Bi-weekly**: Sprint planning/review/retro (3.5 hours)
- **Monthly**: Team sync (1 hour)
- **Quarterly**: Planning session (half day)

### Stakeholder Communication

- **Weekly**: Status update (email or dashboard)
- **Bi-weekly**: Demo (if sprint aligned)
- **Monthly**: Business review
- **Quarterly**: Roadmap review

## Metrics & KPIs

### Velocity Metrics

- Story points completed per sprint
- Planned vs actual capacity
- Velocity trend (increasing/stable/decreasing)

### Quality Metrics

- Bug count (new vs fixed)
- Test coverage percentage
- Code review turnaround time
- Deployment frequency
- Mean time to recovery (MTTR)

### Delivery Metrics

- Cycle time (idea to production)
- Lead time (commit to deploy)
- On-time delivery rate
- Scope changes per sprint

## Resources

- [INVEST Criteria](https://en.wikipedia.org/wiki/INVEST_(mnemonic))
- [User Story Mapping](https://www.jpattonassociates.com/user-story-mapping/)
- [Shape Up](https://basecamp.com/shapeup) - Basecamp's planning process
- [RICE Prioritization](https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/)
- [Critical Path Method](https://en.wikipedia.org/wiki/Critical_path_method)
- [Eisenhower Matrix](https://www.eisenhower.me/eisenhower-matrix/)
