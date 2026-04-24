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

Components should work as building blocks — CLIs, functions, and APIs alike.

**Be ignorant of context.** A component should know nothing about what feeds it or consumes it. The moment it assumes something about its caller, it stops being freely composable.

**Question every parameter.** Each one is a coupling point — something every caller must know about and supply. Before adding a parameter, ask if it can be eliminated or derived. The same applies to response fields: if a caller doesn't need it, it's noise. Simpler interfaces are easier to compose, and they outlast clever ones: text streams lasted 50 years not because they're powerful but because any program can speak them without coordination.

In practice:
- CLIs: read from stdin, write to stdout; emit structured formats when output will be piped
- Functions: minimize parameters; return consistent, predictable shapes
- APIs: avoid requiring context the server could derive; don't assume client state
- Don't mix concerns: one component does one thing well

## Error handling

Errors are part of the interface. A component that fails silently or with a cryptic message is broken.

**Fail fast and loud.** Detect problems at the earliest possible point and surface them immediately with enough context to act on. Silent failures and swallowed errors are the hardest bugs to diagnose — they let the program continue in a corrupted state and move the failure far from its cause.

- Validate inputs early; reject invalid input at the boundary
- Distinguish caller error (bad input) from system error (unexpected failure) — they warrant different messages and, for CLIs, different exit codes
- Never swallow errors; always surface them with context

## Testability

Design for testability from the start:
- Separate logic from I/O so core behavior can be tested without side effects
- Make side effects explicit (filesystem writes, network calls, process execution)
- A component you can't test is a component you can't safely change

## Policy and mechanism

Separate the *what* from the *how*. Keep policy (behavior choices, configuration, rules) separate from mechanism (the engine that executes them). Policy changes often; mechanism is stable. Hardwiring them together makes policy rigid and mechanism fragile — and makes it hard to test the mechanism independently.

## Representation

Embed knowledge in data rather than in code. When decisions are baked into logic, understanding them requires mentally executing it; when they live in data, you can inspect them directly.

Get the data structures right and the algorithms become self-evident. If an algorithm feels complex, treat it as a signal that the data structures may need rethinking — data structures, not algorithms, are central to programming. A dumb engine that interprets well-structured data is more powerful than a smart one with embedded rules: the engine is stable and testable once; the knowledge is visible, editable, and generatable by other programs.

## Silence

Output only when you have something meaningful to say. A component that produces noise makes its signal harder to read and its output harder to compose with other tools.

## Transparency

Design for inspectability — a component should be able to show that it's working correctly, not just function correctly. Debugging hooks, meaningful state output, and observable internals are features, not afterthoughts.

## Documentation

A component is only as good as its discoverability:
- The entry point (README, `--help`, docstring) should be enough to use it without reading source
- Include at least one concrete usage example
- Document non-obvious behavior, especially around edge cases and failure modes
