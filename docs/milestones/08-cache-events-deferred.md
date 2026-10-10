# Future milestone: Cache events page

## Goal

Replace the explanatory Cache events page with a view of retained Cache events.

## Depends on

Milestone 7 and its instrumentation design.

## Deliverables

- Show paginated recorded events with supported operation, key, size, duration, and timestamp fields.
- Add key search and operation filters. Do not display sensitive values.
- Show clear empty, disabled-instrumentation, and retention-boundary states.

## Complete when

Tests cover event fields, search, filters, pagination, retention limits, sensitive data, and empty or unavailable event history. This milestone is outside the first release.
