# Jira Sprint Progress Dashboard Requirements

## Purpose
Provide a shared dashboard for monitoring sprint progress in Jira Cloud.

## Confirmed Requirements
- Display an active sprint's progress.
- Show issues completed versus remaining and story points completed versus remaining.
- Include a burndown chart, blocked or at-risk work indicators, and the sprint goal and end date.
- Keep the dashboard summary-only; do not embed an issue list.
- Refresh Jira data every 15 minutes.
- Use live Jira Cloud data and support a shared team dashboard.
- Jira Scrum board identifier: `xyz`.

## Provisional Scope
The initial selection was one team's active sprint. A later answer selected all accessible Jira projects, but the follow-up to resolve the conflicting scope was skipped. Until confirmed, use one team's active sprint as the working assumption.

## Open Questions
- Should the final scope be one team's active sprint or active sprints across multiple projects?
- What Jira authentication model is approved for a shared dashboard? Options discussed were a server-side, read-only integration identity or individual viewer authorization; no choice was recorded.
- How should "at risk" be determined? Blocked issues were requested, but the Jira fields, statuses, or rules that define these indicators are not specified.
- Who are the dashboard's intended viewers, and what access restrictions should apply?

## Acceptance Criteria
- The dashboard presents the selected sprint's goal and end date.
- It reports completed and remaining issue counts and story points.
- It visualizes sprint burndown and surfaces blocked or at-risk work according to agreed rules.
- It contains summary metrics only, with no embedded issue list.
- Live Jira data refreshes every 15 minutes.
- Jira credentials are handled using the authentication model approved for the shared dashboard and are not exposed in browser code or committed to the repository.
