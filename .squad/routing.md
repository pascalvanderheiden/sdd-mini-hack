# Work Routing

How to decide who handles what.

## Routing Table

| Work Type | Route To | Examples |
|-----------|----------|----------|
| New scenario / use-case design | 🏗️ Neo | Design a new SDD scenario, learning-path coherence, pick the tool to teach |
| Sample / demo apps | ⚛️ Trinity | Build or extend `examples/<app>`, greenfield demo apps, Node/JS frontends + servers |
| SDD tooling & skills | 🔧 Tank | OpenSpec/Spec Kit setup, MCP config, Copilot CLI, Agent Skills, `scripts/`, devcontainer |
| Scenario docs & guides | 📝 Mouse | `docs/scenario-N-*.md`, README, prerequisites, walkthrough prose |
| Code & content review | 🏗️ Neo | Review PRs, check accuracy, gate quality before shipping |
| Testing & validation | 🧪 Switch | Validate scenarios end to end, Playwright MCP/CLI, `verify-workshop.sh`, edge cases |
| Demo / screen recordings | 🎬 Sparks | Record scenario demos to `media/videos/`, Playwright video capture, VHS terminal tapes, ffmpeg stitching, dry-run-then-record |
| Scope & priorities | 🏗️ Neo | What use case to add next, trade-offs, decisions |
| Async issue work (bugs, tests, small features) | @copilot 🤖 | Well-defined tasks matching capability profile |
| Session logging | Scribe | Automatic — never needs routing |

## Spec Kit Lifecycle (scenario execution)

The root squad **builds** scenarios; it does not run a scenario's Spec Kit lifecycle. Each scenario that requires speckit execution (constitution → specify → plan → tasks → analyze → checklist → implement) hires its own **folder-scoped squad** under `examples/<scenario>/.squad/`, themed per scenario. Keep execution agents out of the root maintainer squad.

## Issue Routing

| Label | Action | Who |
|-------|--------|-----|
| `squad` | Triage: analyze issue, evaluate @copilot fit, assign `squad:{member}` label | Lead |
| `squad:{name}` | Pick up issue and complete the work | Named member |
| `squad:copilot` | Assign to @copilot for autonomous work (if enabled) | @copilot 🤖 |

### How Issue Assignment Works

1. When a GitHub issue gets the `squad` label, the **Lead** triages it — analyzing content, evaluating @copilot's capability profile, assigning the right `squad:{member}` label, and commenting with triage notes.
2. **@copilot evaluation:** The Lead checks if the issue matches @copilot's capability profile (🟢 good fit / 🟡 needs review / 🔴 not suitable). If it's a good fit, the Lead may route to `squad:copilot` instead of a squad member.
3. When a `squad:{member}` label is applied, that member picks up the issue in their next session.
4. When `squad:copilot` is applied and auto-assign is enabled, `@copilot` is assigned on the issue and picks it up autonomously.
5. Members can reassign by removing their label and adding another member's label.
6. The `squad` label is the "inbox" — untriaged issues waiting for Lead review.

### Lead Triage Guidance for @copilot

When triaging, the Lead should ask:

1. **Is this well-defined?** Clear title, reproduction steps or acceptance criteria, bounded scope → likely 🟢
2. **Does it follow existing patterns?** Adding a test, fixing a known bug, updating a dependency → likely 🟢
3. **Does it need design judgment?** Architecture, API design, UX decisions → likely 🔴
4. **Is it security-sensitive?** Auth, encryption, access control → always 🔴
5. **Is it medium complexity with specs?** Feature with clear requirements, refactoring with tests → likely 🟡

## Rules

1. **Eager by default** — spawn all agents who could usefully start work, including anticipatory downstream work.
2. **Scribe always runs** after substantial work, always as `mode: "background"`. Never blocks.
3. **Quick facts → coordinator answers directly.** Don't spawn an agent for "what port does the server run on?"
4. **When two agents could handle it**, pick the one whose domain is the primary concern.
5. **"Team, ..." → fan-out.** Spawn all relevant agents in parallel as `mode: "background"`.
6. **Anticipate downstream work.** If a feature is being built, spawn the tester to write test cases from requirements simultaneously.
7. **Issue-labeled work** — when a `squad:{member}` label is applied to an issue, route to that member. The Lead handles all `squad` (base label) triage.
8. **@copilot routing** — when evaluating issues, check @copilot's capability profile in `team.md`. Route 🟢 good-fit tasks to `squad:copilot`. Flag 🟡 needs-review tasks for PR review. Keep 🔴 not-suitable tasks with squad members.
