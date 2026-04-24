---
name: evidence-driven-engineering
description: >
  Apply this skill automatically whenever the user is doing any software engineering
  work — debugging, writing code, reviewing PRs, refactoring, infra changes, data
  analysis, or any technical task involving claims, changes, or diagnoses.
  Also apply when the user invokes /feynman explicitly.
  The skill has one instruction: doubt. Doubt the symptom, the hypothesis, the fix,
  the claim, the assumption. Only act when doubt has been resolved by evidence.
---

# Evidence-Driven Engineering

**One instruction: doubt first.**

Before acting on anything — a symptom, a hypothesis, a proposed change, a claim —
doubt it. Ask what evidence supports it. If the answer is "nothing observed", stop.

---

## Build the theory first

A program is not its source code. The source code is a lossy representation of a
theory — a mental model of how the system maps onto the real world — that lives in
the minds of the people who built it. (Naur, 1985.)

Before acting on any problem, ask: do you actually have that theory, or are you
operating on a surface reading of the code? The two are not the same. A change that
is syntactically correct and passes tests can still degrade the system if it doesn't
fit the underlying structure.

Doubt is the mechanism for testing whether you have the theory:

- Reading past the surface builds theory.
- Attributing a failure precisely refines theory.
- Verifying a claim rather than inferring from memory tests theory.
- Batching changes is what you do when you *don't* have the theory — if you understood
  the system, you'd know which single change addresses the observed failure.

When working on an unfamiliar system, or returning to one after time away, treat
theory-building as a prerequisite, not a side effect of fixing things.

---

## What to doubt, and how to resolve it

**Doubt the symptom.**
The surface failure is not the real failure. Read past it: full stack trace, log
output, exception message. Don't form a hypothesis until you've read the actual error.

**Doubt the hypothesis.**
A hypothesis must specifically explain the observed failure — not a class of failures,
not a feeling. If you can't state exactly what you expect to see when the hypothesis
is wrong, the hypothesis isn't specific enough.

**Doubt the fix.**
One change at a time. A fix that cannot be individually connected to an observed
failure has no justification. Batching changes means you can't know which one worked
or whether any of them were necessary. If removing a candidate change produces no
failure, the change was not needed.

**Doubt the claim.**
"The documentation says X" and "X is true" are different claims. Verify before
stating. Don't infer from memory or potentially outdated sources. State explicitly
whether a claim is verified or inferred.

**Doubt what you can't see.**
A change is never just what's in the diff. Side effects — transitive, environmental,
implicit — are real changes. Note them. "The declared state is X" and "the resolved
state is X" are not the same thing.

**Doubt the scope.**
A passing result on one path says nothing about other paths. State what was tested.
Don't generalize from a single case.

---

## Self-check

Before every action:

1. What did I observe that justifies this?
2. Have I read past the surface to the actual cause?
3. Is this one change, independently justified?
4. Is this claim verified or inferred?
5. What can't I see from here?
6. What does this not cover?

---

## Introspection: learning from reasoning errors

When a bug, misdiagnosis, or bad change occurs, the artifact of interest is not the
bug itself — it's the reasoning error that allowed it. Fixing the bug closes the
immediate failure. Identifying the reasoning error closes the class of failures.

After any significant mistake, ask: what was wrong with the *thinking*, not just the
*outcome*? Was there premature closure on a hypothesis? Confirmation bias in reading
the evidence? Conflation of two distinct concepts? Anchoring on the first plausible
explanation?

If the answer is a structural reasoning fallacy — a pattern that could recur
independently of this specific bug — record it.

**Threshold for saving:**

- Save automatically if the fallacy is structural and clearly reusable (i.e. it
  would be a useful warning in a future unrelated situation).
- If uncertain, surface the candidate fallacy to the user and ask whether it should
  be saved.
- Do not save incidental errors (misread variable name, wrong assumption about a
  specific API). These are noise.

**Format for saved entries** — append to
`~/.claude/rules/methodology/engineering-reasoning-fallacies.md`:

```markdown
## <Fallacy name>
Pattern: <One sentence describing the reasoning error.>
Corrective: <One sentence describing how to avoid or catch it.>
```

Example:

```markdown
## Anchoring on first hypothesis
Pattern: Forming a hypothesis early and interpreting subsequent evidence to fit it
rather than testing it against alternatives.
Corrective: State the hypothesis explicitly, then actively look for evidence that
would falsify it before looking for evidence that confirms it.
```

Keep entries short. The file is a reference, not a narrative. If it grows large,
it stops being read.
