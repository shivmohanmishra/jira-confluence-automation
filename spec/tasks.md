# Implementation Tasks: Jira Sprint Progress Dashboard

**Status:** Proposed — implementation tasks are gated on requirement clarification.
**Plan:** `spec/plan.md`
**Specification:** `spec/specification.md`
**Constitution:** `spec/constitution.md`
**Clarifications:** `spec/clarify.md`

## Task Conventions

- Tasks are ordered by dependency, not by estimated duration. No dates or effort estimates are assigned.
- “Acceptance criteria” describe evidence required to mark a task complete; they do not imply the task has already been implemented.
- T001–T012 are specification/approval tasks. Feature behavior must not begin until the relevant decisions are approved and reflected in `spec/specification.md`.
- Every code change must preserve the constitution's permission, credential, privacy, migration, error-reporting, accessibility, and verification requirements.
- Jira/Confluence API access in this task set is Jira-only. Confluence requires a separate approved feature specification.

## Phase 0 — Clarification and Product Decisions

### T001 — Confirm feature boundary and V1 scope

**Depends on:** None
**Acceptance criteria:**

- Product owner confirms that this specification implements only the Jira Amplify sprint dashboard.
- Confluence reads/writes, multiple boards, cross-sprint analytics, issue editing, and Slack notifications remain out of scope for this release.
- Any proposed change to that scope is recorded in `spec/specification.md` with acceptance criteria before implementation.

### T002 — Identify Jira site, board, sprint, and configuration owner

**Depends on:** T001
**Acceptance criteria:**

- Approved Jira Cloud site URL, numeric Amplify board ID, board filter behavior, and active-sprint selection rule are documented.
- The owner and authorized change process for board, field, status, and environment configuration are documented.
- Configuration validation and promotion between environments have an agreed procedure.

### T003 — Define sprint membership and scope-change behavior

**Depends on:** T002
**Acceptance criteria:**

- The specification defines inclusion/exclusion for issues added or removed during a sprint, moved issues, subtasks, duplicates, and cancelled work.
- It states whether calculations use current scope, committed baseline scope, or both.
- Each supported scope-change case has an expected count, estimate, burndown, and risk outcome.

### T004 — Define issue status and count semantics

**Depends on:** T002, T003
**Acceptance criteria:**

- Completed, remaining/open, blocked, and unmapped status/flag categories are explicitly defined.
- Category overlap, precedence, and unmapped status behavior are specified.
- Completed and remaining issue-count formulas are documented, including how blocked issues contribute.

### T005 — Define story-point field and estimate policy

**Depends on:** T002, T003, T004
**Acceptance criteria:**

- The Jira story-point field identifier and accepted numeric precision/range are documented.
- Null, missing, malformed, and otherwise unusable estimates have defined display and aggregation behavior.
- Completed and remaining story-point formulas have fixture examples that reconcile to expected Jira totals.

### T006 — Define burndown data source and calculation

**Depends on:** T003, T005
**Acceptance criteria:**

- The source and completeness requirements for actual remaining-work data are specified.
- The ideal burndown formula, daily sampling cut-off/timezone, non-working-day treatment, and effect of scope changes are specified.
- Missing daily points and zero-ideal comparisons have explicit behavior.
- The >20% and two-consecutive-daily-point rule has boundary examples with expected results.

### T007 — Define near-end risk calendar and qualifying work

**Depends on:** T002, T003, T004
**Acceptance criteria:**

- The business timezone, working-day/holiday calendar, sprint-end inclusivity, and date-boundary arithmetic are documented.
- The exact statuses and scope conditions that qualify as open work are specified.
- Examples at more than two, exactly two, one, and zero working days before sprint end have expected risk results.

### T008 — Decide user-specific versus shared data and processing

**Depends on:** T002
**Acceptance criteria:**

- The Jira authorization principal for every request, background refresh, risk evaluation, and email is documented.
- Snapshot/cache, freshness, and risk-state isolation rules are documented for users with different Jira permissions.
- Any shared data is proven not to disclose information unavailable to a viewer or notification recipient.
- No service-account access or permission broadening is introduced without explicit approval.

