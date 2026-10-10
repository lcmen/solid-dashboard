# Milestone 4: Cache entries

## Goal

Show and manage current Solid Cache entries without exposing cached values.

## Depends on

Milestone 1.

## Deliverables

- Use Solid Cache models and the host's configured Cache database connection.
- Show paginated entries, supported key search, available metadata, and entry inspection. Show counts and size only with labels that state whether values are exact or estimated.
- Support confirmed entry deletion with the correct HTTP verb, CSRF protection, and action validation.
- Do not deserialize cached values or decode binary or encrypted keys unsafely. Do not show expiration status or filters unless supported metadata provides them.
- Include empty and unavailable-backend states.

## Complete when

Tests cover metadata, key search, pagination, counts and size labels, deletion, concurrent entry removal, sensitive data, and unavailable Solid Cache.
