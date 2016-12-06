# GOV.UK content schemas

This repo contains schemas and examples of the content that uses them on GOV.UK.

The aim of it is to support 'contract testing' between the frontend and
publisher apps by expressing the schema and examples in strict, machine
processable form.

We use [JSON Schema](http://json-schema.org/) to define the schemas.

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
* [Running your frontend against the examples (content-store not needed)](docs/running-frontend-against-examples.md)
* [Deployment](docs/deployment.md)

## Background

### Publisher schema defined using component parts

The 'publisher' [`schema.json`](dist/formats/case_study/publisher/schema.json) is built from several parts:

  - [`metadata.json`](formats/metadata.json): the top level set of fields. These are **common to most content
    schemas**.

  - [version metadata eg. `v2_metadata.json`](formats/v2_metadata.json): Fields specific to the publisher version.
    Either [`v1_metadata.json`](formats/v1_metadata.json) or [`v2_metadata.json`](formats/v2_metadata.json)

  - Alternatively, [schema specific metadata](formats/contact/publisher_v2/metadata.json) can be defined for
    exceptional schemas which do not conform to common, v1 or v2 metadata definitions.
    An example of this is pathless content such as [Whitehall contacts](dist/formats/contact/publisher_v2/schema.json)
    which do not contain the normally required `base_path` and `routes` properties.

  - [`definitions.json`](formats/definitions.json) Common definitions used across schemas.

  - [`details.json`](formats/case_study/publisher/details.json): the content of the details hash
    which is **different for each content schema**. It is under the control of the
    publishing application.

  - [`links_metadata.json`](formats/links_metadata.json) The top level fields for v2 publisher links.

  - [`base_links.json`](formats/base_links.json) Common link properties definitions for v1 and v2 publisher schemas.

  - [`links.json`](formats/case_study/publisher/links.json): the list of 'related links'. This is also **different
    for each content schema**.

These files are stored in the `govuk-content-schemas` repository in the
[`formats`](/formats) subdirectory. A build process (implemented using a
[`Rakefile`](/Rakefile)) combines the three component files into the final
`schema.json` file.

The generated files are all stored in the [`dist`](/dist/) subdirectory.

**DO NOT EDIT FILES in the `dist` directory directly**, instead, edit the source files in the `formats` directory.

In summary the folder structure is:

```
dist
└── formats
    └── case_study
        ├── frontend
        │   └── schema.json
        └── publisher
            └── schema.json
formats
├── case_study
│   ├── frontend
│   │   └── examples
│   │       ├── archived.json
│   │       ├── case_study.json
│   │       └── translated.json
│   └── publisher
│       ├── details.json
│       └── links.json
└── metadata.json
```

### Combining files to make publisher schema

The build process generates the combined `schema.json` from the source files. It will write its output to the `dist` directory (generating any folders if needed).

### Generation of frontend schemas

The output from publishing apps will be verified using the `publisher` schema,
so we know that they will generate output which complies with that schema.

However, the frontend JSON is slightly different from the `publisher`
JSON and so it needs a different schema.

In order to be sure that the frontend examples match up, we need to derive
a frontend schema from the backend schema. This is also done as part of the standard build process.

### Validation of frontend examples

To actually validate a frontend example, use the `validate_examples` Rake task:

```sh
$ bundle exec rake validate_examples
```

This will print the errors out to the console if validation fails.

### Rakefile

A `Rakefile` exists which combines these scripts. It
automatically re-generates the intermediate schema files and validates all the
examples.

To invoke the default task just invoke `rake` on its own. You can delete all of
the derived files and force a re-run by using `rake clean build`:

### Magic fields

Not all fields for the frontend examples are defined in the schema, instead they're added by [GovukContentSchemas::FrontendSchemaGenerator](lib/govuk_content_schemas/frontend_schema_generator.rb). For example:

- `base_path`
- `updated_at`

[GovukContentSchemas::SchemaCombiner](lib/govuk_content_schemas/schema_combiner.rb) also adds a few:

- `schema_name`
- `document_type`
