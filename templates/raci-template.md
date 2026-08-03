*Browsing copy for showcase purposes. Canonical source (edit here, not this copy): [roles/tpm/tpm-raci/examples/compliance-initiative-example.md](../roles/tpm/tpm-raci/examples/compliance-initiative-example.md), part of the [tpm-raci](../roles/tpm/tpm-raci/SKILL.md) skill.*

# Worked example: an initiative with real compliance surface

One illustrative RACI, not a template to copy verbatim - the point is what changes when an initiative touches consent, privacy, or regulatory surface, per Process step 4.

Program: a feature letting one user (a caregiver) get delegated access to another user's account or data.

| Deliverable/Decision | Responsible | Accountable (DRI) | Consulted | Informed |
|---|---|---|---|---|
| Business case & budget approval (is this funded, at what scope) | Finance | **Sponsor** | Product, Finance | Engineering, Design, Legal, Compliance, Support/CS |
| Access scope & consent model (what a delegate can see/do, how it's granted/revoked) | Product Manager | Product Manager | Legal, Compliance, Design, Engineering | Support/CS |
| Privacy/regulatory sign-off (consent validity, data-sharing law, authorization requirements) | Compliance Lead | **Compliance Lead** (joint-Approver with Legal) | Product, Engineering, Security | Sponsor |
| Access-control & delegation architecture | Engineering Lead | Engineering Lead | Security, Product | Support/CS |
| Invite/accept UX flow | Design Lead | Product Manager | Design, Engineering, Legal (consent language) | Support/CS |
| Security review of delegated-access model | Security Engineer | Security Lead | Engineering, Compliance | Product, Sponsor |
| Support runbook for access disputes/revocation | Support Lead | Support Lead | Product, Legal | Engineering |
| Launch/rollout decision (staged vs. full) | Product Manager | Product Manager | Engineering, Support | Legal, Compliance, Sponsor |
| Post-launch misuse monitoring & incident response | Security Engineer | Security Lead | Support, Legal, Compliance | Sponsor |

**Sponsor** (e.g., VP Product): named separately, outside the delivery cells above, with one exception - Accountable for the business case/budget row itself, since that's a funding gate, not a delivery task. Otherwise, resolves resourcing conflicts between the Product/Engineering/Security Accountable owners and is the escalation point if Legal/Compliance sign-off stalls the timeline.

The row that matters most here: privacy/regulatory sign-off has **Compliance as Accountable, not Consulted** - because a delegate gaining access to someone else's data is exactly the kind of decision where "gives input" undersells what Compliance needs (authority to block launch until requirements are met), not just a seat at the table.
