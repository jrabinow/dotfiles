# Fail Fast

Do not silently swallow errors or provide default values for missing critical configuration (e.g., environment variables for secrets, required service endpoints).

The application should crash immediately if required configuration is absent — this makes the problem obvious rather than hiding it downstream.

**Graceful degradation is only acceptable for expected, non-critical failures** — e.g., a transient network error to an optional external service.

| Situation | Response |
|---|---|
| Required config missing | Crash loudly with a clear message |
| Expected transient failure | Degrade gracefully, log a warning |
| Unexpected runtime error | Fail fast with full context |
