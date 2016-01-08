# GOV.UK content schemas

This repo contains schemas and examples of the content formats used on GOV.UK.

The aim of it is to support 'contract testing' between the frontend and
publisher apps by expressing the schema and examples in strict, machine
processable formats.

We use [JSON Schema](http://json-schema.org/) to define the formats.

For each format there are two possible representations:

* the 'publisher' representation, which is used when a publishing application
  transmits data to the content store.
* the 'frontend' representation, which is produced by the content store when a
  frontend application requests data

In the future, there may be a third:

* the 'notification' representation, which is used when broadcasting messages about content
  items on the message queue

## Howtos

* [How to change a format](docs/changing-a-format.md)
* [How to add a new content format](docs/adding-a-new-format.md)
* [How to convert finder schemas](docs/converting-finder-schemas.md) (needed when adding/changing specialist document formats)
* [Adding contract tests to your app](docs/contract-testing-howto.md)
* [Suggested workflows](docs/suggested-workflows.md)
* [Why do contract testing?](docs/why-contract-testing.md)
* [Running your frontend against the examples (content-store not needed)](docs/running-frontend-against-examples.md)

## Background

### Publisher schema defined using component parts

The 'publisher' [`schema.json`](dist/formats/case_study/publisher/schema.json) is built from three parts:

  - [`metadata.json`](formats/metadata.json): the top level set of fields. These are the **same for every content
    format**.

  - [`details.json`](formats/case_study/publisher/details.json): the content of the details hash
    which is **different for each content format**. It is under the control of the
    publishing application.

  - [`links.json`](formats/case_study/publisher/links.json): the list of 'related links'. This is also **different
    for each content format**.

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

The build process generates the combined `schema.json` from the source files.
It will write its output to the `dist` directory (generating any folders if needed).

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
