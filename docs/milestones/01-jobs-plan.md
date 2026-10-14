# Milestone 1: Jobs and shared query foundation

## Summary

Complete the [Jobs milestone](01-jobs.md) from commit `60c95a1f33e919c9da5c9eb18ef90554b23bae3c`. Preserve the existing layout and asset pipeline. Add a shared query foundation, real job browsing, retained execution history, and confirmed retry and discard.

Support Solid Queue 1.7.0 and Solid Cache 1.0.10. Show escaped job arguments on the single-job page. Keep exception messages and traces hidden.

## Shared query foundation

- Add `SolidDashboard::ApplicationQuery` and `SolidDashboard::JobsQuery`. Use ordinary Ruby classes with explicit methods.
- The base constructor accepts `scope:`, `page: 1`, and `per_page: 25`. The scope is an Active Record relation; it determines the model and database connection.
- Provide `call` for a `PaginatedList` of filtered, ordered records. The collection supports iteration, `empty?`, `total`, `pages`, `page`, and `per_page`.
- Normalize invalid pages to 1. Default invalid page sizes to 25 and cap page sizes at 100. Return empty records for pages beyond the result set.
- Use a `build_scope` method for subclass filters and ordering. The base implementation returns the supplied scope. List subclasses must specify stable ordering with a unique tie breaker.
- Keep records lazy and count in SQL. Remember loaded pages and totals only within the collection instance. Do not load all records to filter or paginate.
- Keep backend detection, operational mutations, presentation, job statuses, cache key handling, and feature-specific aggregates outside the base class.
- Later Processes, Recurring tasks, Cache entries, and Cache events query classes can use this interface. Do not implement those pages in this milestone.

## Jobs and backend behavior

- Add independent checks for loaded backends, supported versions, required tables, and database availability through their configured connections. Show informative unavailable states without false zero counts. Preserve existing availability methods for callers.
- `JobsQuery` accepts `q`, `status`, and `queue_name` in addition to the shared arguments. Search class names by literal substring and numeric job IDs by exact match. Combine filters, order by descending job ID, and preserve filters in pagination links.
- Use one status rule for labels, counts, and filters: claimed jobs are Running; failed jobs are Failed; older finished records with a newer record sharing their nonblank Active Job ID are Retried; remaining finished records are Finished; future scheduled jobs are Scheduled; remaining unfinished jobs, including blocked jobs, are Pending.
- Create one `SolidDashboard::App` per request and expose its Jobs facade through `app.jobs`. Provide `find(id)`, `list(q:, status:, queue_name:, page:, per_page:)`, `attempts(job, page:, per_page:)`, and `queues`. Keep inputs explicit and construction free of database queries.
- Extend `SolidQueue::Job` with a read-only dashboard Job model for status classification, status scopes, and the unpaginated attempts relation. Reuse upstream associations and argument serialization. Add a reusable `Preventable` concern with a `prevent` class method to block operational instance methods such as dispatch, retry, and discard. Each model declares its blocked methods. Keep eager loading available when Queue is absent. Move labels, badge classes, and argument formatting to `JobsHelper`; do not use a decorator. Queries return Job models.
- Keep status totals separate from the filtered pagination count. Provide named count methods on the Jobs facade, each with its own status relation and SQL count. Memoize counts and queue choices only within the facade instance. Do not group totals with a CASE expression.
- Add labeled search and filter controls, compact metrics, pagination, and empty states using the existing prototype and Bootboat conventions.
- Add `GET /jobs/:id` for metadata, escaped job arguments, and retained history. Use a normal page with one card: compact metadata first, then the retained-attempts heading and table. Do not use a details modal, metadata list, repeated job title, or refresh button on this page. Paginate related attempts through the shared query foundation, grouped by nonblank Active Job ID. Explain when earlier records are unavailable.
- Add `POST /jobs/:id/retry` and `DELETE /jobs/:id` for individual failed jobs. Require confirmation, validate the failed execution within the backend transaction, and call supported Solid Queue operations. Handle missing records and changed states with clear results.
- Keep CSRF protection and host authentication and authorization at the mount. Log operation names, record IDs, and outcomes without sensitive content. Keep GET requests free of operational mutations.
- Rebuild packaged assets and update documentation for query conventions, compatibility, statuses, security, and retention limits.

## Tests and acceptance

- Test query behavior through concrete query classes, without direct `ApplicationQuery` tests. Keep query result assertions in query tests and HTML assertions in view or system tests. Defer Cache query coverage to its own milestone.
- Start with a small failing batch for the shared query contract, real job browsing, details/history, retry, and discard. Show actual failures and the design for approval before production code changes.
- Use realistic fixtures for status classification, combined filters, pagination, and retained attempt history. Check that labels, counts, and filters agree.
- Harden backend absence, unsupported versions, separate connections, invalid inputs, sensitive-data exclusion, repeated actions, and concurrent state changes.
- Defer access-check changes and access-denial tests at the user's request. The host remains responsible for authentication and authorization at the mount. Explicitly enable CSRF protection in security tests.
- Test navigation, confirmations, keyboard access, responsive layouts, and empty states against the prototype.
- Verify Rails 8.0 and 8.1, Propshaft and Sprockets, root and nested mounts, and packaged-gem production asset precompilation without host frontend compilation.
- Run affected tests, the full suite, Ruby and view checks, and gem loading/build checks.

## Workflow and limits

- At planning time, the baseline passed: 9 tests, 24 assertions. No implementation files had changed.
- Follow the implement skill's test approval, review, hardening, final review, and user-testing phases. Request commit approval after verification.
- Add no production tables, background jobs, bulk operations, cache analytics, or unrelated page features. Do not publish a release.
