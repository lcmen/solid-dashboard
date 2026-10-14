# Solid Dashboard

A mountable Rails engine for Solid Queue and Solid Cache. The current release provides a responsive layout and navigation for the planned dashboard pages. The page content is still in development. Solid Dashboard supports Rails 8.0 and 8.1.

## Installation

Add the gem to your application's Gemfile:

```ruby
gem "solid_dashboard", "0.1.0.alpha1"
```

If the host uses Rails 8.0, also add this JSON constraint:

```ruby
gem "json", "< 3"
```

Rails 8.0 passes a JSON option that JSON 3 no longer accepts. Use JSON 2 with Rails 8.0. Rails 8.1 can use JSON 3.

Run `bundle install`. The host application must use Propshaft or Sprockets. Add `gem "propshaft"` if it has no asset pipeline.

## Usage

Mount the engine in `config/routes.rb`:

```ruby
mount SolidDashboard::Engine, at: "/solid_dashboard"
```

The Jobs page reads Solid Queue records, shows status counts, and supports search, filters, and pagination. The job detail page shows metadata, escaped job arguments, and retained attempts. It supports confirmed retry and discard for individual failed jobs. Other pages remain placeholders.

Protect the mounted engine with the host application's authentication and authorization. The engine does not provide an access check. Job arguments can contain sensitive data. Exception messages and traces are not displayed. Dashboard reads do not execute jobs or deserialize Active Job arguments. Retry and discard require confirmation and CSRF protection. Operation logs contain the operation name, job ID, and outcome.

The gem includes compiled CSS and JavaScript, so the host does not need Tailwind or Node.js to run it. Use the host's normal `assets:precompile` command during deployment.

## Jobs and compatibility

The supported backend versions are Solid Queue 1.7.0 and Solid Cache 1.0.10. Backend checks use each backend's configured connection. The Jobs page returns an unavailable state when Solid Queue is not loaded, its version is unsupported, required tables are missing, or its database cannot be reached. Queue and Cache availability checks are independent. Cache pages are not implemented yet.

Job statuses use this order: claimed executions are Running; failed executions are Failed; older finished records with a newer record that shares their nonblank Active Job ID are Retried; other finished records are Finished; unfinished jobs scheduled in the future are Scheduled; remaining unfinished jobs, including blocked jobs, are Pending.

Status counts cover all retained jobs before search and list filters. The filtered count controls pagination. Counts are exact SQL counts, with no shared cache or count limit, so their cost increases with the number of retained records. Counts and queue choices are memoized only within each Jobs facade instance.

History includes only retained records with the same nonblank Active Job ID. Solid Queue cleanup can remove earlier records. Manual retry reuses the failed job record; it does not create a new history record. A job without an Active Job ID has no identifiable related attempts.

## App and query conventions

`SolidDashboard.app` creates a new `App`. The App and Jobs facades live in `app/fascades`. The engine creates one App for each request and exposes it to controllers and views as `app`. `app.jobs` returns the same Jobs facade within that App. Creating either facade does not query the database. Pass user inputs explicitly to facade methods.

The facade and list-query responsibilities follow the [architecture decision](docs/adr/0002-use-list-queries-and-facades.md).

`app.jobs.find(id)` returns one read-only `SolidDashboard::Job` model and raises `ActiveRecord::RecordNotFound` for a missing job. `app.jobs.list(q:, status:, queue_name:, page:, per_page:)` returns a `PaginatedList` of Job models. `app.jobs.attempts(job, page:, per_page:)` returns the same collection type for retained attempts. `app.jobs.queues` provides queue choices. `pending_count`, `scheduled_count`, `running_count`, `finished_count`, `failed_count`, and `retried_count` use separate status relations and SQL counts, independent of list filters.

`ApplicationQuery` accepts an Active Record relation as `scope:`, plus `page:` and `per_page:`. Subclasses implement the `build_scope` method and specify stable ordering. `call` returns a `PaginatedList`, which supports iteration, `empty?`, `page`, `pages`, `total`, and `per_page`. Records load only when the collection is read, and repeated iteration reuses the loaded page. Totals use SQL counts. Invalid pages use page 1. Invalid page sizes use 25, and sizes are capped at 100. Pages beyond the result set return no records.

`JobsQuery` adds literal class-name substring search, exact numeric job-ID search, status and queue filters, and descending job-ID order. It defaults to the dashboard Job relation and accepts a supplied relation as `scope:`. It preloads the executions and selects a retry flag needed for status display without per-job queries. The Jobs facade performs the single-job lookup directly, using the same retry flag, status timestamp, and preloaded executions.

The `related_attempts` association uses `active_job_id` as both the primary and foreign key. `with_newer_attempts` joins that association and compares related record IDs with the current record ID. The finished and retried scopes exclude or include its IDs through SQL subqueries. The retry flag uses the same subquery, so multiple related records do not duplicate the outer job list or its count.

The Job model extends `SolidQueue::Job` to reuse its database connection, associations, and argument serialization. It owns dashboard status classification, status scopes, and the unpaginated `attempts` relation. Queries preserve the facade's status timestamp so filters, counts, and displayed statuses use the same time. For a blank Active Job ID, the attempts relation includes only the selected record. The model does not call query objects. The reusable `Preventable` concern provides a `prevent` class method that blocks operational instance methods such as `dispatch`, `retry`, and `discard` with `ActiveRecord::ReadOnlyRecord`. Each model declares its blocked methods. Confirmed dashboard operations use the upstream models through `JobOperation`.

When Solid Queue is absent, the Job model uses `ApplicationRecord` so eager loading can complete. Backend checks stop Jobs requests before the model is queried. `JobsHelper` provides `job_status_label`, `job_status_class`, and `formatted_job_arguments`. Argument formatting returns plain text for normal ERB escaping. There is no decorator. Backend checks, mutations, and presentation stay outside the shared query base.

## Build

```sh
npm ci
npm run build
gem build solid_dashboard.gemspec
```

The build command compiles Tailwind v4 with the forms plugin and Bootboat, then bundles Alpine with esbuild. Node.js and npm are required only for gem development and release builds.

## Development

Install the development tools and dependencies:

```sh
mise install
```

The setup installs Ruby and npm dependencies, then installs the commit hook.

Start Rails and the CSS and JavaScript watchers:

```sh
mise run development
```

Open `http://localhost:3000/solid-dashboard`. To change the bind address or port, set `BINDING` and `PORT`.

Build the assets, then run tests with both asset pipelines:

```sh
npm run build
bundle exec rake test
ASSET_PIPELINE=sprockets bundle exec rake test
```

Use the version-specific Gemfiles to test Rails 8.0 and 8.1. Run `BUNDLE_GEMFILE=gemfiles/rails_8.0.gemfile bundle install`, then `BUNDLE_GEMFILE=gemfiles/rails_8.0.gemfile bundle exec rake test`. Use `rails_8.1.gemfile` for Rails 8.1. The version-specific lockfiles are generated locally and are not committed.

Run lint or format the code:

```sh
mise run lint
mise run fix
```

## Release

Set the version in `lib/solid_dashboard/version.rb`, push the release commit, and confirm CI passes. Authenticate the GitHub CLI and RubyGems, then run:

```sh
mise run release
```

Pass optional text to prepend to the generated release notes:

```sh
mise run release "Your release notes"
```

## License

MIT. See [LICENSE](LICENSE).
