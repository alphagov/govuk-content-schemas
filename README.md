# GOV.UK content schemas

This repo contains [JSON Schema](http://json-schema.org/) files and examples of the content that uses them on GOV.UK.

```
# source files and shared definitions
formats
└── case_study.jsonnet
└── shared
    └── default_format.jsonnet

# built schemas (DO NOT EDIT DIRECTLY)
dist
└── formats
    └── case_study
        ├── frontend
        │   └── schema.json
        └── publisher
            └── schema.json

# fixtures to support testing in apps
examples
└── case_study
    └── frontend
        ├── archived.json
        ├── case_study.json
        └── translated.json

```

For each source file, we generate up to schemas for the content:

* `publisher` - for when a publishing application transmits data to the content store.
* `frontend` - for data returned by the content store for a frontend application request
* `notification` - for broadcasting messages about content items on the message queue

## Technical documentation

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) to run the tests with all the necessary dependencies. Follow [the usage instructions](https://github.com/alphagov/govuk-docker#usage) to get started.

**Use GOV.UK Docker to run any commands that follow.**

* [How to change a schema](docs/changing-a-schema.md)
* [How to add a new content schema](docs/adding-a-new-schema.md)
* [Working with JSON Schema keywords](docs/working-with-json-schema-keywords.md)
* [Adding contract tests to your app](docs/contract-testing-howto.md)
* [Suggested workflows](docs/suggested-workflows.md)
* [Why do contract testing?](docs/why-contract-testing.md)
* [Running your frontend against the examples and random content (content-store not needed)](docs/running-frontend-against-examples.md)
* [Deployment](docs/deployment.md)

## Licence

[MIT Licence](LICENCE)
