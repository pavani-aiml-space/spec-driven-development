# Risk Register - quick guide

## What it's for
Turns "things that could go wrong" into a tracked, owned, scored list, so risks get mitigated proactively instead of becoming surprises.

## How to trigger it
- Plain English: "what could go wrong with the Caregiver Access program" or "create a risk register for X"
- Name it directly: "use tpm-risk-register to track risks for X"
- Slash command: `/tpm-risk-register`
- Also worth re-running whenever a new risk surfaces, or a paused program restarts

## What you'll be asked for
- The program (or project) name (required)
- Real risks once the starter draft is generated: what could happen, likelihood (1-5), impact (1-5), mitigation, trigger, contingency, and a named owner for each

## What happens, step by step
1. Reads the Program Brief for goals and scope, so risk discovery is scoped to what the program actually touches.
2. Generates a starter register with example risks already filled in across four categories (People, Technology, Compliance, Resource), instead of a blank page.
3. You map dependencies and integration points, asking "what if this doesn't deliver" for each one - this technique surfaces risks nobody volunteers on their own.
4. You replace the example risks with real ones, tagging each by what it threatens: Scope, Schedule, or Quality.
5. You flag any single point of failure explicitly - a rare-but-catastrophic risk that a plain likelihood score would under-weight.
6. Rate likelihood and impact for each risk; the risk score (likelihood x impact) is computed for you, not entered by hand.
7. Every risk needs a concrete mitigation, a trigger condition, a contingency plan, and a named owner - a risk with no mitigation is just a complaint.
8. Review the register on a cadence, and fully re-validate every risk (not just new ones) if the program pauses and restarts.

## What you get
A table: Risk, Category, Threatens, Likelihood, Impact, Risk Score, Mitigation, Trigger, Contingency, Owner, Status - plus a reference explaining the categories and scoring.

## Works well with
- Pulls from: `tpm-program-brief` (scope), `tpm-stakeholder-map` (dependency/stakeholder context)
- Feeds: `status-report` (ongoing visibility), `tpm-raci`/`tpm-contested-decisions` (when a mitigation needs an owner, or a decision needs resolving)
- If a Confluence space exists (`tpm-program-space`), updates the existing Risk Register page there directly whenever a new risk surfaces
