# Jira Sprint Progress Dashboard

**Document status:** Draft technical specification

## 1. Purpose and Context
Build an internally hosted dashboard that helps a Product Owner monitor one mobile-app team's active sprint in Jira Cloud. The team has 6–10 people. The dashboard should help viewers assess sprint-goal confidence, completion, scope risk, and blockers.

## 2. Users
- Product Owner
- Scrum Master
- Development team
- Leadership and stakeholders

Users authenticate individually. Dashboard access requires company SSO and Jira authorization; Jira permissions remain user-specific.

## 3. Scope
### In Scope
- One team's active sprint on the Jira Scrum board named **Amplify**.
- Live Jira Cloud data.
- Desktop/laptop browser experience.
- Summary metrics, charts, and risk indicators; no embedded issue list.
- Automatic refresh every 15 minutes.
- Email notification when a new risk condition appears, sent to the Product Owner and Scrum Master.

### Out of Scope for V1
- Comparing multiple teams, boards, or projects.
- Historical sprint analytics.
- Embedded issue-level list or editing Jira issues.
- Slack notifications.

## 4. Functional Requirements

### FR-1: Authentication and Authorization
- Require company SSO to access the dashboard.
- Require each viewer to authorize Jira access through Jira OAuth.
- Query only the selected board and active sprint, and respect the signed-in viewer's Jira permissions.
- Keep OAuth tokens server-side; never expose tokens to browser code or commit them to source control.

### FR-2: Active Sprint Overview
Show the sprint goal and end date for the active sprint on the Amplify board. If no active sprint is found or the viewer lacks board access, show a clear empty or access state rather than misleading metrics.

### FR-3: Progress Metrics
Display:
- Completed versus remaining issue counts.
- Completed versus remaining story points. The team consistently uses story points.
- Sprint burndown against the ideal trend.

### FR-4: Blockers and At-Risk Work
Show explicit Jira blocked flags/statuses and these inferred risk conditions:
- **Burndown risk:** remaining story points exceed the ideal trend by more than 20% for two consecutive daily data points.
- **Near-end risk:** sprint-scope issues remain open with two working days or fewer before sprint end.

Risk status should be visible on the dashboard. Jira status/flag mappings must be configurable to match the team's Jira workflow.

### FR-5: Email Notifications
- Send email immediately when a new blocker or risk condition first appears.
- Notify the Product Owner and Scrum Master.
- Avoid repeat emails on every 15-minute refresh; send again only after a risk is resolved and later reappears, or a separately defined material change occurs.
- Use an approved company email service. Its provider and recipient resolution mechanism are TBD.

### FR-6: Refresh
Refresh sprint data every 15 minutes while the dashboard is in use. Show the last successful update time and a clear stale/error state if Jira cannot be reached.

## 5. User Experience
- Summary-only layout centered on sprint goal, end date, completion, burndown, blockers, and risk.
- Desktop/laptop browser is the primary target.
- Do not embed a Jira issue list; detailed issue inspection remains in Jira.
- Use clear labels and distinguish explicit blockers from inferred risk indicators.

## 6. Recommended Technical Design
- **Frontend:** React and TypeScript single-page application.
- **Backend:** Node.js/TypeScript backend-for-frontend (BFF) that owns Jira OAuth callbacks, token handling, Jira API requests, refresh coordination, and email dispatch.
- **Identity:** Company SSO for dashboard sessions plus Jira OAuth 2.0 authorization for each viewer.
- **Hosting:** Internal company hosting, exact platform TBD.
- **Integrations:** Jira Cloud Agile/REST APIs for board, sprint, issue status, estimates, sprint goal and dates; approved company email service for risk notifications.
- Use least-privilege Jira scopes. Store secrets and tokens in an approved secret store, encrypted at rest. Do not log access tokens or sensitive issue content.

## 7. Non-Functional Requirements
- Dashboard data must be scoped to the active sprint on the configured board and to the signed-in user's Jira permissions.
- Handle Jira rate limits, expired authorization, API errors, and partial data without presenting stale data as current.
- Email delivery must be deduplicated across polling cycles.
- Meet the organization's internal security, accessibility, and hosting standards; specific standards are TBD.

## 8. Acceptance Criteria
1. An authorized viewer can open the internal dashboard after company SSO and Jira authorization.
2. The dashboard resolves the active sprint on the Amplify board and displays its goal and end date.
3. Issue and story-point completed/remaining totals agree with Jira for that sprint.
4. The burndown displays actual remaining story points and the ideal trend.
5. Explicit blockers are shown according to the configured Jira workflow mapping.
6. The dashboard flags the approved burndown and near-end risk thresholds.
7. A new risk sends one email to the Product Owner and Scrum Master; a continuing risk does not resend on every refresh.
8. Data refreshes every 15 minutes, with last-updated and error/stale states visible.
9. The dashboard contains no embedded issue list and works in a desktop/laptop browser.

## 9. Open Items Before Implementation
- Jira Cloud site URL and numeric ID for the Amplify board.
- Confirm the board's active-sprint filter, story-point field, and Jira status/flag values that indicate blocked work.
- Company SSO provider and approved OAuth application registration/scopes.
- Internal hosting platform and deployment/release process.
- Approved email provider and how Product Owner/Scrum Master addresses are resolved.
- Confirm the calendar/timezone used to count the two working days before sprint end.
- Confirm organizational accessibility, audit, and data-retention requirements.
