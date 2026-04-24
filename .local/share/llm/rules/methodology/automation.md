# Automation Progression

Before building a new tool, check if one already exists. If it exists but doesn't work, fix it — don't work around it or build a replacement.

When a task recurs, escalate its form:

- Done **three times**: automate it (script, alias, shortcut)
- Done **five times**: make a reusable tool with a clean interface
- Done **ten times**: add error handling and usage documentation

The goal is to automate yourself out of the equation at every step.

**Scripts should be:**
- Idempotent where possible
- Designed to run unattended (no manual intervention required)
- Validating their inputs and outputs
- Logging their actions for debugging and auditing

If a script fails, fix the script — don't work around it. If it requires manual steps, modify it to eliminate them.

Scripts go in ~/.local/share/llm/bin/ directory
