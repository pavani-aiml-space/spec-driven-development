This is a worked example, following the same running scenario used in [SKILL.md](SKILL.md). Copy it and replace the specifics with your own; the shape and the level of precision are what to keep.

# Integration Spec: Orders Service → Fulfillment Service

**Date:** 2026-08-03
**Target launch:** 2026-09-15 (tied to the Q3 fulfillment-speed goal below)
**Status:** Proposed
**Integration Owner:** Ops Eng lead

## Business context
- Why this exists: sync new orders into fulfillment so warehouse staff don't re-key them, a commitment tied to the Q3 fulfillment-speed goal.

## Success metrics
- Manual order re-key rate drops to 0%.
- 99% of orders visible in fulfillment within 5 minutes of creation.

## Ownership
- System of record: order and line items → Orders Service; shipping status (once created) → Fulfillment Service.
- Source: Orders Service (Ecommerce team).
- Target: Fulfillment API (Ops Eng team).

| Reviewer | Role | Concern raised |
|---|---|---|
| Ecommerce tech lead | Source system owner | none |
| Ops Eng tech lead | Target system owner | Wants the retry window shortened |
| Security | Compliance sign-off | Approved; `contactEmail` (PII) confirmed low-risk at this classification |

## Dependencies
- Depends on: Orders Service's order-created webhook (currently in beta, GA date 2026-08-20, before target launch).
- Blocks: the Q3 fulfillment-speed OKR launch.
- Related integrations: none.

## Shape of the connection
Styles considered:
- File transfer (nightly export/import): rejected, too slow for the 5-minute freshness target in Success metrics.
- Shared database (Fulfillment reads Orders' DB directly): rejected, couples the two teams' schemas and violates Orders Service's data-ownership boundary from Ownership above.
- Direct API call (Fulfillment polls Orders on an interval): rejected, wastes capacity polling for infrequent changes and adds latency versus reacting to an event.
- Async messaging/webhook (chosen): Orders Service already emits an order-created webhook; matches the per-event cadence needed and keeps the two systems decoupled.

- Cadence: per-event, triggered by the webhook.
- Flow: Orders Service → Order Ingest handler (validates, maps fields) → Fulfillment API.

## Data contract
| Source field | Target field | Type | Transform | Required | Classification |
|---|---|---|---|---|---|
| `order.id` | `externalOrderId` | string | none | yes | Internal |
| `order.line_items[]` | `items[]` | array | flatten to SKU + qty | yes | Internal |
| `order.customer.email` | `contactEmail` | string | lowercase | no | PII |

- Quality rules: new optional fields can be added without notice.
- Schema-change policy: breaking changes get a new schema version and a 90-day deprecation window for the old one.

## Scalability
- Constraints: Orders Service API: 2 req/sec sustained, 10 req/sec burst (per vendor docs, unconfirmed for our account tier).
- Capacity headroom: consumer scales horizontally by partition key (region); a burst above 5x average queues for up to 15 minutes before the freshness SLA is considered breached.
- Cost: ~$0.0004/order at the vendor's current tier; the next pricing tier kicks in above 500k orders/month.

## Reliability
- Delivery: at-least-once.
- Dedup key: `order.id`.
- Ordering: not required, each order is processed independently.
- Fast-ack (webhook): return 200 within 2s, payload queued and processed async after.
- Retries: exponential backoff, 5 attempts over 24h, then dead-letter.
- Timeout / circuit breaker / bulkhead: 3s client timeout; circuit opens after 5 consecutive failures, half-open retry after 30s; dedicated connection pool, capped at 20, so this integration can't starve other outbound calls.
- Failure handling: failed events go to `orders-dlq`; pages #fulfillment-oncall if depth > 50.
- Extended outage: RTO 1 hour, RPO 0 (replay from Orders Service).
- Caller degradation: while down, new orders queue in fulfillment as "pending sync" rather than blocking checkout.
- SLA: freshness, order visible within 5 min of the webhook, 99.9% of the time; throughput, up to 200 orders/min at peak; availability, 99.95% monthly.

## Security
- Connectivity: public internet.
- Auth: HMAC-SHA256 signature on `X-Signature`, verified against the raw body; the service account can only write to the `orders` table, nothing else.
- Encryption: TLS 1.2+ required in transit; queued payloads encrypted at rest.
- Secrets: stored in a managed vault, rotated every 90 days.
- Data residency: EU customer records stay in the EU region end to end.

## Observability
- Health signal: alert if lag > 10 min or DLQ depth > 0.
- Owner: Ops Eng on-call.
- Traceability: every event carries a `correlationId` logged on both sides.
- Dashboard: Fulfillment Integrations board.
- Runbook: [link to the operational runbook for this integration].

## Rollout plan
- Feature-flagged behind `orders-sync-enabled`, default off.
- Phase 1: single-region dark launch (US-East), syncing but not yet blocking checkout, 1 week.
- Phase 2: enable the checkout dependency for US-East, monitor SLA for 1 week.
- Phase 3: roll out region by region; full rollout by target launch date.
- Rollback: disable the feature flag; Fulfillment falls back to the current manual-entry process.

## Assumptions, risks, and scope
| Assumption | Value | Source | Impact if wrong |
|---|---|---|---|
| Orders Service rate limit | 2 req/sec sustained | Vendor public docs, unconfirmed | Consumer throttles below stated throughput; freshness SLA at risk |

- Out of scope: refund sync (separate integration).
- Triggers to reconsider this spec: monthly order volume exceeds 500k; the vendor changes its rate limit or pricing tier; EU data-residency requirements change.

## Validation
- [ ] Confirmed against both real systems, not just this document.
- [ ] Failure modes deliberately triggered (dependency down, forced timeout) and confirmed to behave as specified.
