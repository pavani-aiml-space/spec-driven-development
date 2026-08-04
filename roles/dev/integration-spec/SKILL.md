---
name: integration-spec
description: Use, as the Principal Technical PM driving a cross-team integration (a data pipeline, a shared database, or an API/webhook connection), to force concrete engineering answers on scope, dependencies, scalability, reliability, extensibility, security, observability, and rollout before a launch commitment is made, not accept "engineering will figure it out."
---

# Integration Spec

## Purpose
This is the artifact a Principal Technical PM uses to drive the technical conversation on a cross-team integration, not a document engineering fills in alone after a commitment has already been made. The job isn't to write every answer yourself; it's to know precisely which questions have to have a concrete answer before this ships, and to keep pressing until "we'll figure it out" becomes a number, a named policy, or a named owner. Loose "system A talks to system B" language is where integration failures actually come from, and it survives exactly as long as nobody in the room is equipped to ask what happens under load, on a retry, during an outage, or during rollout.

## When to use
- You're the PM accountable for an integration that crosses team boundaries, two engineering teams, or a third-party/vendor system, and a launch or roadmap commitment is being made against it.
- Engineering is describing a data pipeline, shared database, or API/webhook connection in terms too vague to hold anyone to. Each side's own endpoint shape is `api-contract`'s job; this is the cross-team link between them, and the commitment around it.
- An existing integration is failing in production and nobody, including you, can point to what was actually agreed.
- The integration crosses a scale, compliance, or reliability boundary a small internal tool doesn't: high volume, multiple regions/countries, or a dependency the business is treating as critical.

## Process
The same running example illustrates every step: syncing new orders from an Orders Service into an internal Fulfillment Service.

### Scope and ownership
1. **Why does this exist, in terms the business actually funded?** One sentence tying it to the outcome leadership is expecting, and the target launch date that commitment implies.
   > *e.g. "Sync new orders into fulfillment so warehouse staff don't re-key them, a commitment tied to the Q3 fulfillment-speed goal." Target launch: 2026-09-15.*
2. **Define the success metrics before anything else gets built.** How will you know this worked, in numbers, not "it should feel faster." Tie each metric back to the business need in step 1.
   > *e.g. Manual order re-key rate drops to 0%. 99% of orders visible in fulfillment within 5 minutes of creation.*
3. **Press each engineering team to name the system of record for every piece of data.** For every entity both systems could hold, get one authoritative answer; "both can write it" is not an answer, and it's the question most likely to get skipped without you asking it.
   > *e.g. Orders Service owns the order and its line items. Fulfillment owns shipping status once created.*
4. **Name source, target, their owning teams, and one accountable owner for the integration itself, and get sign-off.** Each side has a team; the integration as a whole still needs a single named owner, not "whoever built it," and both tech leads should be named reviewers on this document, not passive recipients of it. If any field will carry sensitive data, add security as a reviewer here too, not as a rubber stamp after the fact. The spec's own `Status` (Proposed → Active) carries approval state, so this step just needs who reviewed it and any concern they raised, not a second competing approval flag.

   | Reviewer | Role | Concern raised |
   |---|---|---|
   | [Ecommerce tech lead] | Source system owner | none |
   | [Ops Eng tech lead] | Target system owner | Wants the retry window shortened |
   | [Security] | Compliance sign-off | Approved; PII field confirmed low-risk at this classification |

   A spec doesn't move to `Status: Active` until every listed concern is resolved or explicitly accepted, not just heard.
5. **Map what this depends on, and what depends on it.** An integration rarely stands alone: name any upstream capability it needs that isn't built yet (with its own target date), and anything downstream, a launch, an OKR, another team's roadmap, that's blocked on this one. This is where a dependency gets caught before it becomes a surprised stakeholder two weeks before launch.
   > *e.g. Depends on: the Orders Service's order-created webhook, currently in beta, GA date 2026-08-20. Blocks: the Q3 fulfillment-speed OKR launch.*

