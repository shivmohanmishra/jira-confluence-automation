# Specification Implementation Checklist

**Reviewed:** 2026-10-12
**Specification:** `spec/specification.md`
**Review scope:** Current files under `apps/` and `tests/`, app package manifests, and available local verification.

## Triage of Previously Unchecked Items

### Implemented now

- **React 18 baseline:** This was a clear, unambiguous compliance gap. Frontend runtime dependencies now use React/React DOM 18.3.1 and React type packages 18.3.0. The frontend production build passes with those versions. This corrects the technical baseline only; it does not implement dashboard behavior.

### Real gaps, blocked from implementation

Every item below is a real missing or incomplete capability, not minor polish. Do not implement it by guessing: the task plan gates product behavior on unresolved Phase 0 decisions (T002–T012). Resolve the relevant decision, update the specification/contracts, then implement and verify the behavior.

- **Authentication, Jira access, and safe states:** FR-001, FR-002, FR-003, FR-004, FR-005, FR-006.
- **Sprint identification, metrics, estimates, and burndown:** FR-007, FR-008, FR-009, FR-010, FR-011, FR-012, FR-013, FR-014.
- **Blockers, risk rules, and configuration:** FR-015, FR-016, FR-017, FR-018, FR-019, FR-020.
- **Email, deduplication, persistence, and retries:** FR-021, FR-022, FR-023, FR-024, FR-025, FR-026.
- **Refresh, freshness, and integration failures:** FR-027, FR-028, FR-029, FR-030, FR-031.
- **API data path and database:** FR-032 (partial), FR-033 (partial), FR-034, FR-035.
- **End-to-end outcomes:** SC-001, SC-002, SC-003, SC-004, SC-005, SC-006, SC-007, SC-008 (only vacuously true of the placeholder; dashboard compliance is unverified), SC-009, SC-010.
- **Quality attributes:** least privilege and identity isolation; privacy/data minimization; explicit integration failures and safe retries; freshness states; database integrity; product accessibility; compliant operational logging; summary-only Jira behavior.
- **Failure behavior:** All cases listed in “Edge Cases and Failure Behavior” remain real, unimplemented verification gaps.

The React correction also resolves the specific baseline issue in the compatibility row below. All other feature gaps remain unimplemented; passing scaffold builds or a health check is not evidence that any of them work.

### Out of scope — do not implement for this release

- Confluence operations; multiple teams, boards, or Jira projects; historical/cross-sprint analytics; embedded issue lists; Jira issue editing; Slack notifications.
- A future Confluence feature requires its own reviewed specification, authorization scope, and acceptance criteria.

These exclusions are product scope decisions, not implementation defects. The dashboard's “no embedded issue list” constraint (SC-008) still applies to any future dashboard UI.

### Nice to have

- Replace the generic HTML document title (`web`) with the approved product title and polish browser metadata. This is presentation polish, not a functional requirement, and is deferred until the dashboard UI is implemented.

## Summary

The current repository is a runnable development scaffold, not an implementation of the Jira sprint dashboard. The API contains only a health endpoint; the frontend renders a placeholder message; there is no application test suite, Jira/SSO/email integration, database schema or migration, or Docker Compose configuration.

| Verification | Result | Evidence |
|---|---|---|
| API TypeScript build | Pass | `apps/api`: `npm run build` completed successfully using the installed Node.js 24.21.0 runtime. |
| API health smoke test | Pass | Started the built API and received `{"status":"ok"}` from `GET /api/health` (HTTP 200). This verifies only the health endpoint. |
| Frontend production build | Pass | `apps/web`: `npm run build` completed successfully with Vite 8.3.4. |
| Workspace TypeScript checks | Pass | `npm run typecheck --workspaces --if-present` completed for API and frontend. |
| Frontend lint | Pass | `apps/web`: `npm run lint` completed successfully. |
| React baseline | Pass | Resolved workspace dependencies are React/React DOM 18.3.1 with React type packages 18.3.0. |
| Frontend serving/UI smoke test | Pass for scaffold only | Vite returned HTTP 200. Browser inspection showed a heading and the message “Frontend is running. Jira integration is not configured yet.” |
| Automated product tests | Not available | No test files or app-level test scripts were found; `tests/` contains only `.gitkeep`. |
| PostgreSQL/Docker verification | Not available | No Docker Compose configuration, migration, or database integration test is present. |