### T009 — Approve SSO, Jira OAuth, and session lifecycle

**Depends on:** T008
**Acceptance criteria:**

- Approved SSO provider/protocol and Jira OAuth flow/scopes/callback URLs are documented.
- Identity linking, callback state and redirect validation, session/cookie policy, CSRF protection, logout, token refresh, expiration, revocation, and disconnect behavior are specified.
- Security and identity owners approve the flow and test-account strategy.

### T010 — Define risk-condition identity and notification semantics

**Depends on:** T004, T006, T007, T008
**Acceptance criteria:**

- A stable condition identity and scope are defined for blockers, burndown risk, and near-end risk.
- Activation, continued state, resolution, reappearance, and material-change transitions are specified.
- The meanings of “new,” “same condition,” and “immediately” have measurable acceptance thresholds.

### T011 — Approve email delivery and recipient contract

**Depends on:** T008, T010
**Acceptance criteria:**

- The approved provider and recipient-resolution source for the Product Owner and Scrum Master are named.
- Message content, sensitivity, recipient authorization expectations, and per-recipient outcomes are specified.
- Timeout, retry, idempotency, outbox/dead-letter, concurrency, and manual recovery behavior are approved.

### T012 — Approve refresh, API, persistence, and operational requirements

**Depends on:** T008, T009, T010, T011
**Acceptance criteria:**

- “While in use,” refresh ownership, user/shared scheduling, freshness limit, maximum alert latency, timeout, backoff, and Jira rate-limit policy are documented.
- API error envelope, status/error codes, partial-data behavior, and stale-data display policy are defined.
- Persistence scope, secret manager, token encryption/key ownership, retention/deletion, audit, backups, hosting, monitoring, and operational ownership are approved.
- Performance, availability, concurrency, browser support, accessibility, and recovery targets are measurable or explicitly deferred from V1 acceptance.
- All decisions are reflected in `spec/specification.md`, and specification owners approve the implementation-ready revision.

**Phase 0 gate:** T001–T012 complete. No implementation task that accesses Jira, stores production credentials, or implements user-visible product behavior may begin before this gate.

## Phase 1 — Development and Verification Foundation

### T013 — Verify and align workspace runtime baseline

**Depends on:** T012
**Acceptance criteria:**

- The frontend dependency resolves to React 18 with Vite and the API uses Node.js with Express, as required by the constitution.
- Root workspace scripts and package engines are documented and compatible with the supported Node version.
- Typecheck, lint, build, and test commands can be run through repository scripts or documented equivalent commands.

### T014 — Provide local PostgreSQL 15 Docker environment

**Depends on:** T012
**Acceptance criteria:**

- A documented Docker Compose setup starts PostgreSQL 15 with a health check and named persistent volume.
- Local credentials are non-production values and are not committed as real secrets.
- Documented start, readiness-check, stop, and reset procedures work on a clean developer machine.

### T015 — Establish migration and database test foundation

**Depends on:** T014
**Acceptance criteria:**

- A versioned migration tool is selected and its commands are documented.
- CI can apply migrations to an empty PostgreSQL 15 instance and report failure with a nonzero result.
- No speculative product schema is added before the data model in T018 is approved.

### T016 — Establish automated test and CI gates

**Depends on:** T013, T014
**Acceptance criteria:**

- Frontend, backend, API, and database integration test conventions and commands are documented.
- CI or the repository's equivalent runs lint, typecheck, tests, and production builds.
- PostgreSQL integration tests use an isolated PostgreSQL 15 test instance and do not require production credentials.

### T017 — Verify secret and artifact exclusions

**Depends on:** T013, T014
**Acceptance criteria:**

- `.gitignore` excludes local secrets, database data/volumes, generated build output, and transient test artifacts.
- A safe example configuration contains placeholders only.
- A repository scan confirms that no real credentials or tokens are introduced by the setup.

**Phase 1 gate:** T013–T017 complete. Local development and CI are repeatable without production credentials.

## Phase 2 — Architecture and Contracts

### T018 — Define typed dashboard API contracts

**Depends on:** T012, T013
**Acceptance criteria:**

