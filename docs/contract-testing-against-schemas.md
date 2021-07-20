# Contract Testing against Schemas

We want to be able to evolve our publishing systems and have confidence that the changes we make will not break something.

We could do this by running all the systems at the same time and testing end-to-end. However setting up such a configuration would be tricky, and keeping it working reliably in a reproducible way which avoids test interference would be very difficult.

The idea of contract testing is to gain more confidence that the whole system works together properly, but without needing to run all the services at the same time. Instead we can test each service in isolation using a 'contract' which describes the expectations on each interacting service.

The definition of the contracts are provided by [govuk-content-schemas](https://github.com/alphagov/govuk-content-schemas).

For more information and background please read the [README.md](../README.md)

## Overview of publishing

Publishing involves three systems:

```
                   (1)                                    (2)
[publishing app] ------> [publishing api/content store] ------> [frontend app]

(1) publishing representation
(2) frontend representation

```

Note that the *frontend representation* differs slightly from the *publishing
representation*. The main difference is that the `links` hash is expanded so
that it contains full details about links, wheras the publisher representation
only contains content ids (for full info see [frontend_schema_generator_spec.rb](spec/lib/frontend_schema_generator_spec.rb)).

The *contract* between the publishing application and the frontend application
is defined by [govuk-content-schemas](https://github.com/alphagov/govuk-content-schemas).

This comprises three things:

1. json-schema files which define the *publishing representation* for a given format
2. a curated set of frontend examples of that format, which are validated against the schemas
3. [a mechanism to convert from the 'publisher' schemas to the 'frontend' schemas](https://github.com/alphagov/govuk-content-schemas/blob/main/lib/govuk_content_schemas/frontend_schema_generator.rb), simulating the behaviour of the content store

With those three parts we are able to verify the examples against the schemas.

This means that if the frontend works ok with the curated examples, and if the publishing tool produces output which matches the schema, then we can be quite confident that the frontends will work with the data produced by the publishing tool.

## Further reading

The background and ideas behind this are explored in [RFC 4](https://gov-uk.atlassian.net/wiki/display/WH/RFC+4+%3A+Enabling+the+independent+iteration+of+formats+on+government-frontend) and also in Daniel Roseman's [blog post](https://gdstechnology.blog.gov.uk/2015/01/07/validating-a-distributed-architecture-with-json-schema/).
