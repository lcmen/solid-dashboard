# Milestone 6: First release validation

## Goal

Verify installation, host integration, compatibility, documentation, and packaging for the first release.

## Depends on

Milestones 1 through 5.

## Deliverables

- Validate SQLite hosts with Solid Queue only, Solid Cache only, both backends, or neither. Verify separate primary, Queue, and Cache connections.
- Test the engine mounted at `/` and at a nested path with both Propshaft and Sprockets hosts. Verify asset helper URLs and production asset precompilation without dashboard entries in the host manifest. Confirm the host needs no Importmap, Vite, Node.js, or Tailwind build for the dashboard.
- Verify host authentication protects pages and mutations when the engine is mounted behind the host's chosen boundary. Document mount examples for host-managed access.
- Check navigation, filters, pagination, confirmations, keyboard access, responsive layouts, empty states, and prototype fidelity.
- Document installation, supported Rails and backend versions, SQLite-only validation, host-managed authentication, sensitive-data behavior, and deferred Cache analytics.
- Run relevant tests, Standard Ruby checks, gem loading, and gem build.

## Complete when

The packaged gem passes the documented checks and a host application can mount and use it with Propshaft or Sprockets. The host requires no dashboard frontend compiler. Publishing is a separate release action.
