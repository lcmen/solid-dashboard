# AGENTS.md — Solid Dashboard

## Project

Solid Dashboard is a mountable Rails engine that presents Solid Queue and Solid Cache in one administration interface. Use these projects as references for behavior and available data:

- https://github.com/akodkod/solid-queue-dashboard
- https://github.com/afomera/solid_cache_dashboard
- https://github.com/rails/mission_control-jobs

Do not depend on either dashboard gem at runtime unless a deliberate architectural decision changes this rule. Integrate with Solid Queue and Solid Cache directly, keeping compatibility with supported versions explicit and tested.

The current visual reference is `design.html`. Treat it as a prototype, not production implementation or a source of real data.

## Principles

1. Prefer Rails conventions and straightforward, readable code over abstractions and metaprogramming.
2. Use the host application's Propshaft or Sprockets asset pipeline. Keep dashboard frontend compilation inside gem development.
3. Display only information supported by the underlying tables or by the cache instrumentation implemented in the reference gem. Do not invent metrics, statuses, or historical data.
4. Keep dependencies small. Avoid introducing new persistent tables or background jobs unless a feature requires them.
5. Make operational actions safe, authenticated, authorized, and observable.
6. Write concise documentation and comments in simplified English. Explain decisions, not obvious code.

## Scope

### Queue

- Job counts and states: pending, scheduled, running, finished, failed, and retried, following the reference gem's definitions.
- Job list, filters, details, and execution history where records exist.
- Queue activity charts based on existing timestamps and executions.
- Worker, dispatcher, scheduler, and supervisor process records and heartbeat status.
- Recurring tasks and supported job operations, including retry where appropriate.

### Cache

- Current cache entries, keys, size, and available entry metadata.
- Hit, miss, write, and delete events, when instrumentation is enabled.
- Hit ratio and operation charts derived from recorded cache events.
- Entry inspection and deletion, subject to authorization.

Cache analytics require instrumentation because Solid Cache does not store historical hit/miss events by default. Make this requirement visible in the UI. Do not silently interpret missing event data as zero activity. Bound event retention and review instrumentation overhead.

### Out of scope for now

- Queue latency and other new derived performance metrics.
- Period-over-period comparisons, percentage deltas, or trend annotations not provided by the reference logic.
- Historical cache storage trends and storage snapshots.
- Claims about past system health without retained historical records.
- Additional monitoring infrastructure, metrics stores, and synthetic data in production views.

## UI and interaction

- Follow https://sailboatui.com/ for Tailwind component structure, typography, spacing, borders, tables, forms, and buttons.
- Use a restrained, neutral administration aesthetic. Prefer white surfaces, subtle borders, and blue primary accents.
- Do not render a global top bar or breadcrumbs.
- Sidebar branding is only the Solid Dashboard icon and name. Do not add a subtitle, environment panel, Rails version, or demo-data note to the sidebar.
- Use compact metric strips: a single bordered container with adjacent values separated by subtle dividers, not tall individual KPI cards.
- Reserve status colors for meaningful operational conditions, particularly failures.
- Use accessible semantic HTML, labeled controls, visible focus states, responsive layouts, and confirmation for destructive operations.
- Match the established prototype's information architecture unless a requested change justifies a redesign.

## Assets

- Ship production-built CSS and JavaScript inside the gem.
- Require Propshaft or Sprockets in the host application. The host must not need Importmap, Vite, Node.js, or Tailwind compilation for the dashboard.
- The gem may use Tailwind and Alpine.js or Stimulus at development/build time; package the resulting browser-ready assets.
- Use conventional engine asset paths and standard Rails asset helpers. Register standalone assets for Sprockets precompilation. Let the host pipeline handle fingerprints, manifests, and publication; support an engine mounted at a subpath.
- Avoid loading runtime assets from CDNs.
- Do not duplicate a global Tailwind build or stylesheet in the host application.

## Backend design

- Keep controllers thin. Separate querying, filtering, formatting, and operational mutations where doing so improves clarity.
- Use Solid Queue and Solid Cache's established models and relationships, but verify behavior against the supported gem versions.
- Respect the host application's configured Queue and Cache database connections; do not assume they use the primary database.
- Paginate large tables, use bounded chart intervals, and avoid unbounded counts or N+1 queries.
- Keep dashboard reads read-only; isolate write operations in explicit endpoints.
- Handle unsupported Solid Queue/Cache versions and missing instrumentation with informative UI states.

## Security

- Require a host-configurable authentication and authorization boundary. Never expose the mounted dashboard publicly by default.
- Protect mutations with CSRF checks and appropriate HTTP verbs. Confirm retry, discard, or cache deletion actions.
- Treat job arguments, exception traces, cache keys, and cached values as potentially sensitive. Escape displayed content and make sensitive-value inspection restricted or disabled by default.
- Never deserialize arbitrary cached values or execute job payloads just to render the interface.

## Tests and validation

- Cover queries and status classification against realistic Solid Queue and Solid Cache fixtures.
- Test cache instrumentation separately, including disabled instrumentation and retention behavior.
- Test permission checks, CSRF protection, mutation effects, and sensitive-data handling.
- Test the engine mounted at both `/` and a nested path with Propshaft and Sprockets hosts. Verify production asset precompilation without host manifest changes or a dashboard compiler.
- Include system tests for navigation, filters, pagination, responsive layouts, empty states, and actions.
- When UI changes, compare the result with the latest approved HTML prototype, including the compact stats layout and minimal sidebar.

## Working rules for agents

- Inspect existing code and tests before changing behavior. Prefer a small, focused patch.
- Verify uncertain API and schema details against the actual supported upstream source instead of guessing.
- Add tests for behavioral changes and run the relevant checks before reporting completion.
- Do not introduce unsupported dashboard metrics to fill empty space.
- Keep implementation and documentation synchronized. Note migration needs, compatibility limits, and any new operational costs.
