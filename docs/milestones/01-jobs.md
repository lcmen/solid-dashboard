# Milestone 1: Jobs and shared foundation

## Goal

Build the shared dashboard foundation and a complete Jobs page based on the prototype.

## Depends on

Current Rails engine skeleton.

## Deliverables

- Add the shared responsive layout, minimal sidebar, accessible controls, and compact metric strips.
- Package browser-ready CSS and JavaScript in conventional engine asset directories. Support Propshaft and Sprockets hosts; register standalone assets for Sprockets precompilation. Use standard Rails asset helpers and let the host pipeline handle fingerprints and publication. The host must not need dashboard frontend compilation. Follow the [asset decision](../adr/0001-use-host-asset-pipeline.md).
- Detect Solid Queue and Solid Cache independently. Show clear states for missing tables, missing backends, and unsupported versions.
- Verify and document the supported Solid Queue versions, schemas, status definitions, and retry/discard operations against upstream source.
- Show job counts, paginated jobs, class and ID search, status and queue filters, details, and execution history where records exist.
- Support confirmed retry and discard for individual failed jobs only. Use the supported Solid Queue operations, correct HTTP verbs, CSRF protection, action validation, and observable operation logging.
- Show escaped job arguments on the detail page. Keep exception messages and traces hidden. Never execute job payloads to render the page. The host must restrict access to sensitive data.

## Complete when

Realistic Solid Queue fixtures cover state classification, filters, pagination, details, and execution history. Tests cover CSRF, retry and discard effects, sensitive data, backend absence, and the Jobs page. Host authentication and authorization at the mount remain required; access-check changes and tests are deferred as recorded in the [implementation plan](01-jobs-plan.md). The packaged gem renders assets through Propshaft and Sprockets at root and nested engine mount paths without a dashboard compiler in the host.
