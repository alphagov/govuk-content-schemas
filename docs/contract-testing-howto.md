# Adding contract tests to your app

You will need to provide tests in your app which are part of the full test suite, but can also be run separately from the other tests (unless your test suite is really fast and likely to stay fast). What you need to do differs depending upon the type of app.

## Frontend apps

You should include tests which use the examples from the govuk-content-schemas to test whether your frontend works or not. [govuk-content-schema-test-helpers](https://github.com/alphagov/govuk-content-schema-test-helpers) provides code for doing this.

Ideally you should have a test which checks your app against every example for the formats it supports dynamically - so that examples added later are still tested in your app - there is an example in the [govuk-content-schema-test-helpers](https://github.com/alphagov/govuk-content-schema-test-helpers) README.


## Publishing apps

You should include tests which generate the JSON your app would send to content-store and validate them against the schemas. [govuk-content-schema-test-helpers](https://github.com/alphagov/govuk-content-schema-test-helpers) provides RSpec and test-unit helpers for this.


## Setting up the CI builds

We need to make sure that when a change is made to `govuk-content-schemas` that no apps are broken by the changes, so we run all the contract tests in the apps.

1. Add `jenkins-schema.sh` to your publishing tool. This should run tests which check that your publishing tool produces output which conforms to the relevant schemas in govuk-content-schemas. See [contacts-admin for an example](https://github.com/alphagov/contacts-admin/blob/master/jenkins-schema.sh).
2. Create a jenkins job to run the schema tests in your app. Call it something like `govuk_my_app_schema_tests`, copying it from one of the existing builds.
3. Add the new job to be triggered when each of the govuk_content_schemas jobs complete: under "Build" -> "Trigger/call builds on other projects"
  1. The [master build](https://ci-new.alphagov.co.uk/job/govuk_content_schemas/configure)
  2. The [branch build](https://ci-new.alphagov.co.uk/job/govuk_content_schemas_branches/configure)