**Overall:** No functional requirement is fully implemented and verified. FR-032 and FR-033 have limited scaffold-level pieces only. Passing builds and the health/UI smoke tests do not establish that dashboard requirements work.

## Functional Requirements

| Requirement | Implemented? | Does it work? / evidence |
|---|---|---|
| FR-001 — Require company SSO before protected data | No | No authentication or protected dashboard route is implemented. |
| FR-002 — Per-user Jira OAuth authorization | No | No OAuth flow or Jira data request is implemented. |
| FR-003 — Enforce identity and Jira authorization on each Jira request | No | No Jira-backed request or authorization middleware exists. |
| FR-004 — Restrict queries to configured Amplify board and active sprint | No | No board configuration or Jira query exists. |
| FR-005 — Keep OAuth secrets/tokens out of browser, source, and logs | No | No credential lifecycle or secret-store integration exists; the security guarantee is not implemented or end-to-end verified. |
| FR-006 — Show signed-out, unlinked, expired/revoked, and no-board-access states | No | The frontend has only a generic development placeholder. |
| FR-007 — Identify the active Amplify sprint | No | No sprint lookup or dashboard data API exists. |
| FR-008 — Show sprint goal and end date when supplied | No | No sprint data is retrieved or rendered. |
| FR-009 — Show a clear no-active-sprint state without substituting another sprint | No | No sprint state handling exists. |
| FR-010 — Show completed and remaining issue counts | No | No issue retrieval or count calculation exists. |
| FR-011 — Show completed and remaining story-point estimates | No | No estimate retrieval or aggregation exists. |
| FR-012 — Explicitly handle missing/unusable estimates | No | No estimate policy or metric calculation exists. |
| FR-013 — Show actual and ideal burndown | No | No burndown source, calculation, API, or visualization exists. |
| FR-014 — Make burndown accessible and not color-dependent | No | No chart or equivalent text summary exists. |
| FR-015 — Identify explicit blockers from configurable Jira mappings | No | No mapping/configuration or blocker classification exists. |
| FR-016 — Distinguish explicit blockers from inferred risks | No | No blocker/risk model or corresponding UI exists. |
| FR-017 — Detect the specified burndown risk | No | No risk calculation exists; zero-ideal behavior is also unresolved in the specification. |
| FR-018 — Detect near-end risk using an approved calendar/timezone | No | No calendar, timezone, open-issue rule, or risk calculation exists; the calendar decision remains open. |
| FR-019 — Show current risk state and its type | No | No risk state or dashboard display exists. |
| FR-020 — Centrally configure and validate mappings/risk settings | No | No runtime configuration schema or validation exists. |
| FR-021 — Email configured recipients on first detection | No | No condition detection or email provider integration exists; recipient/provider choices remain open. |
| FR-022 — Suppress repeat notifications while a condition continues | No | No condition lifecycle, notification state, or deduplication exists. |
| FR-023 — Permit a new notification after resolution and reappearance | No | No persisted condition transitions exist. |
| FR-024 — Persist notification state and delivery attempts | No | No PostgreSQL integration or notification persistence exists. |
| FR-025 — Protect retries against duplicate email delivery | No | No outbox, idempotency, retry, or provider integration exists. |
| FR-026 — Configure approved provider and recipient resolution | No | No provider/configuration or recipient-resolution implementation exists; these decisions remain open. |
| FR-027 — Refresh Jira data every 15 minutes while in use | No | No refresh scheduler, Jira data path, or defined “in use” behavior exists. |
| FR-028 — Display last successful refresh time | No | No refresh metadata or UI exists. |
| FR-029 — Display failed/partial refresh as stale or erroneous | No | No refresh state, snapshot, or error UI exists. |
| FR-030 — Handle Jira rate limits, authorization changes, and partial/transient failures | No | No Jira client or integration error handling exists. |
| FR-031 — Coordinate refresh and notification work | No | No scheduler, worker coordination, or notification processing exists. |
| FR-032 — Frontend obtains app data through backend APIs, not Jira/Confluence/DB | Partial | The frontend makes no Jira/Confluence/DB calls, and Vite has an `/api` proxy; however, it does not fetch dashboard data and the API exposes only `/api/health`. The required application data path is absent. |
| FR-033 — Validate backend inputs and return classified errors | Partial | The static health endpoint returns JSON, but no application inputs or domain endpoints exist to validate or classify. |
| FR-034 — Persist only approved state in PostgreSQL 15 | No | No database client, schema, or persistence is implemented. |
| FR-035 — Use versioned migrations, constraints, and transactions | No | No migration tooling, migrations, database constraints, or transactional application behavior exists. |

