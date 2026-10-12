# Feature Specification: Jira Sprint Progress Dashboard

**Feature branch**: `jira-sprint-dashboard`
**Created**: 2026-10-12
**Status**: Draft — clarification required before implementation
**Input**: Module 08 product specification in `project_spec.md`
**Constitution**: `spec/constitution.md`

## 1. Summary

Build an internally hosted, desktop/laptop dashboard that lets authorized users monitor one mobile-app team's active sprint on the Jira Cloud Scrum board named **Amplify**. The dashboard presents sprint context, completion metrics, burndown, explicit blockers, and inferred delivery risks. It refreshes Jira data every 15 minutes while in use and notifies the Product Owner and Scrum Master by email when a new blocker or risk first appears.

The React frontend must communicate only with the Node.js/Express backend. The backend enforces identity and Jira permissions, accesses Jira Cloud, applies business rules, persists required state in PostgreSQL, coordinates refreshes, and dispatches email. The specified development baseline is React 18 with Vite, Node.js with Express, and PostgreSQL 15 run through Docker.

This feature specification covers the Jira sprint dashboard described in Module 08. It does not define Confluence automation behavior. Any Confluence reads or writes require a separately reviewed feature specification and acceptance criteria.

## 2. Goals

- Give authorized stakeholders an accurate summary of the active Amplify sprint.
- Make completed and remaining issue counts and story points easy to assess.
- Show actual sprint burndown against an ideal trend.
- Distinguish explicit Jira blockers from calculated delivery risks.
- Alert the Product Owner and Scrum Master when a new blocker or risk appears without repeating alerts on every refresh.
- Make data freshness, missing authorization, access denial, and integration failures visible rather than presenting misleading metrics.
- Preserve the signed-in user's Jira authorization and keep integration credentials out of the browser.

## 3. Non-Goals

- Comparing multiple teams, boards, or Jira projects.
- Providing historical sprint analytics.
- Embedding an issue-level list or editing Jira issues from the dashboard.
- Sending Slack notifications.
- Performing Confluence operations.
- Replacing Jira as the source of truth for sprint or issue data.

### V1 Scope Decision — T001

**Decision:** Confirmed by the product owner on 2026-10-12. This specification covers only the Jira Amplify sprint dashboard described above. Confluence reads or writes, multiple boards, cross-sprint analytics, issue editing, and Slack notifications are out of scope for V1. Any proposed scope change must be recorded here with acceptance criteria before implementation.

## 4. Users and User Scenarios

### User roles

- **Product Owner**: assesses sprint progress and receives new blocker/risk alerts.
- **Scrum Master**: monitors delivery risks and receives new blocker/risk alerts.
- **Development team member**: reviews sprint progress and blockers.
- **Leadership or stakeholder**: reviews the summary without needing an issue-level dashboard.

All dashboard users authenticate individually. Each user's Jira visibility remains constrained by that user's Jira permissions.

### Scenario 1: View the active sprint summary

An authorized user signs in through company SSO, authorizes Jira access, and opens the dashboard. The dashboard resolves the active sprint for the configured Amplify board and displays its goal, end date, progress, burndown, blockers, and risk indicators using data visible to that user.

**Acceptance checks**

- The user must complete company SSO before viewing protected dashboard data.
- The user must complete Jira authorization before Jira-backed metrics are shown.
- Data returned to the user must respect that user's Jira permissions.
- The UI must show a clear authorization or access state when either prerequisite is missing.

### Scenario 2: Assess sprint progress

The user compares completed and remaining issue counts and story points, and reviews actual remaining story points against the ideal burndown trend.

**Acceptance checks**

- Completed and remaining counts are labeled distinctly.
- Completed and remaining story points are labeled distinctly.
- The dashboard shows actual and ideal burndown series with readable labels and a non-color-only distinction.
- Totals agree with Jira data for the authorized user's sprint scope.

### Scenario 3: Identify blockers and delivery risks

The user reviews explicit Jira blocked flags/statuses separately from inferred burndown and near-end risks.

**Acceptance checks**

