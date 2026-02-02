# Cursor Productivity System for Senior Engineers & Architects

A comprehensive productivity system for Cursor IDE featuring 21 specialized skills, coding standards, helper commands, and agent configurations tailored for senior engineers and architects.

## 📋 What's Included

### 🎯 21 Specialized Skills

Skills are organized into 5 categories:

#### UI & Design (1 skill)
- **intent-to-ui** - Convert user intent and constraints into UI wireframes and visual layouts

#### Communication & Documentation (5 skills)
- **executive-narrative** - Transform technical thoughts into executive communications
- **decision-ppt** - Create decision-ready presentations from notes
- **error-communication** - Translate backend rules into user-friendly error messages
- **impact-summary** - Convert change logs into stakeholder-friendly summaries
- **stakeholder-language** - Adapt technical content for different audiences

#### Architecture & Technical (7 skills)
- **system-to-diagrams** - Convert system flows into architecture diagrams (C4, sequence, component)
- **living-docs** - Keep architecture documentation in sync with changes
- **create-adr** - Extract architectural decisions from discussions into formal ADRs
- **edge-case-discovery** - Expand requirements into edge cases and failure modes
- **feature-shaping** - Shape feature ideas into end-to-end solutions
- **api-evolution** - Validate API changes for contract safety and backward compatibility
- **artifact-review** - Pre-review designs and code for risks before formal review

#### Review & Quality (5 skills)
- **self-review** - Review your own work as a neutral senior peer would
- **pr-review** - Intelligent PR scanning for architectural drift and risks
- **pre-pr-check** - Validate changes against checklist before PR submission
- **test-assistant** - Generate test scenarios and validation steps

#### Planning & Execution (3 skills)
- **task-decomposition** - Break features into concrete, dependency-aware tasks
- **execution-plan** - Convert goals and constraints into prioritized execution plans
- **test-planning** - Create comprehensive testing strategies

### 📚 4 Standards Documents

Located in `rules/`:

1. **architecture-standards.md** - ADR format, C4 diagrams, technology selection, architecture patterns, performance standards
2. **communication-standards.md** - Executive communication, presentations, error messages, documentation, incident communication
3. **code-quality-standards.md** - Code review checklist, testing standards, API conventions, security, git workflow
4. **planning-standards.md** - Sprint planning, task breakdown, INVEST criteria, risk management, agile ceremonies

### 🛠️ 3 Helper Commands

Located in `commands/` (executable scripts):

1. **diagram-generator.sh** - Generate Mermaid diagrams from source files
2. **adr-template.sh** - Create and manage Architecture Decision Records
3. **validate-api.sh** - Validate OpenAPI specs for breaking changes

### 🤖 2 Agent Configurations

Located in `agents/`:

1. **architect-agent.md** - Specialized agent for architecture and system design tasks
2. **reviewer-agent.md** - Specialized agent for code and design review tasks

## 🚀 Getting Started

### Installation

This system is already set up in your `.cursor/` directory:

```
.cursor/
├── skills/           # 21 specialized skills
├── rules/            # 4 standards documents
├── commands/         # 3 helper scripts
└── agents/           # 2 agent configurations
```

### Using Skills

Skills are automatically discovered by Cursor. Use them by referencing in your prompts:

```
@create-adr Document our decision to use PostgreSQL instead of MongoDB

@executive-narrative Convert these technical notes into an executive summary

@system-to-diagrams Create architecture diagrams for this order processing flow

@pr-review Review this PR for security issues and performance problems

@task-decomposition Break down this email verification feature into tasks
```

### Using Commands

Helper scripts are executable bash scripts:

```bash
# Generate architecture diagrams
./.cursor/commands/diagram-generator.sh generate docs/architecture.mmd

# Create new ADR
./.cursor/commands/adr-template.sh new "Use Redis for caching"

# Validate API changes
./.cursor/commands/validate-api.sh compare v1-api.json v2-api.json
```

### Using Standards

Standards in `rules/` are automatically referenced by Cursor agents to ensure consistency across:
- Architecture decisions
- Communication style
- Code quality
- Planning processes

## 📖 Skill Categories Explained

### When to Use Each Category

**UI & Design Skills**
- Early feature exploration
- Stakeholder alignment on user flows
- Rapid prototyping
- Mobile-first design planning

**Communication Skills**
- Preparing leadership presentations
- Writing release notes
- Creating error messages
- Stakeholder updates

**Architecture Skills**
- Design documentation
- Architecture reviews
- Technology decisions
- System design discussions

**Review & Quality Skills**
- Before submitting PRs
- During code review
- Pre-deployment validation
- Quality gates

**Planning Skills**
- Sprint planning
- Feature scoping
- Resource allocation
- Risk management

## 💡 Key Features

### Progressive Disclosure
Skills are concise (< 500 lines) with references to detailed documentation where needed.

### Cursor-Optimized
All skills are specifically formatted for Cursor IDE with:
- Third-person descriptions for auto-discovery
- Trigger terms for when to use each skill
- Cursor-compatible paths and conventions
- Mermaid diagrams for visualization

### Practical Examples
Every skill includes:
- Real-world examples
- Before/after comparisons
- Templates and checklists
- Common mistakes to avoid

### Standards-Based
Consistent quality through:
- Architecture Decision Records (ADR format)
- C4 Model for diagrams
- OpenAPI for API specs
- Conventional commits
- INVEST criteria for tasks

## 📂 Directory Structure

