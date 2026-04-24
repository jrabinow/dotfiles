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

## Patching the instance instead of the class
Pattern: Fixing a bug only at the discovered location without searching for the same
pattern elsewhere in the codebase.
Corrective: After identifying a bug, grep for structurally similar code before
committing the fix — address the class, not just the instance.

## Workaround in place of fix
Pattern: Introducing a workaround to suppress a symptom rather than fixing the
underlying cause, because the proper fix is harder or slower.
Corrective: If a workaround is truly necessary, document it explicitly with the reason
and a reference to the proper fix — never let it silently become permanent.
