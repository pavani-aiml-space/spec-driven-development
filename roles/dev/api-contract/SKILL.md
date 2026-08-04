---
name: api-contract
description: Use before implementing a REST API (internal or external) to define its resources, endpoints, HTTP methods, auth, status codes, error shape, pagination, and versioning so producer and consumers agree before code is written.
---

# API Contract (REST)

## Purpose
Define what a REST API promises to callers *before* it's built, so producer and consumer teams (or components) can work in parallel against an agreed interface instead of discovering mismatches at integration time.

## When to use
- A new REST API/endpoint is being added between components or exposed externally.
- An existing API's interface needs to change and consumers need to know what's changing.

## Process
1. **Model resources, not actions.** URLs are nouns: plural collections (`/orders`), individual resources by ID (`/orders/{orderId}`), and real hierarchy where one resource belongs to another (`/orders/{orderId}/items`). Prefer the standard operations, list, get, create, update, delete, over inventing a bespoke one when a standard one fits. For a genuine non-CRUD action that doesn't map to one of those (e.g. "cancel," "refund"), use a clearly marked action on the resource (`POST /orders/{orderId}:cancel`) rather than smuggling a verb into the path (`/cancelOrder`).
2. **Assign the HTTP method by its actual semantics**, and implement its idempotency/safety contract for real, not just by convention:

   | Method | Meaning | Safe | Idempotent | Typical success code |
   |---|---|---|---|---|
   | GET | Retrieve | Yes | Yes | 200 |
   | POST (create) | Create, server assigns ID | No | No, unless an idempotency key is used | 201 |
   | POST (action) | Non-CRUD action | No | Should be made idempotent (see step 7) | 200 |
   | PUT | Full replace (create-or-replace) | No | Yes | 200 (replaced) / 201 (created) |
   | PATCH | Partial update | No | Yes, if using merge semantics | 200 |
   | DELETE | Remove | No | Yes (repeat calls still end in "gone") | 204 |

   A client must be able to safely retry any idempotent call without side effects beyond the first success. If an operation can't honestly meet its method's idempotency contract, that's a signal it's modeled wrong, not a detail to gloss over.
3. **Define authentication and authorization for every operation**, not just the API as a whole. State the scheme (OAuth2/OIDC bearer token, API key, mTLS, or explicitly "none"), where the credential goes (almost always the `Authorization` header), the required scope or permission per operation, and the distinction between missing/invalid/expired credentials (401) and a valid credential with insufficient permission (403). An endpoint with no stated auth requirement is an endpoint someone will assume is open; say so explicitly either way.
4. **Specify each endpoint completely.** Path, method, path/query parameters (name, type, required or optional, constraints), request body schema, response schema for every status code it can return, and what each of those status codes actually means for that endpoint. A caller should never have to guess what a 409 means here versus on another endpoint.
5. **Define one consistent error shape for the whole API.** Every error response uses the same structure (for example, a `type`/`title`/`status`/`detail` problem-details shape, extended with a machine-readable error code for cases callers need to branch on), not a different ad hoc JSON shape per endpoint. Document the fixed set of error codes as part of the contract, the same way successful responses are documented.
6. **Handle collections consistently.** Decide pagination once for the whole API (cursor-based is generally more stable under concurrent writes than offset-based, since inserts/deletes between page requests don't shift results), a stated default and maximum page size, and consistent filtering/sorting query parameters, so no individual endpoint invents its own pattern.
7. **Decide idempotency and versioning strategy up front, not per-endpoint.** For POST operations that create or trigger side effects, support an idempotency-key request header so a retried request with the same key returns the original result instead of double-creating or double-charging. Pick one versioning mechanism (URL segment, header, or query parameter) and state explicitly what counts as a breaking change (removing/renaming a field, changing a type, tightening validation) versus non-breaking (adding an optional field), so it isn't relitigated at every change.
8. **State rate-limiting behavior**, if the API is rate-limited: the response for an exceeded limit (429), and what headers tell the caller when they can retry.
9. **Validate against real consumers.** Check the contract against how it will actually be called. A contract nobody can use cleanly is wrong even if it's internally consistent.
10. **Treat the contract as the source of truth.** Implementation should conform to the contract; if implementation needs to diverge, update the contract deliberately and notify consumers rather than letting it drift silently.

## Output
A REST API contract, ideally as a machine-readable spec (e.g. OpenAPI) so it can generate docs, mock servers, and client/test scaffolding rather than existing only as prose: resources and their URLs, every endpoint's method/parameters/request/response schemas, auth requirements per operation, the shared error shape and its documented codes, pagination/filtering conventions, idempotency and versioning policy, and rate-limit behavior if applicable.

## Handoff
Feeds `build` (implementation must satisfy the contract) and `test` (contract becomes the basis for test cases, including one per documented status/error code, not just the happy path). Changes to the contract after publication go through `decision-log` if they're breaking, and a decision to standardize the error shape or versioning mechanism across APIs is often significant enough to warrant an `adr`.

## Checklist
- [ ] URLs are resource-oriented (nouns, plural collections, real hierarchy), not verbs in disguise
- [ ] Every operation's HTTP method matches its actual semantics, and idempotent methods are actually idempotent in implementation, not just by convention
- [ ] Auth (scheme, credential location, required scope/permission) is stated explicitly for every operation, including ones with no auth
- [ ] Every endpoint has a complete path, parameters, request schema, and a response schema for every status code it returns
- [ ] All error responses use one consistent shape, with a documented, fixed set of error codes
- [ ] Pagination, filtering, and sorting conventions are defined once and applied consistently across endpoints
- [ ] Idempotency strategy for unsafe operations and a versioning/breaking-change policy are both decided up front
- [ ] Rate-limit behavior and headers are documented, if the API is rate-limited
- [ ] Contract was validated against how real consumers will actually call it