- Explicit blockers are derived from configured Jira workflow mappings.
- Burndown and near-end risks are labeled as inferred risks, not as Jira blocker flags.
- If status or flag mappings are absent or invalid, the dashboard reports configuration/data limitations instead of silently claiming there are no blockers.

### Scenario 4: Receive a new risk notification

When a new blocker or risk condition is detected, the system sends an email to the configured Product Owner and Scrum Master recipients. Continuing conditions do not cause an email on every poll.

**Acceptance checks**

- A first transition into a blocker/risk condition creates one notification event.
- Continued presence of the same condition across refresh cycles does not generate duplicate email.
- A condition that resolves and later reappears may generate a new notification.
- Notification delivery errors are visible to operators and can be retried safely without duplicate successful notifications.

### Scenario 5: Handle missing or unhealthy integration data

When no sprint is active, access is denied, Jira is unavailable, authorization expires, or data is incomplete, the user receives an explicit state and freshness information.

**Acceptance checks**

- No active sprint and insufficient Jira permission produce distinct, clear states.
- Jira rate limits, authorization failures, timeouts, service failures, and partial responses are not presented as successful current data.
- The last successful refresh timestamp remains available when a later refresh fails, and the UI clearly marks the data stale or unavailable.

## 5. Functional Requirements

### Identity and authorization

- **FR-001**: The application MUST require company SSO authentication before serving protected dashboard data.
- **FR-002**: Each user MUST authorize Jira through the approved Jira OAuth 2.0 flow before Jira data is requested on that user's behalf.
- **FR-003**: The backend MUST enforce the authenticated user's identity and Jira authorization for every Jira-backed request.
- **FR-004**: Jira queries MUST be restricted to the configured Amplify board and its active sprint for this release.
- **FR-005**: OAuth client secrets, Jira access tokens, and refresh tokens MUST remain server-side; no browser response, client bundle, source control, or log may contain them.
- **FR-006**: The application MUST provide explicit states for signed-out users, users who have not authorized Jira, revoked/expired authorization, and users without board access.

### Sprint overview and metrics

- **FR-007**: The dashboard MUST identify the active sprint on the configured Amplify Scrum board.
- **FR-008**: The dashboard MUST display the active sprint goal and end date when Jira supplies them.
- **FR-009**: If no active sprint is available, the application MUST show a clear empty state and MUST NOT present another sprint's data as current.
- **FR-010**: The dashboard MUST display completed and remaining issue counts for the active sprint scope.
- **FR-011**: The dashboard MUST display completed and remaining story-point estimates for the active sprint scope.
- **FR-012**: Missing, null, or otherwise unusable Jira estimates MUST be handled explicitly and MUST NOT be silently converted into a misleading estimate.
- **FR-013**: The dashboard MUST show actual remaining story points and an ideal burndown trend over the sprint.
- **FR-014**: Burndown visualizations MUST include text labels or an equivalent accessible summary and MUST not rely on color alone.

### Blockers and risks

- **FR-015**: The application MUST identify explicit blockers using configurable Jira status and/or flag mappings.
- **FR-016**: Explicit Jira blockers MUST be distinguishable from inferred risk conditions in the UI.
- **FR-017**: The system MUST raise burndown risk when remaining story points are more than 20% above the ideal trend for two consecutive daily data points, subject to a clarified calculation for a zero ideal value.
- **FR-018**: The system MUST raise near-end risk when sprint-scope issues remain open with two working days or fewer before sprint end, using the approved working-day calendar and timezone once defined.
- **FR-019**: The dashboard MUST show current risk state and MUST identify whether it is an explicit blocker or an inferred condition.
- **FR-020**: Jira workflow mappings and risk-related configuration MUST be centrally configurable and validated; the application MUST report unusable configuration rather than silently treating it as an empty mapping.

### Notifications

- **FR-021**: On the first detection of a new blocker or risk condition, the backend MUST initiate an email notification to the configured Product Owner and Scrum Master recipients.
- **FR-022**: Repeated refreshes while the same condition remains active MUST NOT send repeated email notifications.
- **FR-023**: A resolved condition that later reappears MUST be eligible to send a new notification.
- **FR-024**: Notification state and delivery attempts MUST be persisted so deduplication survives process restarts and refresh cycles.
- **FR-025**: Notification retries MUST be idempotent or otherwise protected against duplicate delivery.
- **FR-026**: The email provider and recipient-resolution method MUST be supplied by approved project configuration; no provider or addresses are assumed by this specification.