### Shape of the connection
6. **Get engineering to compare all four integration styles, not just name the one they'd default to.** File transfer, shared database, direct API call, and async messaging/webhook each carry different coupling and failure modes; make them say why the other three were rejected, not only why the chosen one was picked. A single named option with no comparison is a decision that was never actually examined.
   > *e.g. File transfer: rejected, too slow for the 5-minute freshness target. Shared database: rejected, couples schemas and violates the ownership boundary from step 3. Direct API polling: rejected, wastes capacity and adds latency versus reacting to an event. Async webhook (chosen): matches the per-event cadence and keeps the systems decoupled.*
7. **Get the cadence stated explicitly.** Scheduled, near-real-time, or per-event determines almost everything downstream, so it can't stay implicit.
   > *e.g. Per-event, triggered by the webhook.*
8. **Have engineering draw the data flow**, one line per hop, and read it back to confirm no intermediate system is hiding inside a "processing" box.
   > *e.g. Orders Service → Order Ingest handler (validates, maps fields) → Fulfillment API.*

### Data contract and extensibility
9. **Require a field-mapping table, not a schema summary, with a classification column.** This catches sensitive data here, before build, not after `security-review` finds it downstream:

   | Source field | Target field | Type | Transform | Required | Classification |
   |---|---|---|---|---|---|
   | `order.id` | `externalOrderId` | string | none | yes | Internal |
   | `order.line_items[]` | `items[]` | array | flatten to SKU + qty | yes | Internal |
   | `order.customer.email` | `contactEmail` | string | lowercase | no | PII |
10. **Press for quality rules and a real change policy, not "we'll version it later."** Constraints on the data itself (ranges, uniqueness), and what counts as a breaking change versus something either side can ship without coordinating with the other.
    > *e.g. New optional fields can be added without notice. Breaking changes get a new schema version and a 90-day deprecation window for the old one.*

### Scalability
11. **Get each system's real constraints in writing.** Flag anything sourced from public vendor docs as unconfirmed until an engineer has verified it against the actual account.
    > *e.g. Orders Service API: 2 req/sec sustained, 10 req/sec burst (per vendor docs, unconfirmed for our account tier).*
12. **Push past the average-case number.** Ask what happens at 5x, 10x load: does it scale, and what's the behavior once it can't scale further, backpressure, throttling, or shedding? "We haven't tested that" is a real answer, and it belongs in the risk log, not silence.
    > *e.g. Consumer scales horizontally by partition key (region); a burst above 5x average queues for up to 15 minutes before the freshness SLA is considered breached.*
13. **Ask what this costs at the numbers above**, and whether cost scales linearly or hits a pricing-tier cliff worth flagging to finance or leadership before it's hit in production, not after.
    > *e.g. ~$0.0004/order at the vendor's current tier; the next pricing tier kicks in above 500k orders/month.*

### Reliability
14. **Confirm the delivery guarantee, dedup key, and whether order matters.** Most transports are at-least-once; make sure engineering names a dedup key rather than assuming "exactly once." Ask directly whether order matters for this data, don't let it go unasked.
    > *e.g. At-least-once; dedup on `order.id`. Ordering isn't required, each order is processed independently.*
15. **For an inbound webhook, confirm the fast-ack pattern is understood**: acknowledge immediately, process after, since a slow handler reads as a failed delivery to most senders.
    > *e.g. Return 200 within 2s; queue the payload for async processing.*
16. **Get a concrete retry policy, not "it retries."** Backoff, jitter, max attempts, max window.
    > *e.g. Exponential backoff, 5 attempts over 24h, then dead-letter.*
17. **Ask what protects the rest of the system if this dependency is slow or down.** A timeout budget, a circuit breaker that stops hammering a failing dependency instead of retrying into a wall, and isolation (a dedicated pool) so this integration can't starve unrelated work. If engineering hasn't considered this, that's a finding, surface it now, not in the postmortem.
    > *e.g. 3s client timeout; circuit opens after 5 consecutive failures, half-open retry after 30s; dedicated connection pool, capped at 20, so this integration can't starve other outbound calls.*
