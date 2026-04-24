---
name: software-design
description: >
  Apply when the user is designing or building a software component meant to be
  reused, composed, or maintained over time — a library, CLI, service, script, or
  module. Not for one-off throwaway code with no reuse intent.
---

# Software Design

## Quick reference

- **Start from the user** — understand the problem before touching the design
- **Interface first** — design the contract before the implementation; if you can't describe it in one sentence, the scope is too broad
- **Design for externalizability** — design every interface as if external developers will use it
- **Intentional programming** — name functions for their intent; different calling intentions get different names
- **Question every parameter** — each one is coupling; eliminate before adding
- **Do one thing well** — single responsibility makes components composable and replaceable
- **No back-doors** — enforce the interface internally too; no shortcuts
- **Separate policy from mechanism** — what changes often (policy) from what stays stable (mechanism)
- **Embed knowledge in data** — if an algorithm feels complex, the data structures may be wrong
- **DRY < SST + RCL** — eliminate duplicate *knowledge*, not duplicate *text*
- **Fail fast and loud** — surface problems immediately; don't program defensively
- **Test first; test behavior not coverage** — think adversarially; boundary conditions over interior cases
- **Design for inspectability** — observable internals are features, not afterthoughts
- **Silence** — output only when you have something meaningful to say
- **Revisit for simplification** — once it works, look for abstractions that reduce cognitive load

---

## Start from the user

Before any technical decision, put yourself in the user's shoes. Who will use this? What problem are they trying to solve? What does success look like from their perspective? The best interface, the cleanest abstraction, the most composable design — all of it is worthless if it doesn't match how users think about their problem.

Design in a vacuum produces technically elegant components nobody wants to use. User needs are the anchor that keeps every other principle honest.

**Design for change, not for the future.** Requirements will evolve as you learn more about the user. Design with the expectation that you're building the first version, not the last — keep components small, interfaces clean, and tests thorough so refactoring is cheap when understanding improves. But don't speculate: "we might need X later" is imagination; "users consistently need Y" is a fact worth designing for.

## Interface first

Design the interface before the implementation. An interface is a contract — it should be:
- **Minimal**: expose only what callers need
- **Consistent**: follow conventions of the surrounding codebase (naming, signatures, output format)
- **Least Surprise**: behave in ways a user familiar with similar components would expect; avoid gratuitous novelty

If you can't describe the interface in one sentence, the scope is too broad.

**Design for externalizability.** Even if an interface will only ever be used internally, design it as if external developers will use it. This is a forcing function for quality: it prevents hidden assumptions, demands documentation, and stops internal shortcuts from calcifying into coupling. An interface good enough to be public is good enough to be internal — but not the other way around.

## Intentional programming

Code should make the programmer's intention obvious from names and structure alone — without requiring analysis of how it works. When a reader asks "what did the programmer intend by this line?", the name should answer it directly.

When a function can be called with different intentions, give each intention its own name. A single function that can mean "fetch and crash if missing", "search and handle both cases", or "test for presence" forces the reader to infer intent from context. Three functions — `fetch`, `search`, `is_key` — make intention explicit at every call site.

Distinct names also give callers the ability to express precisely what they mean — and crash precisely where something unexpected happens, rather than silently doing the wrong thing.

## Composability

Components should work as building blocks — CLIs, functions, and APIs alike.

**Be ignorant of context.** A component should know nothing about what feeds it or consumes it. The moment it assumes something about its caller, it stops being freely composable.

**Question every parameter.** Each one is a coupling point — something every caller must know about and supply. Before adding a parameter, ask if it can be eliminated or derived. The same applies to response fields: if a caller doesn't need it, it's noise. Simpler interfaces are easier to compose, and they outlast clever ones: text streams lasted 50 years not because they're powerful but because any program can speak them without coordination.

**Do one thing well.** A component that mixes concerns becomes harder to compose, harder to test, and harder to replace. Single responsibility is what makes components interchangeable.

**No back-doors.** Internal shortcuts that bypass the interface — direct data store reads, shared memory, special-cased internal callers — are hidden coupling. They undermine the contract, make the component untestable in isolation, and are expensive to untangle later. If the interface is worth enforcing externally, enforce it internally too. A component designed to be a platform for others must eat its own dogfood first.

