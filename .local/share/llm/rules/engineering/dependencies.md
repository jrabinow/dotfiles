# Dependency Version Verification

Never guess or assume package versions. Always query the registry before writing version strings.

- Check actual available versions before editing any lockfile or manifest
- Verify peer dependency compatibility before upgrading
- Use `yarn info <pkg> versions --json | jq '.[-5:]'` or equivalent to get recent versions
- Prefer `yarn` over `npm` for Node package management

**Why:** Guessed versions are often wrong, stale, or incompatible. The registry is authoritative; memory is not.
