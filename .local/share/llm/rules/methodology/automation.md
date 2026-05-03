# Automation Progression

Before building a new tool, check if one already exists. If it exists but doesn't work, fix it — don't work around it or build a replacement.

When a task recurs, escalate its form:

- Done **three times**: automate it (script, alias, shortcut)
- Done **five times**: broaden it (see below), then give it a clean interface
- Done **ten times**: add error handling and usage documentation

Treat these as signals, not requirements. If friction is obvious on first encounter and recurrence is predictable, automate immediately. A script earns further investment by proving its worth through use — start scrappy, let recurrence justify the polish.

The goal is to automate yourself out of the equation at every step.

## Broaden before deepening

When a script starts recurring in slightly different forms, resist adding more features to the specific case. Ask first: am I solving the same problem multiple times?

Signs you should broaden instead of deepen:
- Multiple scripts with similar names (`sync-staging.sh`, `sync-prod.sh`, `sync-dev.sh`)
- You copy-pasted a script to make a variation
- The tool is hardcoded to one project, environment, or service

The fix: parameterize the variable parts and handle the *class* of problems, not the instance. One configurable tool is cheaper to remember than five narrow ones.

Broadening is not gold-plating. Parameterize the axes that have already varied; leave everything else hardcoded until it varies. The goal is one tool that covers your real cases, not a framework that anticipates hypothetical ones.

Design the interface before adding parameters. A script with six flags that evolved organically is harder to use than one designed as a general tool from the start. If the interface feels awkward, reconsider the abstraction.

## Scripts should be

- Idempotent where possible
- Designed to run unattended
- Validating their inputs and outputs
- Logging their actions for debugging and auditing

## Fix, don't workaround

If a script fails, fix the script. If it requires manual steps, modify it to eliminate them. Working around a broken tool leaves the problem in place and undermines the entire point of having automated it.

## Interface

Design scripts to behave as you'd naturally invoke them — sensible defaults, predictable argument shapes. If you have to consult the help text every time, the interface is wrong. Fix the interface, not your memory.

## Insight compression

A script that encodes a non-obvious sequence — a tricky incantation, a hard-won workaround, a procedure with silent failure modes — is doing more than saving keystrokes. It's preserving knowledge that would otherwise have to be rediscovered. Log enough at runtime to reconstruct the *why*.

This compounds in an AI-augmented workflow. Every recurring task that lives in a script is one fewer thing an agent has to reason through from scratch. Deterministic CPU execution is always cheaper than GPU inference. Automation is not just personal productivity — it's AI economics.

Scripts go in `~/.local/share/llm/bin/`
