# Use list queries and facades

Solid Dashboard uses facades as the application interface and query objects to build filtered, ordered, paginated record lists. Controllers and views use `SolidDashboard.app` and its feature facades, such as `app.jobs`. They pass user inputs explicitly and do not construct query objects. This keeps callers independent of query implementation details.

Facades live in `app/fascades`. They expose record lookup, lists, related lists, counts, and filter choices. A facade can perform a simple single-record lookup directly. We removed `JobQuery` because it only wrapped that lookup; a separate query class did not give it a useful responsibility. The Jobs facade keeps `find(id)` as its public interface and preserves the status timestamp and preloaded executions needed by the returned model.

List queries live in `app/queries`. They accept a model relation and explicit filter and pagination inputs, build the ordered relation, and return a `PaginatedList`. The Jobs facade uses `JobsQuery` for both the main job list and retained attempts. This reuses list behavior without putting filtering and pagination code in the facade. Models own record relationships and status rules; view helpers own display formatting. Operational mutations remain separate from read queries.

See the [Jobs implementation plan](../milestones/01-jobs-plan.md) and the [README](../../README.md) for the current interfaces and query conventions.
