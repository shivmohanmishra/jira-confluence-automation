# Implementation Plan: Jira Sprint Progress Dashboard

**Feature branch**: `jira-sprint-dashboard`
**Status**: Proposed; implementation is gated on specification clarifications
**Source specification**: `spec/specification.md`
**Constitution**: `spec/constitution.md`
**Review notes**: `spec/clarify.md`

## 1. Planning Rules

- Deliver the V1 Jira sprint dashboard only. Confluence access, multiple boards, historical cross-sprint analytics, issue editing, and Slack notifications are out of scope.
- Keep the established stack: React 18 with Vite, Node.js with Express, and PostgreSQL 15 through Docker for local development and integration testing.
- Treat all unresolved specification questions as gates. Do not select authentication providers, OAuth flows, recipients, calendars, hosting, or retention policies by assumption.
- Preserve user-specific Jira permissions through data retrieval, caching, API responses, risk evaluation, and email notification.
- Keep the React app presentation-only. The Express backend owns identity enforcement, Jira access, business rules, persistence, refresh coordination, and email dispatch.
- Complete each milestone's exit criteria before starting dependent implementation work. Update `spec/specification.md` when clarification changes product behavior.

## 2. Dependency Overview

```text
M0 Clarify requirements and approve integrations
 ├──> M1 Establish development/test foundation
 └──> M2 Define API, identity, data and configuration contracts
        ├──> M3 Secure identity and Jira authorization
        ├──> M4 Jira data pipeline and sprint metrics
        ├──> M5 Blockers and risk evaluation
        ├──> M6 Refresh and notification processing
        └──> M7 Dashboard UX and end-to-end integration
                 └──> M8 Production readiness and release
```

M1 may proceed in parallel with clarification only for reversible scaffolding and test infrastructure. No Jira data access, persistence of production credentials, or user-visible business behavior should be implemented until M0 and M2 are approved.

## 3. Phases and Milestones

### Phase 0 — Clarification and Product Decisions

**Milestone M0: Implementation-ready specification approved**

Resolve the blocking questions in `spec/clarify.md` and update `spec/specification.md`.

**Work**

1. Confirm Jira Cloud site URL, Amplify board ID/filter, active-sprint rule, configuration owner, and environment-promotion process.
2. Define sprint membership, scope changes, subtasks/duplicates/cancelled issues, status categories, blocker precedence, completed/remaining formulas, and missing-estimate treatment.
3. Define actual burndown source, ideal-line formula, daily sampling/timezone, workday calendar, near-end arithmetic, and zero-ideal/missing-point behavior.
4. Decide whether reads, snapshots, risk state, and notifications are per user or shared. Prove any sharing is safe under Jira permission differences; identify the principal used for every Jira request.
5. Approve SSO and Jira OAuth flows, scopes, callback URLs, identity linking, session/cookie/CSRF policy, token storage, refresh, revocation, and logout behavior.
6. Approve notification condition identity, recipient resolution, content/privacy rules, delivery objective, provider, retries/idempotency, and concurrent worker behavior.
7. Define what “while in use” means; choose polling ownership, expected freshness, rate-limit/backoff policy, and maximum acceptable alert latency.
8. Approve data classification, persistence, secret manager, encryption/key ownership, retention/deletion, audit, backup/restore, hosting, monitoring, and operational ownership.
9. Set or explicitly defer measurable latency, availability, concurrency, browser-support, accessibility, and recovery requirements.
10. Define API response/error and partial-data contracts and make success criteria objectively testable.

**Exit criteria**

- No unresolved P0 decision affects authorization boundaries, metric formulas, risk evaluation, notification side effects, or data retention.
- `spec/specification.md` contains the approved behavior, with the clarified acceptance criteria and no conflicting assumptions.
- Security, platform, identity, Jira, email, and operational owners have approved the decisions relevant to them.

**Dependencies:** Product, security, identity, Jira administration, email/platform operations.

### Phase 1 — Development and Verification Foundation

**Milestone M1: Repeatable local development and CI checks**

**Work**

1. Confirm root workspace scripts and current app/API scaffolding support React 18 + Vite and Node.js + Express; align dependencies with the approved baseline.
2. Add or verify local Docker Compose configuration for PostgreSQL 15 with a named persistent volume, health check, non-production credentials, and documented startup/shutdown commands.
3. Select and configure a versioned database migration tool; add an initial migration mechanism without inventing production tables ahead of the approved data model.
4. Establish test runners and conventions for frontend components, backend units/API routes, and PostgreSQL integration tests.
5. Configure lint, type-check, build, and test commands in local workflows and CI.
6. Verify `.gitignore` excludes local secrets, database volumes, build output, and transient test artifacts; provide safe environment-variable examples only.

**Exit criteria**

- A developer can install dependencies, start PostgreSQL 15 in Docker, run the development services, and execute documented checks.
- CI or the repository's equivalent runs lint, typecheck, tests, and production builds.
- No real credentials or production configuration are required for local verification.