18. **Get explicit answers on extended outages, on both sides.** How fast must this recover (RTO), how much data loss is acceptable (RPO), is there a replay path, and separately, what does the calling system do while it's down, fail the request, serve stale data, or queue? These are two different questions; make sure both get answered.
    > *e.g. Failed events go to `orders-dlq`; pages #fulfillment-oncall if depth > 50. RTO: 1 hour. RPO: 0 (replay from Orders Service). While down, new orders queue in fulfillment as "pending sync" rather than blocking checkout.*
19. **Turn the SLA into numbers you can hold someone to.** Freshness, throughput (average and peak), availability. "As fast as possible" doesn't survive a postmortem, and it shouldn't survive this review either.
    > *e.g. Order visible in fulfillment within 5 min of the webhook, 99.9% of the time; up to 200 orders/min at peak; 99.95% monthly availability.*

### Security
20. **Confirm connectivity, auth, and that the credential is scoped to least privilege.** Not a shared account with more access than this integration uses. Loop `security-review` in here, not at the end.
    > *e.g. Public internet; HMAC-SHA256 signature on `X-Signature` verified against the raw body; the service account can only write to the `orders` table, nothing else.*
21. **Confirm encryption, secrets handling, and data residency**, especially if either system spans regions or countries; a global company's compliance obligations are a launch blocker here, not a footnote to raise after the fact.
    > *e.g. TLS 1.2+ required; queued payloads encrypted at rest; secrets in a managed vault, rotated every 90 days; EU customer records stay in the EU region end to end.*

### Observability
22. **Confirm a health signal exists with a named owner**, before this ships, not after the first incident makes it obvious one was missing.
    > *e.g. Alert if lag > 10 min or DLQ depth > 0; owner: Ops Eng on-call.*
23. **Confirm cross-system traceability exists, and link the runbook.** A correlation ID present in both systems' logs, so "why did this order get stuck" is one query instead of a multi-team investigation, plus where the on-call runbook for this integration actually lives.
    > *e.g. Every event carries a `correlationId` logged on both sides; dashboard: Fulfillment Integrations board; runbook: linked from the dashboard.*

