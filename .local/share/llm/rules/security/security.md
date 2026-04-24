# Security

## Credentials and secrets

Never commit credentials, API keys, tokens, or sensitive data to version control.

**One-time shell or scripts meant to run locally:** environment variables are acceptable for secrets.

**Production services and development:** use a dedicated secrets management solution — AWS Secrets Manager, HashiCorp Vault, GCP Secret Manager, or equivalent. Environment variables are not an adequate secrets store for production: they leak through process listings, logs, crash dumps, and child processes.

## Elevated permissions

Never use `sudo` without explicit confirmation. When elevated permissions are needed, state why before acting.
