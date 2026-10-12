# Module 14 Completion Report

## Backlog Contents
# Implementation Backlog: Jira Sprint Progress Dashboard

## Priorities and Sequencing
- **P0:** Secure live-sprint summary, core progress metrics, blocker/risk indicators, and required V1 email alerts.
- **P1:** Resilience, accessibility, documentation, and operational readiness.
- Phases are ordered as requested, with dependency-aware overlap allowed. Frontend work may use typed fixtures while Jira integration is built.

## Phase 1: Setup
- [x] Bootstrap the npm workspace with a React/TypeScript frontend and Express/TypeScript API.
- [x] Install dependencies and verify frontend/API typechecks and production builds.
- [x] Configure ignores for dependencies, generated builds, and environment secrets.
- [ ] Confirm the Jira Cloud site URL and the numeric ID for the Amplify Scrum board. GitHub issues: #1, #3, #6, #7.
- [ ] Confirm the board filter, active-sprint selection rule, sprint goal/date fields, and story-point field. GitHub issues: #2, #4, #5, #8.
- [ ] Map Jira workflow statuses and flags that represent blocked work. GitHub issue: #9.
- [ ] Agree on the timezone and business-day calendar used by the two-working-day risk rule.
- [ ] Register company SSO and Jira OAuth applications; confirm least-privilege scopes and callback URLs.
- [ ] Confirm internal hosting, secret-store, audit, data-retention, and accessibility requirements.
- [ ] Select the approved email provider and determine how Product Owner and Scrum Master addresses are resolved.
- [ ] Define typed API contracts for sprint summary, burndown points, risk state, refresh metadata, and error responses.
- [ ] Add continuous checks for frontend/backend typechecks, tests, linting, and production builds.

## Phase 2: Core Features
- [ ] Build the desktop dashboard shell with clear sections for sprint details, progress, burndown, and risk.
- [ ] Implement loading, no-active-sprint, access-denied, stale-data, and API-error states.
- [ ] Render the active sprint goal, start/end dates, and last successful data refresh.
- [ ] Show completed and remaining issue counts with labels that distinguish counts from estimates.
- [ ] Show completed and remaining story points, including totals and completion percentage.
- [ ] Build the burndown chart with actual remaining story points and the ideal trend.
- [ ] Display explicit blocked work as a distinct signal from inferred delivery risk.
- [ ] Implement configurable risk thresholds: more than 20% behind ideal burndown for two consecutive daily data points, and open sprint work with two or fewer working days remaining.
- [ ] Keep the dashboard summary-only; link detailed issue inspection to Jira rather than embedding an issue list.
- [ ] Verify keyboard navigation, readable chart summaries, color-independent status labels, and desktop layout behavior.

## Phase 3: Integration
- [ ] Implement company SSO session handling and access control for authorized dashboard viewers.
- [ ] Implement per-viewer Jira OAuth authorization, callback handling, token refresh, and revocation.
- [ ] Store tokens server-side in the approved secret store; prevent tokens and sensitive issue data from entering browser responses or logs.
- [ ] Add a Jira API client that queries only the Amplify board and its active sprint using the signed-in user's permissions.
- [ ] Retrieve sprint metadata, scoped issues, statuses/flags, estimates, and daily burndown inputs; handle pagination and field mapping.
- [ ] Handle Jira rate limits, transient failures, expired authorization, permission changes, and partial responses.
- [ ] Refresh data every 15 minutes while the dashboard is in use and expose the last-success timestamp and stale state.
- [ ] Connect Jira data to the typed API contracts and frontend summary components.
- [ ] Implement the risk evaluator using the approved status mappings, thresholds, and business-day calendar.
- [ ] Send email to the Product Owner and Scrum Master when a new blocker or risk first appears.
- [ ] Deduplicate email across refreshes; send again only after resolution and reappearance or an agreed material change.
- [ ] Connect the approved email provider and keep delivery credentials in the secret store.

## Phase 4: Testing
- [ ] Unit-test issue/story-point totals, completion percentages, burndown calculations, and empty estimates.
- [ ] Test burndown-risk boundaries, two-consecutive-day evaluation, near-end timing, timezone behavior, and status mappings.
- [ ] Test Jira response mapping for pagination, missing fields, no active sprint, partial data, 401/403 responses, rate limits, and server errors.
- [ ] Test OAuth state validation, callback errors, token expiry, logout/revocation, and per-user permission isolation.
- [ ] Test email recipients, first-transition notification, deduplication, and re-notification after a risk resolves and returns.
- [ ] Component-test loading, empty, success, stale, and error states for all summary sections.
- [ ] Run end-to-end tests for the secure live-sprint summary and the V1 risk-email flow using Jira/email test doubles.
- [ ] Verify every acceptance criterion in `project_spec.md` against test results.
- [ ] Run accessibility checks and a manual keyboard/readability review on the desktop dashboard.
- [ ] Exercise production builds and verify no secrets or generated files are included in the client bundle.

## Phase 5: Documentation
- [ ] Document local prerequisites, install, run, typecheck, test, and build commands.
- [ ] Add an `.env.example` containing variable names and safe placeholders only; document secret-store configuration.
- [ ] Document Jira Cloud app registration, OAuth scopes, SSO setup, callback URLs, and board/field/status mappings.
- [ ] Explain issue counts, story-point totals, burndown calculations, risk thresholds, and business-day/timezone rules.
- [ ] Document user access, dashboard empty/error states, refresh behavior, and email notification rules.
- [ ] Write deployment, monitoring, audit-log, secret rotation, troubleshooting, and rollback procedures.
- [ ] Record known limitations and the out-of-scope V1 items from `project_spec.md`.

## GitHub Issues
| Issue URL | Title | Created via MCP? |
|-----------|-------|-----------------|
| https://github.com/shivmohanmishra/jira-confluence-automation/issues/1 | jira | Yes |

## MCP Tools Used
- github-mcp-server-get_file_contents
- github-mcp-server-search_repositories
- github-mcp-server-get_me
- github-create_repository
- github-mcp-server-list_issues
- github-issue_read
- github-get_label
- github-issue_write
- github-list_issues
- github-add_issue_comment
- github-mcp-server-get_commit
- github-create_or_update_file