In practice:
- CLIs: read from stdin, write to stdout; emit structured formats when output will be piped
- Functions: minimize parameters; return consistent, predictable shapes
- APIs: avoid requiring context the server could derive; don't assume client state

## Policy and mechanism

Separate the *what* from the *how*. Keep policy (behavior choices, configuration, rules) separate from mechanism (the engine that executes them). Policy changes often; mechanism is stable. Hardwiring them together makes policy rigid and mechanism fragile — and makes it hard to test the mechanism independently.

This extends to backing services: treat databases, queues, and caches as attached resources, not local dependencies. The app should be indifferent to whether its database is local or remote, self-hosted or managed. A component that can only work with one specific backing service has fused its mechanism with its environment.

## Representation

Embed knowledge in data rather than in code. When decisions are baked into logic, understanding them requires mentally executing it; when they live in data, you can inspect them directly.

Get the data structures right and the algorithms become self-evident. If an algorithm feels complex, treat it as a signal that the data structures may need rethinking — data structures, not algorithms, are central to programming. A dumb engine that interprets well-structured data is more powerful than a smart one with embedded rules: the engine is stable and testable once; the knowledge is visible, editable, and generatable by other programs.

## Error handling

Errors are part of the interface. A component that fails silently or with a cryptic message is broken.

**Fail fast and loud.** Detect problems at the earliest possible point and surface them immediately with enough context to act on. Silent failures and swallowed errors are the hardest bugs to diagnose — they let the program continue in a corrupted state and move the failure far from its cause.

- Validate inputs early; reject invalid input at the boundary
- Distinguish caller error (bad input) from system error (unexpected failure) — they warrant different messages and, for CLIs, different exit codes
- Never swallow errors; always surface them with context

**Don't program defensively.** Don't add catch-all cases for inputs you haven't designed for. The runtime handles truly unexpected cases. Defensive boilerplate for situations you can't meaningfully handle adds noise, obscures the intentional cases, and makes the reader wonder what the programmer intended — when the answer is: nothing, they just didn't know what to write.

## Testability

A component you can't test independently is a component you can't safely change.

**Test first when possible.** Writing tests before implementation forces a clear definition of correct behavior — it transforms "does this work?" from a vague question into a verifiable one. Tests are the specification; the implementation is what satisfies it. When test-first isn't possible, write tests immediately after — never defer.

**Test behavior, not coverage.** Code coverage tells you tests ran code; it doesn't tell you they verify it. Think adversarially: what small, plausible changes could be made — a boundary flip, a constant substituted, a condition removed — and would your tests catch them? Those gaps are what matter.

**Maximize signal, minimize redundancy.** Each test should verify a distinct behavior. Tests that would catch exactly the same bugs as others add maintenance cost without adding value. Boundary conditions give more signal per test than interior cases — most bugs live at edges.

- Separate logic from I/O so core behavior can be tested without side effects
- Make side effects explicit (filesystem writes, network calls, process execution)

## Transparency

Design for inspectability — a system you can't observe is one that costs hours to debug instead of minutes. A component should be able to show that it's working correctly, not just function correctly. Debugging hooks, meaningful state output, and observable internals are features, not afterthoughts.

## Silence

Output only when you have something meaningful to say. A component that produces noise makes its signal harder to read and its output harder to compose with other tools.

## Documentation

A component is only as good as its discoverability:
- The entry point (README, `--help`, docstring) should be enough to use it without reading source
- Include at least one concrete usage example
- Document non-obvious behavior, especially around edge cases and failure modes

## Abstractions

Once the design is working, revisit it for simplification. Before keeping shared code extracted into an abstraction, ask: is this the same *concept*, or just similar-looking text? DRY targets the wrong thing — the goal is Single Source of Truth: one authoritative place for each piece of *knowledge*. Two things that look the same but represent different concepts should stay separate; coupling them creates dependencies that need to be unpicked when they diverge.

An abstraction earns its place by reducing cognitive load — by giving a clear name to a real concept. If it just reduces line count without adding conceptual clarity, it doesn't pay for itself.

**DRY < SST + RCL**: eliminate duplicate *knowledge*, not duplicate *text*.