- Versioned JSON schemas/types cover sprint metadata, counts, points, burndown, blockers/risks, freshness, and loading/empty/error/partial states.
- Error codes and HTTP status mapping are documented with example payloads.
- Contract examples define missing sprint, missing Jira authorization, denied board access, rate limit, partial data, and stale snapshot behavior.

### T019 — Define trusted identity and authorization interfaces

**Depends on:** T009, T012, T018
**Acceptance criteria:**

- Backend middleware provides a documented authenticated principal and Jira authorization context to downstream services.
- Every Jira-backed endpoint has an explicit authorization requirement.
- Tests or contract checks demonstrate that caller-supplied identity cannot override the authenticated principal.

### T020 — Define Jira integration client contract

**Depends on:** T002, T008, T012, T018
**Acceptance criteria:**

- Jira client interfaces specify required operations and permission context.
- Pagination, timeout, rate-limit, authorization, partial-response, and service-error behavior are documented.
- Request/response logging rules explicitly redact tokens and sensitive issue/page content.

### T021 — Approve persistence schema and data lifecycle

**Depends on:** T003, T008, T010, T011, T012, T015, T018
**Acceptance criteria:**

- Entity relationships cover only approved user references, refresh/snapshot state, condition transitions, and notification delivery state.
- Every persisted field has an approved purpose, access scope, and retention/deletion behavior.
- Constraints and transaction boundaries prevent invalid state and duplicate active condition/notification work.
- Sensitive OAuth credentials are assigned to the approved secret store or have an explicitly approved protected-storage design.

### T022 — Define validated application configuration

**Depends on:** T002, T004, T005, T007, T009, T011, T012
**Acceptance criteria:**

- Configuration schema covers board/site identity, field/status mappings, risk calendar/thresholds, OAuth/provider settings, and environment-specific values as approved.
- Invalid or incomplete configuration fails visibly during startup or configuration update; it does not silently produce empty metrics or disabled rules.
- Configuration changes are authorized, auditable, and promotable according to the approved ownership process.

### T023 — Define audit and observability contracts

**Depends on:** T009, T011, T012
**Acceptance criteria:**

- Required operational and security audit events, correlation identifiers, severity, and retention are documented.
- Log schemas exclude credentials, OAuth tokens, and prohibited Jira content.
- Tests or scanning checks detect known secret/token patterns in logs and application output.

### T024 — Record architecture decisions

**Depends on:** T018, T019, T020, T021, T022, T023
**Acceptance criteria:**

- Reviewed decisions cover permission-isolated caching, refresh ownership, notification reliability, token storage, migration strategy, and deployment boundaries.
- Each decision records context, selected approach, alternatives considered, and consequences.
- The plan and specification references agree with the approved decisions.

**Phase 2 gate:** T018–T024 complete and reviewed before feature integration work.

## Phase 3 — Secure Identity and Jira Authorization

### T025 — Implement company SSO session

**Depends on:** T019, T022, T024
**Acceptance criteria:**

- Protected dashboard APIs reject requests without a valid SSO session.
- Session creation, expiry, logout, cookie settings, CSRF controls, and failure states match the approved identity contract.
- Automated tests cover anonymous access, expired session, logout, invalid callback/state, and CSRF-relevant behavior as applicable.

### T026 — Implement Jira OAuth lifecycle

**Depends on:** T019, T020, T022, T024
**Acceptance criteria:**

- Jira authorization uses only approved scopes and validated redirect/callback state.
- Tokens are stored only in the approved protected backend store and are never returned to the client or written to logs.
- Expiration, refresh, revocation, disconnect, and provider failure states are handled according to the approved contract.

### T027 — Enforce identity linking and per-user authorization

**Depends on:** T025, T026
**Acceptance criteria:**

- Company identity is linked to Jira identity according to the approved matching/confirmation policy.
- Every Jira-backed request uses the authorized user context.
- Automated cross-user tests prove that one user cannot retrieve another user's Jira connection, snapshot, risk state, or data.

**Phase 3 gate:** T025–T027 pass identity/security tests before live Jira data is exposed.

## Phase 4 — Jira Data Pipeline and Metrics

### T028 — Implement resilient Jira API client