### Refresh and data states

- **FR-027**: While the dashboard is in use, Jira sprint data MUST refresh every 15 minutes.
- **FR-028**: The UI MUST display the last successful refresh timestamp.
- **FR-029**: On a failed or partial refresh, the UI MUST clearly show an error or stale-data state and MUST NOT label the old data as current.
- **FR-030**: Jira rate limiting, expired authorization, permission changes, transient errors, and partial responses MUST be handled explicitly.
- **FR-031**: Refresh coordination MUST avoid uncontrolled duplicate polling and concurrent notification side effects.

### API and persistence

- **FR-032**: The React frontend MUST access application data through backend APIs and MUST NOT call Jira, Confluence, or PostgreSQL directly.
- **FR-033**: Backend APIs MUST validate inputs and return explicit, appropriately classified error responses.
- **FR-034**: PostgreSQL 15 MUST persist only the state needed for approved application behavior, including notification deduplication and any refresh metadata needed for freshness.
- **FR-035**: Database schema changes MUST be versioned migrations and preserve data integrity using appropriate constraints and transactions.

## 6. Data Concepts

These are conceptual entities; physical schema and retention periods are not determined by this specification.

- **Dashboard user**: An individually authenticated company user, associated with an authorized Jira identity.
- **Jira authorization**: Server-side OAuth grant and lifecycle state for a user. Credentials are sensitive and are never exposed to the browser.
- **Board configuration**: The configured Jira Cloud site, Amplify board identity, sprint-selection behavior, story-point field, and workflow mappings.
- **Sprint snapshot**: A scoped view of sprint metadata, issue counts, estimates, burndown points, and the time of the last successful refresh.
- **Blocker/risk condition**: A condition identifier, type (explicit blocker or inferred risk), active/resolved state, and transition timestamps sufficient for display and notification deduplication.
- **Notification record**: The condition transition, intended recipient references, delivery status, and retry/idempotency data needed to prevent duplicate sends.

## 7. Quality Attributes and Constraints

- **Security**: Apply least-privilege OAuth scopes, server-side authorization checks, secure secret storage, encryption at rest for persisted sensitive tokens, and log redaction.
- **Privacy**: Request, persist, and return only data required for the approved sprint summary. Do not leak data across users or tenants.
- **Reliability**: Handle Jira and email provider failures explicitly; retry safely where appropriate; do not silently substitute success-shaped data.
- **Freshness**: Refresh every 15 minutes while in use and visibly distinguish current, stale, partial, and unavailable data.
- **Data integrity**: Persist notification transition state reliably and use PostgreSQL transactions/constraints for related state changes.
- **Accessibility**: Support keyboard interaction, readable labels, non-color-only indicators, and clear loading, empty, error, and stale states.
- **Compatibility**: Use React 18 with Vite, Node.js with Express, and PostgreSQL 15. Run PostgreSQL through Docker for local development and repeatable integration testing.
- **Scope**: The primary target is a desktop/laptop browser. The application is summary-only; issue-level investigation remains in Jira.
- **Observability**: Record operational events and correlation information while excluding credentials, tokens, and sensitive issue/page content.

No latency, availability, throughput, or recovery-time targets are specified yet; these MUST be set by the product/operations owners before production readiness is approved.

## 8. Dependencies and External Systems

- Jira Cloud Agile/REST APIs for board, active sprint, issue status/flags, estimates, sprint goal, sprint dates, and burndown inputs.
- Company SSO provider and registered application.
- Jira OAuth 2.0 application, callback URLs, and least-privilege scopes.
- Approved company email provider and recipient-resolution mechanism.
- PostgreSQL 15 deployment; Docker is the required local-development and integration-test runtime.
- Internal hosting, secret store, audit, monitoring, accessibility, and retention standards.

## 9. Success Criteria