```
.cursor/
├── skills/
│   ├── intent-to-ui/SKILL.md
│   ├── executive-narrative/SKILL.md
│   ├── decision-ppt/SKILL.md
│   ├── error-communication/SKILL.md
│   ├── impact-summary/SKILL.md
│   ├── stakeholder-language/SKILL.md
│   ├── system-to-diagrams/SKILL.md
│   ├── living-docs/SKILL.md
│   ├── create-adr/SKILL.md
│   ├── edge-case-discovery/SKILL.md
│   ├── feature-shaping/SKILL.md
│   ├── api-evolution/SKILL.md
│   ├── artifact-review/SKILL.md
│   ├── self-review/SKILL.md
│   ├── pr-review/SKILL.md
│   ├── pre-pr-check/SKILL.md
│   ├── test-assistant/SKILL.md
│   ├── task-decomposition/SKILL.md
│   ├── execution-plan/SKILL.md
│   └── test-planning/SKILL.md
├── rules/
│   ├── architecture-standards.md
│   ├── communication-standards.md
│   ├── code-quality-standards.md
│   └── planning-standards.md
├── commands/
│   ├── diagram-generator.sh
│   ├── adr-template.sh
│   └── validate-api.sh
├── agents/
│   ├── architect-agent.md
│   └── reviewer-agent.md
└── README.md (this file)
```

## 🎯 Common Use Cases

### Architecture Design
```
1. @feature-shaping - Shape feature idea into solution
2. @system-to-diagrams - Create architecture diagrams
3. @create-adr - Document key decisions
4. @artifact-review - Pre-review for risks
```

### Code Review
```
1. @self-review - Review your own code first
2. @pre-pr-check - Validate against checklist
3. Submit PR
4. @pr-review - Reviewer uses for comprehensive analysis
```

### Communication
```
1. @executive-narrative - Transform notes to executive summary
2. @decision-ppt - Create presentation slides
3. @stakeholder-language - Adapt for different audiences
4. @impact-summary - Write release notes
```

### Planning
```
1. @task-decomposition - Break feature into tasks
2. @execution-plan - Create prioritized plan
3. @test-planning - Define testing strategy
4. @edge-case-discovery - Identify failure modes
```

## 🔧 Customization

### Adding New Skills

1. Create directory: `.cursor/skills/your-skill-name/`
2. Create `SKILL.md` with frontmatter:
```yaml
---
name: your-skill-name
description: Third-person description with WHAT and WHEN triggers
---
```
3. Add skill content following the template in existing skills

### Modifying Standards

Edit files in `.cursor/rules/` to match your team's conventions:
- `architecture-standards.md` - Your architecture patterns
- `communication-standards.md` - Your communication style
- `code-quality-standards.md` - Your code standards
- `planning-standards.md` - Your planning process

### Extending Commands

Add new bash scripts to `.cursor/commands/`:
```bash
#!/bin/bash
# Your command script
# Make executable: chmod +x your-command.sh
```

## 📚 Resources

### Frameworks Referenced
- [C4 Model](https://c4model.com/) - Architecture diagrams
- [Architecture Decision Records](https://adr.github.io/) - ADR format
- [Shape Up](https://basecamp.com/shapeup) - Feature shaping
- [INVEST Criteria](https://en.wikipedia.org/wiki/INVEST_(mnemonic)) - Task breakdown
- [Pyramid Principle](https://www.barbaraminto.com/) - Communication

### Tools Supported
- Mermaid.js - Diagram generation
- OpenAPI/Swagger - API documentation
- Conventional Commits - Git conventions
- Jest/pytest - Testing frameworks

## 🤝 Best Practices

### Skill Usage
- **Be specific**: Reference the exact skill you need
- **Provide context**: Include relevant details in your prompt
- **Iterate**: Skills work best in conversation
- **Combine skills**: Use multiple skills for complex tasks

### Standards Adherence
- Review standards before major decisions
- Update standards as practices evolve
- Share standards with new team members
- Reference standards in code reviews

### Command Usage
- Make commands executable: `chmod +x .cursor/commands/*.sh`
- Add commands to PATH for easier access
- Use commands in CI/CD pipelines
- Extend commands for team-specific needs

## 📝 License

This productivity system is based on industry best practices and open standards. Adapt and modify freely for your team's needs.

## 🎓 Learning Path

### Week 1: Core Skills
- Start with `self-review` and `pre-pr-check`
- Try `executive-narrative` for your next update
- Experiment with `task-decomposition`

### Week 2: Architecture
- Use `system-to-diagrams` for documentation
- Create your first ADR with `create-adr`
- Try `feature-shaping` for next feature

### Week 3: Quality & Planning
- Deep dive into `pr-review` for code reviews
- Use `test-planning` for comprehensive testing
- Try `execution-plan` for project planning

### Week 4: Advanced
- Explore `api-evolution` for API changes
- Use `artifact-review` before major reviews
- Customize agent configurations

## 🆘 Troubleshooting

### Skills Not Appearing
- Verify files are in `.cursor/skills/*/SKILL.md`
- Check YAML frontmatter is valid
- Ensure description is clear with trigger terms

### Commands Not Executing
- Make scripts executable: `chmod +x .cursor/commands/*.sh`
- Check for missing dependencies (listed in each script)
- Verify bash is available: `which bash`

### Standards Not Being Applied
- Ensure files are in `.cursor/rules/*.md`
- Reference standards explicitly in prompts
- Check agent configurations point to rules

## 🚀 What's Next

This system is designed to evolve with your team. Consider:

1. **Team Calibration**: Review skills with team, adjust to match your practices
2. **Custom Skills**: Add team-specific skills for your domain
3. **Metric Tracking**: Measure impact on velocity, quality, documentation
4. **Feedback Loop**: Gather team feedback, iterate on skills
5. **Integration**: Incorporate into onboarding, code review, planning

---

**Built for**: Senior Engineers & Architects  
**Compatible with**: Cursor IDE  
**Version**: 1.0  
**Last Updated**: February 2, 2026