**Dependencies:** M0 for data/test expectations; approved developer tooling/platform constraints.

### Phase 2 — Architecture and Contracts

**Milestone M2: Reviewed API, identity, persistence, and integration contracts**

**Work**

1. Define typed JSON contracts for dashboard summary, sprint metadata, burndown series, risk state, refresh freshness, and explicit error/partial-data states.
2. Define authentication/session middleware boundaries and the trusted identity representation passed to application services.
3. Define Jira client interfaces and request boundaries, including pagination, rate limits, timeout behavior, and permission context.
4. Define PostgreSQL entities and migrations for only the approved application state: user/Jira authorization references, refresh metadata/snapshots if approved, condition transitions, and notification delivery state.
5. Define configuration schema and validation for board, field/status mappings, business calendar, thresholds, and provider configuration.
6. Define audit/logging event schema and redaction rules.
7. Create architecture decision records for choices with lasting impact, including cache isolation, refresh ownership, and notification reliability strategy.

**Exit criteria**

- API, identity, configuration, persistence, logging, and integration contracts are reviewed and versioned.
- Every persisted datum has an approved purpose, access scope, and retention rule.
- Contracts include observable failure behavior and testable examples.

**Dependencies:** M0 and M1.

### Phase 3 — Secure Identity and Jira Authorization

**Milestone M3: Authorized user can establish and revoke a safe Jira connection**

**Work**

1. Implement the approved company SSO integration and protected dashboard session.
2. Implement Jira OAuth initiation and callback handling with state validation, redirect validation, and the approved scopes.
3. Link company and Jira identities according to the approved policy.
4. Store credentials only in the approved protected backend store; implement token refresh, expiration, revocation, and user disconnect.
5. Add authorization middleware to every Jira-backed API and prevent cross-user access to sessions, snapshots, and connection state.
6. Add security tests for unauthenticated requests, missing/revoked authorization, callback tampering, CSRF/session controls, and cross-user access.

**Exit criteria**

- SSO and Jira authorization success/failure states are explicit.
- No client bundle, API response, repository file, or log contains OAuth credentials.
- Automated tests demonstrate that user A cannot read user B's Jira-backed data.

**Dependencies:** M0, M2; registered identity/OAuth applications and test accounts.

### Phase 4 — Jira Data Pipeline and Sprint Metrics

**Milestone M4: Authorized user receives accurate active-sprint summary data**

**Work**

1. Implement a Jira API client with timeouts, pagination, rate-limit handling, authorization error mapping, and safe logging.
2. Resolve the configured Amplify board and active sprint under the approved user/permission model.
3. Retrieve and map sprint goal/dates, scoped issues, status/flags, story points, and burndown source data.
4. Implement explicit mapping for no active sprint, access denied, missing fields, unmapped statuses, partial pages, and missing estimates.
5. Calculate completed/remaining counts and story-point totals using the approved formulas.
6. Implement actual and ideal burndown series and persist only the approved minimum history.
7. Add unit and integration tests using Jira fixtures/test doubles and PostgreSQL 15.

**Exit criteria**

- Sprint and totals match agreed Jira fixtures for all approved boundary cases.
- Board/sprint scope and user permissions are enforced and tested.
- Incomplete or stale inputs cannot appear as successful current metrics.

**Dependencies:** M2 and M3; Jira test tenant and board configuration.

### Phase 5 — Blocker and Risk Evaluation

**Milestone M5: Configured blocker and risk rules produce deterministic states**

**Work**

1. Validate and load configured status/flag mappings; report invalid or absent mappings as configuration errors.
2. Implement explicit blocker classification independently from inferred risks.
3. Implement burndown risk using the approved actual/ideal series, daily sampling, consecutive-point rule, and zero/missing-data semantics.
4. Implement near-end risk using the approved timezone, business calendar, sprint-end boundary, open-status mapping, and issue-scope semantics.
5. Persist condition identity and active/resolved transitions with concurrency-safe constraints/transactions.
6. Test threshold boundaries, missing points, scope changes, status precedence, resolution, and reappearance.

**Exit criteria**

- Every configured rule has deterministic, table-driven tests at boundary values.
- Explicit blockers and inferred risks remain separate in API and UI models.
- Concurrent evaluation does not create duplicate active condition records.

**Dependencies:** M0, M2, M4; approved status, calendar, and risk definitions.

### Phase 6 — Refresh and Email Notifications

**Milestone M6: Freshness and notification lifecycle are safe and reliable**

**Work**

1. Implement the approved refresh scheduler/trigger model and “in use” lifecycle.
2. Coordinate refresh work across processes and users according to the approved authorization/cache isolation model.
3. Track last successful refresh and failures; apply approved timeout, backoff, and rate-limit policy.
4. Implement a transactional outbox or approved equivalent for condition transitions and email delivery.
5. Integrate the approved email provider and recipient source using privacy-approved message content.
6. Implement idempotency, retry, dead-letter/manual recovery, per-recipient results, and operational alerts.
7. Test duplicate polling, concurrent workers, timeouts before/after provider acceptance, restarts, and resolve/reappear behavior.

