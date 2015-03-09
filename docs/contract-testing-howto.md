# How to set up contract testing

## Why do contract testing?

We want to be able to evolve our publishing systems and have confidence that the changes we make will not break something.

We could do this by running all the systems at the same time and testing end-to-end. However setting up such a configuration would be tricky, and keeping it working reliably in a reproducible way which avoids test interference would be very difficult.

The idea of contract testing is to gain more confidence that the whole system works together properly, but without needing to run all the services at the same time. Instead we can test each service in isolation using a 'contract' which describes the expectations on each interacting service.

The definition of the contracts are provided by `govuk-content-schemas`.

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
is defined by govuk-content-schemas.

This comprises three things:

1. json-schema files which define the *publishing representation* for a given format
2. a curated set of frontend examples of that format, which are validated against the schemas
3. [a mechanism to convert from the 'publisher' schemas to the 'frontend' schemas](https://github.com/alphagov/govuk-content-schemas/blob/master/lib/govuk_content_schemas/frontend_schema_generator.rb), simulating the behaviour of the content store

With those three parts we are able to verify the examples against the schemas.

This means that if the frontend works ok with the curated examples, and if the publishing tool produces output which matches the schema, then we can be quite confident that the frontends will work with the data produced by the publishing tool.

## Adding a new format to govuk-content-schemas

TODO

## Setting up contract testing

We have now set up contract testing between `whitehall` and `government-frontend`, so you can follow that as an example.

The pieces required are:

* [`jenkins-schema.sh` in government-frontend](https://github.com/alphagov/government-frontend/blob/master/jenkins-schema.sh) - runs the government frontend tests using the schema examples specified in the the `$SCHEMA_GIT_COMMIT` environment variable.
* [`jenkins-schema.sh` in whitehall](https://github.com/alphagov/whitehall/blob/master/jenkins-schema.sh) - runs the whitehall publishing api presenter tests which take an edition model object and generate the JSON message which would be sent to the publishing API. This json is validated against the schemas.

We then need to make sure that whenever a change is made to `govuk-content-schemas`
we also run these two jobs.

This is done using jenkins triggers on both the [master build](https://ci-new.alphagov.co.uk/job/govuk_content_schemas/) and the [branches build](https://ci-new.alphagov.co.uk/job/govuk_content_schemas_branches/) of `govuk-content-schemas`.

Normally there should be a set of contract tests for each integration point,
ie. for your application writing to content store, and for your frontend
reading from content store.

If you're adding a new format, you may be lucky in that your publishing app or
frontend already has contract tests set up. In that case you just need to add
the new examples and schemas to this repo and then check that the contract
tests use those schemas and examples.

If your publishing app or frontend has never had contract testing set up,
you'll need to do the following:

1. add a schema for your format and curated examples to `govuk-content-schemas`.
2. add `jenkins-schema.sh` to your publishing tool. This should run tests which check that your publishing tool produces output which conforms to the relevant schemas in govuk-content-schemas. We intend to add a [gem to help with this testing ](https://trello.com/c/U3IFYey5/75-ruby-gem-for-schema-validation)
4. create a jenkins job to run the schema tests for your publishing tool. Call it something like `govuk_my_publishing_tool_schema_tests`.
5. add `jenkins-schema.sh` to your frontend. This should use the curated examples from govuk-content-schemas in your frontend app and check that they display correctly (as a minimum that they do not error when rendering the page)
6. create a jenkins job to run the schema tests for your frontend. Call it something like `govuk_my_frontend_schema_tests`.
4. configure the [`govuk_content_schemas` job](https://ci-new.alphagov.co.uk/job/govuk_content_schemas/configure): under "Build" -> "Trigger/call builds on other projects", add the two new `*_schema_tests` as triggered builds
5. configure the [`govuk_content_schemas_branches` job](https://ci-new.alphagov.co.uk/job/govuk_content_schemas_branches/configure): under "Build" -> "Trigger/call builds on other projects", add the two new `*_schema_tests` as triggered builds

done!


## Further reading

The background and ideas behind this are explored in [RFC 4](https://gov-uk.atlassian.net/wiki/display/WH/RFC+4+%3A+Enabling+the+independent+iteration+of+formats+on+government-frontend) and also in Daniel Roseman's [blog post](https://gdstechnology.blog.gov.uk/2015/01/07/validating-a-distributed-architecture-with-json-schema/).
