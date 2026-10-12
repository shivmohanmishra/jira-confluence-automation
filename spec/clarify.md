# Senior Developer Review: Specification Gaps and Clarifications

**Documents reviewed:** `spec/constitution.md`, `spec/specification.md`, `project_spec.md`
**Review date:** 2026-10-12
**Review status:** Not ready for implementation until the blocking gaps below are resolved.

## Executive Summary

The specification has a useful V1 boundary, named users, a defined technology baseline, and several measurable product rules. It also correctly records many unknowns as open questions rather than silently choosing values.

However, the behavior is not yet deterministic enough to implement safely. The most important unresolved areas are:

1. Whether sprint data and risk notifications are computed per Jira-authorized viewer or once for the board as a whole.
2. How sprint scope, issue completion, story-point totals, and daily burndown points are defined.
3. What “immediately,” “while in use,” “new condition,” and “two working days” mean operationally.
4. How notification retries and concurrent workers guarantee deduplication without silently losing alerts.
5. The exact authentication, token lifecycle, configuration, persistence, and operational requirements.

The file `spec/specification.md` already lists several of these as open questions. This review identifies where they affect implementation and adds clarifications needed to turn the requirements into testable behavior.

## 1. Contradictions and Design Tensions

There are no unambiguous direct contradictions between the constitution and the feature specification. The following tensions need explicit resolution because different interpretations lead to materially different systems.

### C-01 — Per-user Jira permissions versus shared board monitoring and email

**References:** Constitution §2; Specification §§4, 5 (FR-003–004, FR-021–026, FR-031), §6.

The dashboard must use each viewer's Jira permissions, while the system also describes a centrally configured board, refresh coordination, persisted snapshots, and notifications to the Product Owner and Scrum Master. It is not stated whether a background poll uses one user's authorization, polls separately for each viewer, or uses a service account. A board-wide email may also disclose a condition to a recipient who cannot see the affected data in Jira.

**Clarify:** Define the authorization principal for every Jira read and notification. Specify whether cached data is keyed by user/authorization, whether shared results are allowed only when permission-equivalent, and what happens when a notification recipient lacks Jira access. Do not use a service account or broaden access unless expressly approved.

### C-02 — Fifteen-minute refresh versus “immediately” notifying on a new condition

**References:** Specification §4 Scenario 4; FR-021, FR-027, FR-031; `project_spec.md` FR-5/FR-6.

If a new condition is discovered only by a 15-minute poll, an alert cannot be immediate in the ordinary sense; it may be delayed by nearly one full interval, plus Jira and email latency. “While the dashboard is in use” also does not define whether polling stops when all browsers close.

**Clarify:** State the maximum detection and delivery latency, what activates and deactivates polling, and whether notification evaluation continues when there are no active viewers.

### C-03 — “No historical sprint analytics” versus the daily history needed for burndown risk

**References:** Specification §§3, 5 (FR-013, FR-017), §6, §13.

The burndown rule requires two consecutive daily data points and FR-024 requires persisted notification state. The specification excludes historical sprint analytics but does not say whether current-sprint daily points must be collected and retained, or whether Jira's own historical data is authoritative.

**Clarify:** Define the minimum current-sprint history needed for burndown and risk evaluation, its source, persistence duration, and deletion point. Explicitly distinguish this operational history from out-of-scope cross-sprint analytics.

### C-04 — “New blocker or risk condition” does not define the deduplication identity

**References:** Specification Scenario 4; FR-015–026; §6.

“Same condition” could mean a risk type for the whole sprint, a particular issue's blocker, a threshold transition, or a recipient-specific event. Each interpretation produces different email frequency and database keys.

**Clarify:** Define a stable condition identity, its scope (board, sprint, issue, user, or combination), transition rules, and whether changes in severity or affected work count as a new/material condition.

### C-05 — User-specific dashboard data versus central snapshots/freshness metadata

**References:** Specification FR-003–004, FR-024, FR-027–029, FR-034; §6.

The spec requires user-specific permission enforcement but describes sprint snapshots and refresh metadata without defining their authorization scope. A single shared snapshot could return information fetched under a more privileged user's access to a less privileged viewer.

**Clarify:** Specify whether snapshots are per-user or safely shareable, the authorization check required before serving them, and whether freshness and errors are reported per user, board, or both.

### C-06 — Project-wide Jira/Confluence constitution versus Jira-only feature scope

**References:** Constitution §§1–2, 5 and Technical Baseline; Specification §§1, 3, 13.

The constitution describes a Jira/Confluence automation project, but this feature explicitly excludes Confluence reads and writes. This is not a conflict if this is intentionally one Jira-only feature in a larger project; it is a scope mismatch if the requested deliverable is meant to automate both products.

**Clarify:** Confirm that this specification is only the sprint-dashboard feature and that Confluence work requires its own feature specification, authorization scope, and acceptance criteria.

## 2. Blocking Gaps — Resolve Before Implementation

### G-01 — Jira site, board identity, and configuration ownership

