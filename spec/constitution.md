# Project Constitution

## Purpose

This constitution establishes the non-negotiable engineering principles for the Jira/Confluence automation project. Product specifications define feature behavior; implementation plans and code must remain consistent with both the applicable specification and this constitution.

## Core Principles

### 1. Specifications and Acceptance Criteria Come First

- Each feature must have a reviewed specification describing its users, scope, expected behavior, constraints, and verifiable acceptance criteria before implementation begins.
- Resolve material ambiguity in integrations, permissions, data handling, and destructive actions before coding.
- Plans and tests must trace back to the specification. A change in scope or behavior requires updating the specification and affected acceptance criteria.

### 2. Respect Identity, Permissions, and Data Boundaries

- Jira and Confluence requests must use the authenticated user's authorized access and must not broaden that user's permissions.
- The backend is the only application tier permitted to hold integration credentials or call Jira and Confluence APIs. Browser code must never receive OAuth client secrets, access tokens, or refresh tokens.
- Request and persist only data required for an explicitly approved feature. Do not expose one user's or tenant's data to another.
- Store credentials in the approved secret store and protect any persisted sensitive tokens with encryption at rest. Never commit secrets or write them to logs.
- Any automated write to Jira or Confluence must be scoped, auditable, and safe to retry. Destructive or irreversible actions require explicit authorization and must not be inferred from ambiguous input.

### 3. Maintain a Clear Frontend/Backend Boundary

- The frontend uses React 18 with Vite and is responsible for presentation and user interaction.
- The backend uses Node.js with Express and owns authentication callbacks, authorization enforcement, integration clients, business rules, and persistence access.
- The frontend communicates with the backend through documented, typed JSON APIs; it must not connect directly to Jira, Confluence, or PostgreSQL.
- Validate inputs at API boundaries and return explicit, appropriately classified errors rather than success-shaped fallbacks.

### 4. Treat PostgreSQL as the Durable Data Store

- PostgreSQL 15 is the relational database baseline and must be runnable through Docker for local development and repeatable integration testing.
- Database changes must use versioned migrations; avoid untracked schema changes and destructive migration behavior.
- Enforce data integrity with appropriate constraints and transactions. Keep stored data limited to the product's approved purposes and retention requirements.
- Do not assume local Docker configuration is suitable for production; production credentials, persistence, backups, and network access must follow the organization's hosting standards.

### 5. Make Integrations Reliable and Observable

- Jira and Confluence integrations must handle authorization failures, expired credentials, rate limits, timeouts, partial responses, and service errors explicitly.
- Retried operations must be idempotent where possible and must not create duplicate updates, notifications, or records.
- Keep user-facing data freshness and integration failures distinguishable; do not present stale or incomplete data as current.
- Log operational events and correlation information while redacting credentials, tokens, and sensitive issue or page content.

### 6. Verify Behavior and Accessibility

- Add automated tests for business rules, API validation and authorization, database behavior, and integration error cases appropriate to each feature.
- Use mocks or test doubles for external services in routine tests; add integration tests against PostgreSQL 15 in Docker for database-dependent behavior.
- Before completion, run the relevant tests, type checks, linting, and production build defined by the repository.
- User-facing interfaces must support keyboard operation, clear status and error communication, and the accessibility standards adopted by the organization.

## Technical Baseline

- Frontend: React 18 and Vite.
- Backend: Node.js and Express.
- Database: PostgreSQL 15, run through Docker for local development and integration tests.
- External services: Jira Cloud and Confluence APIs, accessed server-side with least-privilege authorization.
- Exact authentication provider, hosting platform, email provider, audit requirements, and data-retention period remain subject to approved project specifications and organizational standards.

## Governance

- This constitution applies to specifications, plans, implementation, reviews, and tests for the project.
- A proposal that conflicts with a principle must document the reason, risk, scope, and mitigation, and receive explicit approval before implementation.
- Amendments must update this document and identify affected specifications, plans, and tests.
- Feature-specific specifications may strengthen these principles but must not silently weaken security, privacy, permission, or data-integrity requirements.