## Success Criteria

| Criterion | Implemented? | Does it work? / evidence |
|---|---|---|
| SC-001 — Authorized user completes SSO/Jira authorization and opens dashboard | No | No sign-in or Jira authorization flow. |
| SC-002 — Show configured active sprint, goal, and end date | No | No Jira integration or sprint UI. |
| SC-003 — Metrics match authorized Jira scope, including missing estimates | No | No metrics implementation or comparison tests. |
| SC-004 — Show actual and agreed ideal burndown | No | No burndown implementation. |
| SC-005 — Distinguish blockers and risks and apply approved rules | No | No blocker/risk implementation; several rules remain undecided. |
| SC-006 — Send one email per eligible condition transition | No | No notification lifecycle or email integration. |
| SC-007 — Refresh every 15 minutes and show freshness/failure state | No | No refresh implementation or UI. |
| SC-008 — Do not embed issue list; leave issue inspection in Jira | Partial | The placeholder contains no issue list, but it is not a functioning dashboard and provides no Jira inspection flow. |
| SC-009 — No Jira/Confluence credentials in delivered code, API, source, or logs | No — not verified end-to-end | No credential integration exists, but the required source/bundle/API/log guarantee and automated verification have not been implemented. |
| SC-010 — Automated tests cover rules, authorization, database, and integration failures | No | No automated app tests or test doubles were found. |

## Quality Attributes and Constraints

| Specification area | Implemented? | Does it work? / evidence |
|---|---|---|
| Least privilege, identity isolation, and secure token handling | No | No identity, authorization, Jira, or token implementation exists. |
| Data minimization and cross-user/tenant privacy | No | There is no data flow to assess or enforce. |
| Explicit integration failures and safe retries | No | No external integration clients or retry paths exist. |
| Freshness and stale/partial/unavailable distinctions | No | No dashboard data or freshness model exists. |
| PostgreSQL integrity and transaction behavior | No | No database configuration/schema exists. |
| Keyboard operation, accessible labels, and status/error states | No | Only a basic placeholder is rendered; product accessibility behavior is absent. |
| Technical baseline: React 18 + Vite, Node.js + Express, PostgreSQL 15 | Partial | React/React DOM 18.3.1, Vite, and Express are present, but PostgreSQL 15/Docker setup is absent. |
| Summary-only scope and Jira as source of truth | Not assessable as product behavior | No Jira or dashboard functionality exists. No Confluence/Slack integration was found in the inspected app source, but this is not evidence of a completed dashboard. |
| Redacted, useful operational logging | No | No integration logging or redaction policy is implemented; the API only logs its startup URL. |

## Edge Cases and Failure Behavior

None of the feature-specific cases below has an implementation or test. There is no basis to claim they work:

- No active sprint; signed in without Jira authorization; expired/revoked authorization; missing board permission.
- Missing/malformed board, goal/date, estimate, status mapping, or blocker flag.
- Unmapped statuses and incomplete Jira pages/responses.
- Zero ideal burndown, non-working days, holidays, sprint-end boundaries, or timezone changes.
- Rate limits, timeouts, Jira service failures, or a failed refresh after a successful snapshot.
- Email failure before/after provider acceptance, concurrent condition detection, or crash/restart during delivery.
- A condition resolving and reappearing between refreshes.

## Verification Notes and Follow-Up

- The API build and `GET /api/health` smoke test work; this is infrastructure-only behavior, not proof of Jira dashboard requirements.
- The frontend build and HTTP serving work; browser inspection confirms it currently renders a development placeholder, not the specified dashboard.
- The frontend React dependency mismatch has been corrected to React 18.3.1 and the production build passes. PostgreSQL/Docker setup remains absent.
- No app-level tests, Docker Compose file, PostgreSQL setup, or schema migrations were available to run.
- The specification itself remains Draft and identifies implementation-blocking open decisions, including Jira site/board identity, field/status semantics, SSO/OAuth, notification provider/recipients, business calendar, burndown calculation, and operational policies. Requirements depending on these decisions cannot be fully accepted until they are resolved and recorded.
- This checklist records current implementation evidence only. It does not change the specification's open requirements or imply product-owner acceptance.