**Depends on:** T020, T026, T027
**Acceptance criteria:**

- Client handles approved pagination, timeouts, rate limits/backoff, expired authorization, access denial, and service failures.
- Sensitive request/response data and credentials are redacted from logs.
- Unit tests cover success and each specified Jira failure class.

### T029 — Resolve board and active sprint

**Depends on:** T002, T003, T008, T020, T022, T028
**Acceptance criteria:**

- Client resolves only the configured Amplify board and approved active-sprint rule using the caller's authorization.
- No-active-sprint and access-denied results are distinct typed outcomes.
- Tests prove another board or sprint is not used as a fallback.

### T030 — Map sprint scope, statuses, and estimates

**Depends on:** T003, T004, T005, T022, T028, T029
**Acceptance criteria:**

- Issue membership and scope changes follow approved rules.
- Status categories and precedence match approved configuration.
- Missing/malformed estimates are represented according to policy without silently altering totals.
- Fixture tests cover scope changes, unmapped statuses, duplicate/subtask cases, and estimate edge cases.

### T031 — Calculate sprint summary metrics

**Depends on:** T018, T029, T030
**Acceptance criteria:**

- Completed and remaining issue counts and story-point totals use approved formulas.
- Results match approved Jira fixture data and reconcile per the spec.
- Missing or partial inputs produce explicit limitations and do not look like valid zero values.

### T032 — Build actual and ideal burndown series

**Depends on:** T006, T021, T028, T030, T031
**Acceptance criteria:**

- Actual points use the approved source, daily cut-off, timezone, and completeness rule.
- Ideal series uses the approved formula and work calendar.
- Missing points, scope changes, non-working days, and zero-ideal behavior match the clarified rules.
- Tests include comparison boundaries around the >20% threshold and consecutive-day requirement.

**Phase 4 gate:** T028–T032 pass fixture and permission-isolation tests.

## Phase 5 — Blocker and Risk Evaluation

### T033 — Classify explicit Jira blockers

**Depends on:** T004, T022, T030
**Acceptance criteria:**

- Blocker classification uses approved status and/or flag mappings.
- Invalid or missing mappings are surfaced as configuration/data errors, not as “no blockers.”
- Blocker state is distinct from inferred risk state in the domain and API models.

### T034 — Evaluate burndown and near-end risks

**Depends on:** T006, T007, T030, T032, T033
**Acceptance criteria:**

- Burndown risk follows the approved threshold, daily samples, missing-point, and zero-ideal rules.
- Near-end risk follows the approved work calendar, timezone, boundary arithmetic, and qualifying open-work definition.
- Table-driven tests cover all decision boundaries and unavailable-data cases.

### T035 — Persist condition lifecycle safely

**Depends on:** T010, T021, T033, T034
**Acceptance criteria:**

- Condition identity and scope match the approved notification model.
- Activation, continued presence, resolution, reappearance, and material change are persisted correctly.
- Database constraints/transactions and concurrent-evaluation tests prevent duplicate active condition transitions.

**Phase 5 gate:** T033–T035 provide deterministic, tested risk state and condition transitions.

## Phase 6 — Refresh and Notifications

### T036 — Implement refresh scheduling and coordination

**Depends on:** T008, T012, T020, T021, T024, T029
**Acceptance criteria:**

- Refresh owner, activation (“in use”), interval, authorization context, and concurrency model match approved decisions.
- Concurrent workers/users do not cause uncontrolled duplicate Jira reads or bypass permission isolation.
- Timeout, backoff, rate-limit, partial-response, and maximum-staleness behaviors are tested.

### T037 — Track freshness and refresh failures

**Depends on:** T018, T021, T036
**Acceptance criteria:**

- Last successful refresh is persisted and exposed in the approved scope (per-user or safely shared).
- Failed/partial refreshes retain accurate last-success time and produce explicit stale/error states.
- Old snapshots are never labeled current after a failed refresh or revoked permission.

### T038 — Implement notification outbox and deduplication

**Depends on:** T010, T011, T021, T035
**Acceptance criteria:**

