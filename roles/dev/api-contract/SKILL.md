---
name: api-contract
description: Use before implementing an API (internal or external) to define and document its interface — requests, responses, errors, and versioning — so producer and consumers agree before code is written.
---

# API Contract

## Purpose
Define what an API promises to callers *before* it's built, so producer and consumer teams (or components) can work in parallel against an agreed interface instead of discovering mismatches at integration time.

## When to use
- A new API/endpoint/interface is being added between components or exposed externally.
- An existing API's interface needs to change and consumers need to know what's changing.

## Process
1. **Define the operations.** For each operation: purpose, request shape, response shape, and status/error codes with meaning.
2. **Specify data types and constraints precisely.** Required vs. optional fields, types, formats, valid ranges — ambiguity here becomes a runtime bug later.
3. **Define error behavior.** What errors are possible, their shape, and what a caller should do in response — not just the happy path.
4. **Decide versioning strategy up front.** How breaking vs. non-breaking changes will be handled and communicated, before the first breaking change forces an ad-hoc decision.
5. **Validate against real consumers.** Check the contract against how it will actually be called — a contract nobody can actually use cleanly is wrong even if internally consistent.
6. **Treat the contract as the source of truth.** Implementation should conform to the contract; if implementation needs to diverge, update the contract deliberately and notify consumers rather than letting it drift silently.

## Output
An API contract: operations, request/response schemas, error codes and meanings, versioning policy.

## Handoff
Feeds `build` (implementation must satisfy the contract) and `test` (contract becomes the basis for test cases). Changes to the contract after publication go through `decision-log` if they're breaking.

## Checklist
- [ ] Every operation has a defined request, response, and error shape
- [ ] Required vs. optional fields and constraints are explicit
- [ ] Error responses are specified, not just success cases
- [ ] Versioning/breaking-change policy is decided before the first breaking change is needed
- [ ] Contract was validated against how real consumers will actually call it
