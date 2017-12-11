# GOV.UK content schemas

This repo contains schemas and examples of the content that uses them on GOV.UK.

The aim of it is to support 'contract testing' between the frontend and
publisher apps by expressing the schema and examples in strict, machine
processable form.

We use [Jsonnet](http://jsonnet.org/) to define the schemas.

For each schema, there are three possible representations:

* the 'publisher' representation, which is used when a publishing application
  transmits data to the content store.
* the 'frontend' representation, which is produced by the content store when a
  frontend application requests data
* the 'notification' representation, which is used when broadcasting messages about content
  items on the message queue

## Howtos

* [How to change a schema](docs/changing-a-schema.md)
* [How to add a new content schema](docs/adding-a-new-schema.md)
* [Adding contract tests to your app](docs/contract-testing-howto.md)
* [Suggested workflows](docs/suggested-workflows.md)
* [Why do contract testing?](docs/why-contract-testing.md)
* [Running your frontend against the examples and random content (content-store not needed)](docs/running-frontend-against-examples.md)
* [Deployment](docs/deployment.md)

## Background

### Publisher schema defined using component parts

Schemas are built from a single file defined in the formats directory.
An example file defining the schema is available in
[`formats/_example.jsonnet`](formats/_example.jsonnet).

These files are stored in the `govuk-content-schemas` repository in the
[`formats`](/formats) subdirectory. A build process (implemented using a
[`Rakefile`](/Rakefile)) combines the three component files into the final
`schema.json` file.

The generated files are all stored in the [`dist`](/dist/) subdirectory.

The build process applies the rules for the various different schema
representations.

There are a number of shared definitions that are used across multiple schemas
these are defined in the [`formats/shared`](formats/shared) directory.

Examples of schemas are available in the [`examples`](examples) directory.

**DO NOT EDIT FILES in the `dist` directory directly**, instead, edit the source
files in the `formats` directory.

In summary the folder structure is:

```
dist
└── formats
    └── case_study
        ├── frontend
        │   └── schema.json
        └── publisher
            └── schema.json
examples
└── case_study
    └── frontend
        ├── archived.json
        ├── case_study.json
        └── translated.json
formats
└── case_study.jsonnet

```

### Validation of examples

To validate examples against the generated schemas, use the `validate_examples`
Rake task:

```sh
$ bundle exec rake validate_examples
```

This will print the errors out to the console if validation fails.

### Rakefile

A `Rakefile` exists which combines these scripts. It
automatically re-generates the intermediate schema files and validates all the
examples.

To invoke the default task just invoke `rake` on its own.
