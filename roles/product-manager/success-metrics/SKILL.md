---
name: success-metrics
description: Use to define numeric, falsifiable KPIs and OKR-style success metrics for an initiative before it starts, and to communicate its actual outcome, including honest misses, to product leadership and client stakeholders after it ships.
---

# Success Metrics

## Purpose
Define what "worked" actually means, in numbers, before an initiative starts, and report what really happened afterward, to leadership and to client stakeholders, in the terms each audience needs, without changing the underlying number to flatter either one. A miss reported honestly is data; a miss hidden or reframed is how leadership stops trusting the next number brought to them.

## When to use
- An initiative from the roadmap (`roadmap-prioritization`) is about to start and has no stated success metric yet.
- An initiative has shipped and its outcome needs to be reported to leadership, a client, or both.
- A proposed metric is vague ("improve engagement") and needs to be made falsifiable before anyone adopts it.

## Process
1. **Frame the goal as an objective, and the metric as its key result.** The objective is the qualitative, inspirational statement of what should be true (tied to `concept`'s business outcome); the key result is the specific, numeric, gradable way you'll know. Two or three key results per objective is usually enough; more than that and none of them are actually driving decisions.
2. **Make each key result numeric and falsifiable.** "Improve X" is not a key result; "X moves from A to B by [date]" is. If it can't fail, it's not a metric, the same bar `concept`'s verifiable-requirements step already holds requirements to.
3. **Distinguish controllable input metrics from output metrics, and track both.** An input metric, often a team's One Metric That Matters (OMTM), is something the team can directly act on (selection, price, latency, a specific step in a funnel); an output metric, often the organization's North Star Metric, the single number that best captures the core value delivered to customers, not revenue or a vanity count, is the downstream result that input is supposed to drive but can't be manipulated directly. If the only metric defined is the output, the team has no lever to pull when it's trending wrong, only something to watch happen. Not every number worth tracking is a KPI: reserve that label for the metric actually tied to this initiative's strategic goal, not everything that happens to be on a dashboard.
4. **Capture a baseline before the initiative starts.** A metric with no "before" number can't prove a "did this work" claim afterward, only support an opinion about it.
5. **Set the bar deliberately, and decide up front what a good outcome even looks like.** A target hit at 100% every time isn't a sign of excellence, it's a sign the bar was set too low to learn anything. For a genuinely ambitious key result, landing around 70% of the stated target can be the actual win; decide which kind of target this is, a committed number versus a stretch, before the initiative starts, not after the result is in and needs a story.
6. **Name a data source and an owner for each metric.** A metric nobody can actually pull, or that three dashboards report three different numbers for, isn't a metric yet.
7. **Report the outcome honestly, including a miss.** State what happened against the baseline and target, not just the parts that look good, and grade it (hit, partial, missed) rather than describing it only in prose that can be read either way.
8. **Tailor the communication to the audience without changing the underlying number.** Product leadership gets the metric, the grade, and what it means for the roadmap; a client stakeholder gets the outcome in terms of the value they asked for, not internal process detail or an input metric they have no context for, the same "different audience, same source of truth" split `release-notes` and `integration-spec` already use.

## Output
A metrics definition per initiative (objective, key results, baseline, target type: committed vs. stretch, input vs. output classification, data source, owner), and an outcomes report per completed initiative, tailored per audience, stating what happened against the target, graded, including misses.

## Handoff
Metrics defined here feed back into `roadmap-prioritization`'s scoring for the next cycle: confidence in scoring should rise as more initiatives report real outcomes against what was predicted. A missed metric with a root cause worth capturing feeds `kaizen`. A contested metric, or a miss that needs escalation, is a `decision-log` entry.

## Checklist
- [ ] Each objective has 2-3 key results, not a long undifferentiated list nobody is actually tracking
- [ ] Every key result is numeric and falsifiable, not a qualitative aspiration
- [ ] Both an input metric (something the team can act on) and an output metric (the business result it drives) are defined, not output alone
- [ ] A baseline was captured before the initiative started
- [ ] Whether each target is a committed number or a deliberate stretch is decided before the result is in, not after
- [ ] Each metric has a named data source and owner
- [ ] Outcomes are reported honestly and graded, including misses, not just favorable results described in prose
- [ ] The same outcome is communicated differently per audience (leadership vs. client) without changing the underlying number
