# Worked example: Prescription Alternatives Program

One illustrative stakeholder map, not a template to copy verbatim - the point is what real objectives and power/interest reasoning look like once discovery (steps 3-5) is actually done, not left as placeholders.

Program: helping patients and providers identify lower-cost, clinically-equivalent alternative medications within a pharmacy platform.

| Stakeholder/Role | Category | Objective (what they actually said) | Power | Interest | Priority Group | Engagement Approach |
|---|---|---|---|---|---|---|
| VP Product (Sponsor) | Sponsor/Decision-maker | Reduce patient out-of-pocket drug costs while hitting adoption targets | High | High | Manage Closely | Involve directly in every key decision; weekly steering updates |
| Clinical/Pharmacy Lead | Domain/clinical expert | Any suggested alternative is therapeutically equivalent and clinically safe; zero patient-safety incidents | High | High | Manage Closely | Sign-off required before launch; involved in every clinical-safety decision |
| Compliance/Regulatory | Legal/Compliance | Substitution suggestions comply with FDA and state pharmacy-practice rules; tool doesn't constitute unlicensed medical advice | High | High | Manage Closely | Joint sign-off gate before launch; involved in every decision touching substitution logic |
| Engineering Lead | Dependent team | Reliable integration with existing formulary/pricing APIs; realistic delivery timeline | High | High | Manage Closely | Involved in every technical-delivery decision |
| Data/Formulary Team | Dependent team | Alternative-suggestion accuracy depends on their pricing/formulary feed staying current; want a clear data contract | Medium-High | High | Manage Closely | Regular sync on data-feed SLAs and change notice |
| Prescribing Physicians/Providers | Influencer (external) | Tool must not undermine prescribing authority or create liability confusion; alternatives framed as suggestions, not directives | Medium | High | Keep Satisfied | Direct outreach/education before launch; involved in UX review of how suggestions are framed |
| Patients/End Users | Customer | Lower drug costs without extra hassle or confusing choices | Low (individually) | High | Keep Informed | In-app education, clear opt-in messaging, release notes |
| Support/CS Team | Operational owner | Manageable ticket volume, clear runbook for "why did my prescription suggestion change" cases | Low | High | Keep Informed | Runbook and training delivered before launch |
| Marketing/Comms | Influencer | Positive framing; avoid a "insurer forcing cheaper drugs" backlash narrative | Low-Medium | Medium | Keep Satisfied | Review messaging before any external communication |
| Adjacent product teams | Monitor | No unexpected impact on their own roadmap or systems | Low | Low | Monitor | Checked occasionally via existing cross-team sync |

**Priority group reference**: Manage Closely (high power, high interest) - Keep Satisfied (high power, low interest) - Keep Informed (low power, high interest) - Monitor (low power, low interest).

Two rows worth noting:

- **Compliance/Regulatory sits in Manage Closely, not Keep Satisfied** - the default assumption for a legal/compliance function is lower engagement, but this program's regulatory surface (FDA, pharmacy-practice law) pushes their interest to High, matching the escalation logic already in `tpm-raci`'s Legal/Compliance guidance.
- **Prescribing Physicians have only Medium power** (they can't block the program outright) **but High interest** (it directly affects their practice and liability) - Keep Satisfied, not Manage Closely, but still a real engagement plan, not an afterthought. This is the row a rushed map would most likely under-invest in, since providers aren't an internal team with a formal seat at planning meetings.
