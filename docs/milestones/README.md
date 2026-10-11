# Solid Dashboard milestones

This directory is a roadmap for planned work based on the [design prototype](../design-bootboat.html). The current app provides the shared layout and navigation; its pages do not yet read or change Solid Queue or Solid Cache data. The milestones below describe planned work, not features in the current release. Cache event instrumentation and analytics remain future work.

## Milestones

1. [Jobs and shared foundation](01-jobs.md) — engine layout, packaged assets, backend checks, and job inspection and operations.
2. [Processes](02-processes.md) — worker, dispatcher, scheduler, and supervisor records and heartbeat status.
3. [Recurring tasks](03-recurring-tasks.md) — recurring task definitions and schedules.
4. [Cache entries](04-cache-entries.md) — current entry metadata, search, inspection, and deletion.
5. [Overview](05-overview.md) — current Queue and Cache summaries, Queue activity charts, and clear unavailable states for deferred Cache analytics.
6. [First release validation](06-release-validation.md) — host integration, security boundary, compatibility, packaging, and release checks.
7. [Future Cache instrumentation and analytics](07-cache-analytics-deferred.md) — design and build opt-in, retained Cache event data and analytics.
8. [Future Cache events page](08-cache-events-deferred.md) — browse recorded Cache events.

## Shared decisions

- Support Rails 8.0 and 8.1. Use Solid Queue and Solid Cache directly through their Active Record models and configured database connections. Do not add either dashboard reference gem as a runtime dependency.
- Let the host application protect the engine mount with its authentication mechanism. The gem provides no login system, access switch, or permission hooks. Keep CSRF protection, confirmations, and action validation in the engine.
- Validate SQLite only for the first release. Document other database adapters as unverified.
- Package browser-ready CSS and JavaScript in conventional engine asset directories. Require a host asset pipeline: Propshaft or Sprockets. Let the pipeline handle fingerprints, manifests, and asset publication. Register standalone assets in `assets.precompile` for Sprockets so the host does not need to add them to its manifest. See the [asset decision](../adr/0001-use-host-asset-pipeline.md).
- Follow the prototype's information architecture, minimal sidebar, compact metric strips, and responsive administration style. Use only supported data; label missing event data as unavailable rather than zero.
- Do not show cached values. Do not add bulk job operations, dispatch, queue pause or resume, recurring task edits, Solid Cable, invented metrics, or production sample data.

## References

- [Design prototype](../design-bootboat.html)
- [Solid Queue Dashboard](https://github.com/akodkod/solid-queue-dashboard)
- [Solid Cache Dashboard](https://github.com/afomera/solid_cache_dashboard)
- [Mission Control Jobs](https://github.com/rails/mission_control-jobs)
- [Solid Queue](https://github.com/rails/solid_queue)
- [Solid Cache](https://github.com/rails/solid_cache)
