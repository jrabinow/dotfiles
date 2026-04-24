---
name: software-design
description: >
  Apply when the user is designing or building a software component meant to be
  reused, composed, or maintained over time — a library, CLI, service, script, or
  module. Not for one-off throwaway code with no reuse intent.
---

# Software Design

## Interface first

Design the interface before the implementation. An interface is a contract — it should be:
- **Minimal**: expose only what callers need
- **Consistent**: follow conventions of the surrounding codebase (naming, signatures, output format)
- **Unsurprising**: behave in ways a user familiar with similar components would expect

If you can't describe the interface in one sentence, the scope is too broad.

## Composability

Components should work as building blocks:
- Read from stdin, write to stdout where applicable
- Accept and emit structured formats when output will be piped or consumed programmatically
- Exit with meaningful codes (0 = success, non-zero = failure)
- Don't mix concerns: one component does one thing well

## Error handling

Errors are part of the interface. A component that fails silently or with a cryptic message is broken.
- Validate inputs early, fail fast with a clear message
- Distinguish between caller error (bad input) and system error (unexpected failure) — they warrant different messages and, for CLIs, different exit codes
- Never swallow errors; surface them with enough context to act on

## Testability

Design for testability from the start:
- Separate logic from I/O so core behavior can be tested without side effects
- Make side effects explicit (filesystem writes, network calls, process execution)
- A component you can't test is a component you can't safely change

## Documentation

A component is only as good as its discoverability:
- The entry point (README, `--help`, docstring) should be enough to use it without reading source
- Include at least one concrete usage example
- Document non-obvious behavior, especially around edge cases and failure modes