**Exit criteria**

- Refresh interval and maximum data/notification latency meet approved targets.
- Persistent notification deduplication survives process restarts and concurrent workers.
- Provider failure is observable and retryable without silent loss or duplicate successful notification.

**Dependencies:** M0, M2, M4, M5; approved email provider and recipient configuration.

### Phase 7 — Dashboard User Experience and End-to-End Integration

**Milestone M7: Users can understand the current sprint and its data state**

**Work**

1. Implement the React 18/Vite dashboard shell and responsive desktop/laptop layout.
2. Add SSO/Jira authorization, no-sprint, access-denied, loading, stale, partial, and error states.
3. Render goal/end date, completed/remaining issues and points, actual/ideal burndown, explicit blockers, and inferred risks.
4. Display last successful refresh and provide appropriate links to Jira for issue-level inspection without embedding an issue list.
5. Meet approved keyboard, screen-reader, chart-summary, contrast, and browser-support requirements.
6. Run API, database, and browser end-to-end tests against test doubles and PostgreSQL 15 in Docker.
7. Verify acceptance criteria SC-001 through SC-010 with recorded evidence.

**Exit criteria**

- The complete user journey succeeds for authorized users and fails safely for missing access/integration states.
- No issue list or unapproved Jira data is rendered.
- Accessibility and browser checks meet the agreed standard.
- All specification acceptance criteria pass or have explicitly approved deferrals.

**Dependencies:** M2–M6.

### Phase 8 — Production Readiness and Release

**Milestone M8: Approved internal deployment**

**Work**

1. Complete security and privacy review, including token handling, authorization isolation, logging, and secret-store configuration.
2. Validate production migrations, backup/restore, retention/deletion, and least-privilege database access.
3. Configure approved hosting, TLS, secret injection, monitoring, alerting, and audit collection.
4. Exercise Jira/email outage, rate-limit, credential rotation, worker restart, and recovery scenarios.
5. Confirm operational runbooks, ownership, rollback process, and support escalation.
6. Obtain product, security, identity, Jira administration, and operations sign-off.

**Exit criteria**

- Measurable production SLOs and recovery requirements are met.
- No unresolved release-blocking security or data-isolation findings remain.
- Deployment, rollback, monitoring, retention, and incident procedures are approved.

**Dependencies:** M7 and all outstanding organizational approvals.

## 4. Cross-Cutting Verification Gates

These checks apply throughout implementation and at release:

- **Traceability:** Link each test and implementation slice to FR/SC identifiers.
- **Security:** Test authentication, authorization, per-user Jira access, secret redaction, and data isolation.
- **Reliability:** Test Jira/email timeouts, rate limits, partial data, retries, process restarts, and duplicate work.
- **Data:** Run migrations forward in CI; test constraints, transactions, retention/deletion behavior, and backup/restore as applicable.
- **Frontend:** Run type checks, lint, production build, keyboard checks, and accessible chart/state verification.
- **Integration:** Use test doubles for routine external-service tests and a dedicated Jira test tenant for contract/end-to-end tests.
- **Release evidence:** Maintain a checklist mapping each success criterion to test evidence, manual evidence, or approved deferral.

## 5. Risk Register

| Risk | Impact | Mitigation / Gate |
|---|---|---|
| Shared Jira cache or polling leaks data across permission levels | Unauthorized disclosure | Decide per-user versus safely shareable data model in M0; test cross-user isolation in M3/M4 |
| Underspecified burndown or sprint scope yields incorrect risk signals | False confidence or noisy alerts | Approve formulas, source, scope changes, and calendar in M0 before metric implementation |
| Email acceptance followed by process failure causes loss or duplicates | Missed or repeated alerts | Approve an outbox/idempotency approach and failure contract in M0/M6 |
| Organization has no approved SSO, secret store, or email service ready | Blocks end-to-end and release | Identify owners and sandbox/test integrations in M0 |
| Docker engine or local developer prerequisites unavailable | Slows local database verification | Validate prerequisites in M1; CI must provide repeatable PostgreSQL 15 integration tests |
| Production performance/security targets remain unspecified | Release readiness cannot be objectively approved | Set or explicitly defer measurable targets in M0 and gate M8 on approval |

## 6. Planning Assumptions and Exclusions

- Milestones are dependency-based; no calendar dates or duration estimates are assigned because staffing and external approvals are unknown.
- The existing React/Vite and Express workspace is a starting scaffold only; implementation must verify actual versions and align them to the constitution before feature work.
- PostgreSQL 15 via Docker is the development and integration-test baseline; production database hosting is still an organizational decision.
- The plan does not authorize Confluence API access. A Confluence feature requires a separate specification and plan.
- If clarification changes scope, update `spec/specification.md`, this plan, and traceable tests before implementation proceeds.
