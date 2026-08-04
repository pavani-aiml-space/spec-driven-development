This is a worked example, following the same running scenario used in [integration-spec's template.md](../integration-spec/template.md). Copy it and replace the specifics with your own; the shape and the level of precision are what to keep.

# Runbook: Orders Service → Fulfillment Sync

## Service at a glance
- What it does: consumes the Orders Service's order-created webhook, maps fields, and writes new orders into the Fulfillment API.
- Dependencies: Orders Service (webhook source), Fulfillment API (target), `orders-dlq` queue.
- Healthy looks like: lag < 10 min, DLQ depth = 0. Dashboard: Fulfillment Integrations board.

## Failure modes

### Sync lag alert (lag > 10 min)
- Symptoms: orders visible in Orders Service but not yet in Fulfillment; support tickets about "missing orders."
- Likely cause: consumer backlog (burst above capacity) or a stalled consumer process.
- Diagnostics: check consumer lag metric on the Fulfillment Integrations dashboard; check `orders-dlq` depth; check Orders Ingest handler process health.

### Dead-letter queue depth > 50
- Symptoms: DLQ depth alert fires; a subset of orders never appear in Fulfillment.
- Likely cause: malformed payload, a schema change on the Orders Service side, or a downstream Fulfillment API rejection (validation failure).
- Diagnostics: inspect the oldest 5 messages in `orders-dlq`; check for a recent Orders Service deploy or schema change; check Fulfillment API error logs for the same `correlationId`.

### Circuit breaker open (Fulfillment API unreachable)
- Symptoms: all new orders queuing as "pending sync"; circuit-breaker-open metric alert.
- Likely cause: Fulfillment API outage or a network path issue between the two systems.
- Diagnostics: check Fulfillment API's own health dashboard; check the client timeout/circuit-breaker panel; confirm whether this is within the stated RTO (1 hour).

### Rate limit throttling (429s from Orders Service)
- Symptoms: elevated retry rate, growing consumer lag without a corresponding traffic spike.
- Likely cause: sustained traffic above the confirmed 2 req/sec limit, or the vendor's actual limit is lower than documented (see the integration spec's assumptions log).
- Diagnostics: check 429 rate on the Orders Service API client; compare against the rate-limit assumption in the integration spec.

## Recovery actions
- Lag/backlog: scale consumer instances (horizontal, by partition key). If backlog clears on its own within the 15-minute burst window from the spec, no action needed.
- DLQ buildup: fix the root cause (schema/validation), then replay affected messages from `orders-dlq` using the replay path defined in the spec (RPO: 0, replay from Orders Service).
- Circuit breaker open: no action needed within RTO (1 hour); if exceeded, escalate. Fulfillment continues accepting checkouts via the caller-degradation path ("pending sync"), so this isn't yet customer-blocking.
- Rate limiting: confirm the actual vendor limit with the Orders Service account team; adjust consumer throughput or request a limit increase.
- Rollback: disable the `orders-sync-enabled` feature flag; Fulfillment reverts to manual entry, per the integration spec's rollout plan.

## Escalation
- First responder: Ops Eng on-call.
- Escalate to: Ecommerce on-call (if the cause traces to an Orders Service change), or Security (if a DLQ message reveals a data-contract violation involving PII).
- Bring: `correlationId` of an affected order, current DLQ depth, and a lag metric screenshot.
