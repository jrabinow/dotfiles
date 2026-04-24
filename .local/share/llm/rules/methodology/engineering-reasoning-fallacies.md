# Engineering Reasoning Fallacies

Catalogue of structural reasoning errors observed in engineering work.
Each entry is a pattern that recurs independently of any specific bug or codebase.

Entries are appended automatically by the evidence-driven-engineering skill when a
fallacy meets the threshold for saving. Do not add incidental or context-specific
mistakes here — only reusable patterns.

Install path: `~/.claude/rules/methodology/engineering-reasoning-fallacies.md`

To install: `mkdir -p ~/.claude/rules/methodology && cp engineering-reasoning-fallacies.md ~/.claude/rules/methodology/`

---

## Anchoring on first hypothesis
Pattern: Forming a hypothesis early and interpreting subsequent evidence to fit it
rather than testing it against alternatives.
Corrective: State the hypothesis explicitly, then actively look for evidence that
would falsify it before looking for evidence that confirms it.

## Conflating symptom with cause
Pattern: Treating the outermost observable failure as the thing to fix, without
reading deeper into the actual root cause.
Corrective: Always read the full error — stack trace, log output, exception chain —
before forming any hypothesis about what to change.

## Copying without connecting
Pattern: Applying a fix from an external source (PR, Stack Overflow, prior incident)
without independently tracing each change back to an observed failure in the current
context.
Corrective: Treat external fixes as leads, not recipes. Each element must earn its
place by connecting to something observed here.
