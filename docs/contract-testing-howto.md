# Adding contract tests to your app

You will need to provide tests in your app which are part of the full test suite, but can also be run separately from the other tests (unless your test suite is really fast and likely to stay fast). What you need to do differs depending upon the type of app.

## Frontend apps

You should include tests which use the examples from the govuk-content-schemas to test whether your frontend works or not. [govuk_schemas](https://github.com/alphagov/govuk_schemas) provides code for doing this.

Ideally you should have a test which checks your app against every example for the formats it supports dynamically - so that examples added later are still tested in your app - there is an example in the [govuk_schemas](https://github.com/alphagov/govuk_schemas) README.


## Publishing apps

You should include tests which generate the JSON your app would send to content-store and validate them against the schemas. [govuk_schemas](https://github.com/alphagov/govuk_schemas) provides RSpec and test-unit helpers for this.