**References:** Specification FR-004, §6 Board configuration, §12 questions 1–2.

“Amplify” is a display name, not a stable API identifier. The site URL, numeric board ID, board filter, and owner of runtime configuration are not defined. It is also unclear whether configuration is environment-only, database-managed, or administrator-editable.

**Clarify:** Provide the Jira Cloud site and board ID; document the board filter and active-sprint selection rule; identify who may change configuration, how changes are validated/audited, and how configuration is promoted between environments.

### G-02 — Sprint-scope membership and changing scope

**References:** Specification FR-004, FR-010–013, FR-018; §6 Sprint snapshot.

“Active sprint scope” is not defined for issues added after sprint start, removed from the sprint, moved between sprints, subtasks, duplicates, cancelled work, or issues without estimates. Current scope and original committed scope can yield different completion and risk totals.

**Clarify:** Define which Jira issues count, whether totals use current or baseline scope, how scope changes affect counts and burndown, and whether removed work remains in any current-sprint calculation.

### G-03 — Issue status categories and count semantics

**References:** FR-010–012, FR-015–020; §12 question 4.

The spec requires completed/remaining counts and configurable completed/open/blocked mappings, but does not say whether categories are mutually exclusive, what happens to statuses mapped to both/neither, or whether blocked issues are included in remaining totals.

**Clarify:** Define the allowed status mapping and validation rules, precedence, treatment of unmapped statuses, and exact formulas for completed/remaining counts and estimates.

### G-04 — Story-point handling and reconciliation

**References:** FR-011–012; §9 SC-003; §12 question 3.

The exact Jira field, numeric precision, negative/invalid values, null estimates, and inclusion of unestimated issues are unknown. SC-003 cannot be verified until the rule for unestimated work is selected.

**Clarify:** Identify the field and unit/precision; define whether missing estimates are excluded, shown as “unestimated,” or otherwise represented; specify completed/remaining point formulas and how displayed totals reconcile to Jira.

### G-05 — Burndown data source, sampling, and ideal line

**References:** FR-013, FR-017; §10; §12 question 8.

The specification does not identify the Jira API/data source for historical daily remaining points, the daily cut-off/timezone, treatment of non-working days, sprint scope changes, or the calculation of the ideal line. The “two consecutive daily data points” rule is not testable until these are set. A zero ideal value makes percentage-above-ideal undefined.

**Clarify:** Define actual-data source and completeness criteria, daily sampling timestamp and timezone, ideal-line formula, treatment of weekends/holidays and scope changes, comparison formula including the zero-ideal case, and behavior when a daily point is absent.

### G-06 — Near-end risk calendar and issue interpretation

**References:** FR-018; §10; §12 question 7.

“Two working days or fewer” depends on timezone, weekends, holidays, sprint end inclusivity, and whether today counts. “Issues remain open” is also underspecified: it is unclear whether one open issue is enough and which statuses count as open.

**Clarify:** Supply the business calendar and timezone; define date-boundary arithmetic, sprint-end treatment, qualifying open statuses, and whether any versus all remaining issues trigger the condition.

### G-07 — Authentication and identity lifecycle

**References:** Constitution §2; FR-001–006; §8 dependencies; §12 question 5.

Company SSO and Jira OAuth are required, but the identity provider, protocol, account-linking rule, browser session model, callback validation, logout behavior, authorization revocation, and session expiry are not specified. “Jira OAuth 2.0” does not identify the exact Jira flow or security requirements.

**Clarify:** Select the approved SSO and Jira OAuth flows, define secure state/redirect handling, account linking, session/cookie and CSRF policy, token refresh/revocation, logout, and behavior when company identity and Jira identity no longer match.

### G-08 — Notification delivery contract and recipient authorization

**References:** FR-021–026; §6 Notification record; §10; §12 questions 6 and 9.

The provider and recipient lookup are TBD. “Initiate an email” does not define delivery success, retries, timeout handling, recipient failures, content, privacy constraints, or whether the email may contain sprint/issue details. The described crash-after-provider-acceptance case cannot be solved by a local dedupe flag alone.

**Clarify:** Approve provider and recipient source; define message content and sensitivity; establish delivery/retry/dead-letter behavior, idempotency support or outbox strategy, concurrent-worker locking, per-recipient outcomes, and safe handling when a recipient lacks access to the same Jira data.

### G-09 — Shared polling, concurrency, and refresh ownership

**References:** FR-027–031; §10; §12 questions 10–11.

The system does not define whether refresh is browser-triggered, server-scheduled, or both; how “in use” is detected; whether multiple users share a refresh; or how multiple API instances coordinate refresh and notification work. There is no timeout, backoff, rate-limit budget, retry policy, or cancellation behavior.

**Clarify:** Define the refresh owner and lifecycle, schedule/trigger semantics, per-user or shared request model, concurrency/locking approach, timeout and backoff policy, Jira rate-limit behavior, and maximum acceptable data age.

### G-10 — Persistence, credentials, retention, and deletion