- A new qualifying condition produces one durable notification work item.
- Continued conditions do not enqueue repeat notifications; resolution and reappearance follow approved behavior.
- Concurrent workers, restart recovery, and timeout-after-provider-acceptance cases are tested against the approved idempotency strategy.

### T039 — Integrate approved email provider

**Depends on:** T011, T023, T038
**Acceptance criteria:**

- Provider credentials are loaded from the approved secret store, never from committed configuration.
- Recipients and content follow the approved privacy and authorization rules.
- Per-recipient success/failure is recorded; retry and dead-letter/manual-recovery paths are observable.

**Phase 6 gate:** T036–T039 meet approved freshness and alert-delivery objectives without duplicate successful sends.

## Phase 7 — Dashboard and End-to-End Verification

### T040 — Implement dashboard shell and navigation

**Depends on:** T013, T018, T025
**Acceptance criteria:**

- React 18/Vite frontend has the approved desktop/laptop layout and protected-route behavior.
- User can distinguish signed-out, Jira-not-authorized, loading, empty, and access-denied states.
- Frontend accesses application data only through the documented backend API.

### T041 — Render sprint summary and progress metrics

**Depends on:** T018, T031, T037, T040
**Acceptance criteria:**

- Sprint goal/date, completed/remaining counts, and point totals render with clear labels.
- API missing/partial/stale states are represented without converting unavailable values to zero.
- Component tests verify representative normal, empty, and error responses.

### T042 — Render burndown, blockers, and risks

**Depends on:** T018, T032, T033, T034, T040
**Acceptance criteria:**

- Actual and ideal burndown are readable and include an accessible text summary.
- Explicit blockers and inferred risks are visually and textually distinct and do not rely on color alone.
- No embedded issue list is rendered; any detail link leads to Jira according to approved access rules.

### T043 — Complete accessibility and browser verification

**Depends on:** T040, T041, T042, T012
**Acceptance criteria:**

- Agreed browser/version and viewport matrix passes.
- Keyboard operation, focus order, accessible names, chart descriptions, contrast, and loading/error announcements meet approved conformance criteria.
- Manual review findings are recorded and blocking issues resolved.

### T044 — Run integrated acceptance suite

**Depends on:** T025–T043
**Acceptance criteria:**

- End-to-end tests cover SSO/Jira authorization, user isolation, summary metrics, risks, freshness, and notifications using approved test doubles and PostgreSQL 15 in Docker.
- SC-001 through SC-010 each have linked automated/manual evidence or an explicitly approved deferral.
- Jira/email failure and recovery paths do not expose credentials or present misleading current data.

**Phase 7 gate:** T040–T044 complete; no unapproved scope or issue-list behavior is present.

## Phase 8 — Production Readiness and Release

### T045 — Complete security, privacy, and data governance review

**Depends on:** T044
**Acceptance criteria:**

- Security review covers authentication, OAuth, permissions, cross-user isolation, secret handling, log redaction, API exposure, and notification data.
- Retention, deletion, audit, key management, database access, and backup policies are approved and verified.
- No unresolved release-blocking security or privacy findings remain.

### T046 — Prepare deployment, operations, and recovery

**Depends on:** T044
**Acceptance criteria:**

- Approved hosting, TLS, secret injection, monitoring, alerting, and audit collection are configured.
- Runbooks cover deploy/rollback, migrations, Jira/email outages, rate limiting, credential rotation, worker restart, backup restore, and escalation.
- Approved performance, availability, and recovery objectives are measured and met.

### T047 — Obtain release approval and deploy

**Depends on:** T045, T046
**Acceptance criteria:**

- Product, security, identity, Jira administration, email, and operations owners sign off.
- Production migrations and smoke tests complete successfully.
- Deployment and rollback evidence is recorded; operational ownership is accepted.

## Traceability and Completion Rules

- Link implementation changes and tests to task IDs and the applicable FR/SC identifiers in `spec/specification.md`.
- A task may be marked complete only when all its acceptance criteria have evidence in tests, reviewed artifacts, or approvals.
- A blocked task must identify the unresolved decision and responsible approver; do not replace an open decision with an undocumented assumption.
- If an approved clarification changes behavior, update the specification and this task list before continuing dependent work.
