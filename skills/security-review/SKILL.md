---
name: security-review
description: Use as a dedicated security pass on new or changed code before it ships — separate from general code review — covering injection, auth, secrets, dependency, and configuration risk.
---

# Security Review

## Purpose
A focused audit for security risk, run as its own pass rather than folded into general `review` — security issues need dedicated attention because they're easy to miss when reviewing for correctness and style at the same time.

## When to use
- Before merging code that touches auth, user input, data storage, external calls, or infrastructure/config.
- Before a release, as a gate alongside `release-signoff`.
- When a new dependency or integration is introduced.

## Process
1. **Input handling.** Check every place external input (user, API, file, third-party) enters the system: is it validated, sanitized, and never trusted implicitly? Look for injection risk (SQL, command, template, XSS).
2. **AuthN/AuthZ.** Confirm authentication and authorization are enforced at every boundary that needs it — not just the first entry point. Check for privilege escalation and missing checks on secondary paths.
3. **Secrets and data.** Confirm no credentials, keys, or tokens are hardcoded or logged. Check that sensitive data is encrypted appropriately in transit and at rest, and that access to it is scoped to what's needed.
4. **Dependencies and config.** Check new/updated dependencies for known vulnerabilities. Review config/infrastructure changes for overly broad permissions, exposed ports/endpoints, or insecure defaults.
5. **Failure behavior.** Confirm errors don't leak sensitive detail (stack traces, internal paths, data) to untrusted callers, and that failures fail closed, not open.
6. **Rank by exploitability**, not theoretical severity alone — prioritize what's actually reachable by an attacker.

## Output
A findings list of security issues ranked by exploitability/impact, each with the concrete attack scenario it enables.

## Handoff
Blocking findings loop back to `build`/`debug` before `release`. Non-blocking findings can be logged for a future `plan` cycle rather than silently dropped.

## Checklist
- [ ] All external input entry points were checked for injection/validation risk
- [ ] AuthZ is verified at every boundary, not just the primary entry point
- [ ] No secrets are hardcoded, logged, or exposed in error output
- [ ] New/changed dependencies and config were checked for known risk
- [ ] Findings are ranked by real-world exploitability, not just theoretical severity