- **SC-001**: An authorized user completes company SSO and Jira authorization and can open the dashboard.
- **SC-002**: The active sprint resolved for the configured Amplify board is shown with its goal and end date when available.
- **SC-003**: Completed/remaining issue counts and story-point totals match the authorized Jira sprint data, including the clarified treatment of missing estimates.
- **SC-004**: The burndown presents actual remaining story points and the agreed ideal trend.
- **SC-005**: Explicit blockers and inferred burndown/near-end risks are distinguishable and follow approved configuration and thresholds.
- **SC-006**: One email is sent on a new condition transition; an ongoing condition does not produce an email on each 15-minute refresh; a resolved-then-reappearing condition can notify again.
- **SC-007**: Refresh occurs every 15 minutes while in use; last-success time and failed/stale state are visible.
- **SC-008**: No embedded issue list is shown, and issue-level inspection remains in Jira.
- **SC-009**: No Jira/Confluence credentials or OAuth tokens are present in browser-delivered code, API responses, source control, or logs.
- **SC-010**: Automated verification covers business rules, authorization boundaries, database persistence, and external integration failure behavior.

## 10. Edge Cases and Failure States

- No active sprint exists on the configured board.
- The user is signed into SSO but has not authorized Jira.
- Jira authorization expires, is revoked, or lacks board permission.
- The board, story-point field, sprint goal, sprint dates, status, or blocker flag is absent or malformed.
- Issues have missing estimates or statuses not yet mapped to completed/open/blocked categories.
- The ideal burndown reaches zero while remaining work is nonzero, making percentage comparison undefined.
- The near-end threshold falls on a weekend, holiday, timezone boundary, or a day without an agreed business-calendar interpretation.
- Jira returns rate limits, timeouts, server errors, incomplete pages, or inconsistent partial data.
- A refresh fails after a prior successful snapshot.
- Email delivery fails, times out after provider acceptance, or succeeds while the process crashes before recording success.
- Multiple backend workers detect the same new condition concurrently.
- A condition resolves and reappears between refreshes.

For all cases, the system MUST avoid false success, protect user permissions and credentials, retain accurate freshness indicators, and prevent duplicate side effects where feasible.

## 11. Assumptions

- V1 is the single-team Jira sprint dashboard described by the Module 08 specification; it is not a general Jira or Confluence automation product.
- The configured board is the Jira Scrum board named Amplify, and only its active sprint is included.
- Jira is the source of truth for sprint and issue data.
- Story points are consistently used by the team, but the exact Jira field identifier remains to be confirmed.
- User-specific Jira authorization is required even when the user can access the dashboard through company SSO.
- Internal hosting and approved integrations will be provided by the organization.

## 12. Open Questions — Resolve Before Implementation

1. What Jira Cloud site URL and numeric board ID identify the Amplify board?
2. What is the exact active-sprint selection rule and board filter behavior?
3. Which Jira field contains story points, and how should null or missing estimates affect totals and percentages?
4. Which Jira statuses and flags constitute completed, open, and explicitly blocked work?
5. What company SSO provider, Jira OAuth application, scopes, and callback URLs are approved?
6. Which email provider is approved, and how are Product Owner and Scrum Master recipients resolved?
7. Which timezone and business-day/holiday calendar define “two working days or fewer”?
8. How is the ideal burndown calculated, and how is the >20% threshold evaluated when the ideal value is zero?
9. What constitutes a material change that may justify a repeat notification beyond resolution and reappearance?
10. What internal hosting, secret-store, deployment, audit, monitoring, accessibility, and data-retention standards apply?
11. What latency, availability, capacity, and recovery targets are required for production?
12. Is Confluence automation in scope for a later feature? If so, what Confluence operations, permissions, and acceptance criteria are required? This specification does not authorize Confluence access or writes.

## 13. Out of Scope for This Release

- Comparing teams, boards, or projects.
- Historical sprint analytics.
- Embedded issue lists or Jira issue editing.
- Slack notifications.
- Confluence reads or writes.
- Selecting or managing multiple active sprints.
- Production hosting, identity-provider configuration, or email-provider implementation details not yet approved.
