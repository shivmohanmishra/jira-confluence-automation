# Jira Sprint Progress Dashboard

## Development Setup

Requirements: Node.js 22.12 or later and npm.

If VS Code was open while Node.js was installed through WinGet, run `powershell.exe -ExecutionPolicy Bypass -File .\scripts\setup-node-path.ps1` and restart VS Code so new terminals pick up the PATH update.

Install dependencies from the repository root:

```bash
npm install
```

Start the frontend and API together:

```bash
npm run dev
```

The Vite frontend runs at `http://localhost:5173` and proxies `/api` requests to the API at `http://localhost:3001`.

Run the workspace checks:

```bash
npm run typecheck
npm run build
```

The API currently exposes a local health endpoint at `http://localhost:3001/api/health`. Jira OAuth, company SSO, and external service configuration are not wired into this scaffold.