**References:** Constitution §§2, 4; FR-024, FR-034–035; §6; §12 question 10.

PostgreSQL is required, but the information to persist, encryption/key management, retention period, user disconnect/deletion behavior, snapshot expiry, audit retention, backups, and production database operations are not defined. The constitution refers to an approved secret store while FR-034 mentions PostgreSQL state; it is unclear which store holds OAuth tokens.

**Clarify:** Separate secret/token storage from application-state storage; identify the approved secret manager and encryption-key owner; define data classification, retention/deletion, backup/restore, and audit requirements. State explicitly whether OAuth tokens may be stored in PostgreSQL and under what protection.

### G-11 — API contract and user-visible state behavior

**References:** FR-006, FR-028–033; Scenarios 1 and 5.

The spec requires typed JSON APIs and explicit error states but defines no response schemas, error taxonomy, status codes, loading transitions, partial-data representation, or stale-data behavior after authorization loss. It is unclear whether stale metrics remain visible or are hidden.

**Clarify:** Define endpoint/API contract ownership, response/error envelope, stable error codes, partial-data policy, stale-data display policy, and whether last-known metrics remain visible after permission revocation or Jira disconnection.

## 3. Important Quality and Verification Gaps

### Q-01 — Measurable performance and availability objectives

**References:** Specification §7 and §12 question 11.

The specification acknowledges missing latency, availability, capacity, and recovery targets. Production readiness cannot be objectively assessed without them.

**Clarify:** Set dashboard/API latency percentiles, expected concurrent users, refresh completion deadline, availability target, and recovery objectives, or explicitly defer them from V1 acceptance.

### Q-02 — Accessibility and browser support

**References:** Constitution §6; Specification FR-014, §7.

“Accessibility standards adopted by the organization” and “desktop/laptop browser” are not testable. Supported browsers, minimum viewport, zoom/reflow behavior, keyboard requirements, and conformance level are unstated.

**Clarify:** Name the accessibility standard and target conformance level, browser/version matrix, viewport range, and required automated/manual checks.

### Q-03 — Security, privacy, and audit acceptance criteria

**References:** Constitution §§2 and 5; FR-005; SC-009; §8.

Credential secrecy and log redaction are stated, but there is no explicit threat boundary or verification approach for session cookies, CSRF, CORS, rate limiting, API authorization, tenant/user isolation, audit events, or incident response.

**Clarify:** Adopt the organization's security baseline, define required audit events and access to them, and specify security tests (including cross-user authorization tests and secret/log scans).

### Q-04 — Testable definitions for broad success criteria

**References:** Scenarios 1–5; FR-001–035; SC-001–010.

Phrases such as “clear state,” “match Jira,” “immediately,” “while in use,” “visible,” and “new condition” do not have objective pass/fail thresholds. SC-010 states categories of tests but not the required boundary cases or release gate.

**Clarify:** Convert these phrases into observable assertions, test fixtures, tolerances, and explicit pass/fail criteria after the blocking decisions above are resolved.

### Q-05 — API and database migration/tooling requirements

**References:** Constitution §§3–4; FR-032–035.

Typed APIs and versioned migrations are required, but no schema migration mechanism, API versioning policy, transaction boundary, rollback policy, or compatibility rule is specified.

**Clarify:** Decide these during planning and record them in the implementation plan; ensure migration and API compatibility tests are part of the verification gate.

## 4. Clarification Checklist

Resolve these before implementation planning is considered complete:

1. Confirm this is a Jira-only dashboard feature under the broader Jira/Confluence project; defer Confluence to a separately specified feature.
2. Identify the Jira site, board ID/filter, sprint-selection behavior, story-point field, and issue-scope rules.
3. Define status categories and formulas for counts, estimates, missing estimates, and scope changes.
4. Define actual and ideal burndown data, daily sampling, timezone/calendar, and zero-ideal behavior.
5. Define near-end date arithmetic and which open work qualifies.
6. Decide whether data refresh, snapshots, risk evaluation, and alerting are per user or shared; prove that shared state cannot bypass user permissions.
7. Define SSO/Jira OAuth flows, identity linking, sessions, token storage, refresh, logout, and revocation.
8. Define notification condition identity, “immediate” delivery objective, recipients, content, retries, idempotency, and concurrency behavior.
9. Define when polling runs, its ownership, freshness limit, and Jira backoff/rate-limit policy.
10. Approve persistence, secret management, audit, retention, deletion, backup, and production operations.
11. Set measurable performance, availability, accessibility, browser-support, and security-verification criteria.
12. Define API error and partial-data contracts and release-gate tests.

## 5. Review Conclusion

The specification is a strong product outline but is **not implementation-ready**. The highest-risk gaps concern permission isolation, identity/token handling, metric/risk determinism, and notification side effects. Resolve the P0 items in the clarification checklist and update `spec/specification.md` before implementation. The project constitution remains the governing baseline; this review does not authorize relaxing its security or data-boundary principles.
