# Future milestone: Cache instrumentation and analytics

## Goal

Add opt-in Cache event collection and analytics after the first release.

## Depends on

First release validation in milestone 6, followed by an agreed instrumentation design.

## Deliverables

- Design event storage, database connection, retention bounds, instrumentation overhead, failure handling, and sensitive-key handling before implementation.
- If approved, collect supported hit, miss, write, and delete events through Solid Cache instrumentation.
- Provide accurate event totals, hit ratio, and bounded operation charts only when recorded events are available.
- Make disabled instrumentation and missing event history visible in the UI.

## Complete when

The design is recorded and implementation tests cover disabled instrumentation, event accuracy, retention, performance overhead, and missing data. This milestone is outside the first release.