### Rollout
24. **Get a concrete rollout and rollback plan, not "we'll turn it on."** How this actually goes live safely: feature-flagged or not, a phased rollout (by region, tenant, or traffic percentage) versus a single cutover, and what rolling back looks like if it doesn't go well, not just what happens when it's already broken (that's step 18). This is what `release` executes against; it needs to exist here first, at the commitment stage, not get improvised the week of launch.
    > *e.g. Feature-flagged behind `orders-sync-enabled`. Phase 1: dark launch in US-East (synced but not blocking checkout), 1 week. Phase 2: enable the checkout dependency for US-East, monitor for 1 week. Phase 3: roll out region by region. Rollback: disable the flag; Fulfillment reverts to the current manual-entry process.*

### Scope discipline and validation
25. **Log every assumption, and chase an answer for each before calling this final.** A one-line bullet loses the "so what if it's wrong"; a table doesn't. An unconfirmed number that quietly ships as a requirement is how commitments to the business get broken later.

    | Assumption | Value | Source | Impact if wrong |
    |---|---|---|---|
    | Orders Service rate limit | 2 req/sec sustained | Vendor public docs, unconfirmed | Consumer throttles below stated throughput; freshness SLA at risk |

    State what's explicitly out of scope alongside it.
    > *e.g. Out of scope: refund sync (separate integration).*
26. **State what would trigger revisiting this spec entirely**, not just individual open questions getting answered: a vendor pricing or rate-limit change, an assumption above turning out false, volume crossing an order of magnitude past what was scoped, or a new data-residency requirement.
    > *e.g. Revisit if: monthly order volume exceeds 500k, the vendor changes its rate limit or pricing tier, or EU data-residency requirements change.*
27. **Don't accept "it should work" as validation.** Confirm engineering tested this against both real systems and deliberately triggered the failure modes above, not just the happy path, before you represent this as ready to the business.

For leadership or non-engineering stakeholders, steps 1, 2, and 25 alone can stand as a short front summary, the same "different audience, same source of truth" split `release-notes` uses for its technical and plain-language versions.

## Output
A completed integration spec, one section per part of the Process above, `Status` carrying real approval state rather than a separate sign-off flag. See [template.md](template.md) for a fully worked example using the same Orders Service → Fulfillment Service scenario as this Process, copy its shape rather than starting blank.

## Handoff
- Feeds `build`, implementation must satisfy the contract you drove engineering to commit to.
- Feeds `test`, delivery guarantees, failure handling, scalability under load, and SLAs each need their own test cases, not just the happy path, including the deliberate failure-mode tests from step 27.
- Feeds `release`, which executes the rollout/rollback plan from step 24; it shouldn't be improvised at deploy time.
- Feeds `runbook` for the operational side: what an on-call engineer does when the dead-letter queue fills up, a freshness alert fires, or RTO/RPO commitments are being tested for real.
- Feeds `security-review` before this ships, not after, for any field classified above Internal and any cross-border data-residency question.
- You stay accountable for the open questions after handoff: they get resolved the same way `concept` treats them, surfaced and answered, not silently assumed away by whoever happens to be building at the time.
- A decision to standardize a delivery-semantics, schema-versioning, or integration-style policy across integrations is often significant enough to warrant an `adr`.

## Checklist
- [ ] Business justification and target launch date stated, tied to what leadership is actually expecting
- [ ] Success metrics/KPIs defined in numbers, not qualitative language
- [ ] System of record named per entity, not just per system
- [ ] Source, target, owning teams, and one accountable integration owner named explicitly, with both tech leads (and security, if sensitive data is involved) listed as reviewers and any concern they raised recorded
- [ ] `Status` reflects real approval state (not moved to Active until listed concerns are resolved or explicitly accepted)
- [ ] Dependencies (what this needs, and what's blocked on it) are named explicitly, not discovered later
- [ ] All four integration styles were compared, with a stated reason the other three were rejected, not just the chosen one named
- [ ] Cadence chosen explicitly, not implied
- [ ] Data flow diagrammed hop by hop, no hidden intermediate systems
- [ ] Field-level mapping table exists, with a classification per field, not just a schema summary
- [ ] Any field classified as sensitive (PII/Restricted/etc.) is flagged for `security-review`
- [ ] Quality constraints and a schema-change/versioning policy are both stated
- [ ] Each system's real constraints stated, vendor-doc values labeled as assumptions until confirmed
- [ ] Scalability behavior under peak load is defined: how it scales, and what happens when it's exceeded, not an unbounded queue
- [ ] Cost at expected and peak throughput is stated, including any pricing-tier cliff
- [ ] Delivery guarantee, dedup strategy, and ordering requirement are all defined; inbound webhooks specify the fast-ack pattern
- [ ] Retry policy (backoff, jitter, max attempts, max window) is defined
- [ ] Timeout, circuit-breaker, and bulkhead/isolation settings are defined for the calling side
- [ ] Extended-outage recovery (RTO/RPO) and caller degradation behavior are both stated for business-critical integrations
- [ ] SLAs (freshness, throughput, availability) are numeric, not qualitative
- [ ] Connectivity and auth for the link itself are specified, and the credential is scoped to least privilege
- [ ] Encryption in transit/at rest, secret management, and data-residency constraints are all stated
- [ ] Observability includes a health signal, a cross-system correlation/trace ID, a named owner, and a linked runbook
- [ ] A rollout plan (phased or flagged) and a rollback plan both exist before launch, not improvised at deploy time
- [ ] Assumptions are logged as a table (value, source, impact if wrong), each chased to an actual answer, not left recorded and unresolved
- [ ] Triggers to reconsider the spec entirely are stated, not just individual open questions
- [ ] Spec validated against both systems' real behavior, and the failure modes were actually triggered, not just documented
