# GOV.UK content schemas

This repo contains schemas and examples of the content formats used on GOV.UK.

The aim of it is to support 'contract testing' between the frontend and
publisher apps by expressing the schema and examples in strict, machine
processable formats.

We use [JSON Schema](http://json-schema.org/) to define the formats.

For each format there are three possible representations:

* the 'publisher' representation, which is used when a publishing application
  transmits data to the content store.
* the 'notification' representation, which is used when broadcasting messages about content
  items on the message queue
* the 'frontend' representation, which is produced by the content store when a
  frontend application requests data

## How to change a content format

Imagine that you need to add a new optional field to the details hash of the
`case_study` format.

The steps would be:

1. edit the case_study [`details.json`](formats/case_study/publisher/details.json) to
   add the new optional field
2. run `make`. This will:
   1. regenerate the publisher [`schema.json`](dist/formats/case_study/publisher/schema.json) to incorporate the changes you made to the `details.json`
   2. regenerate the frontend [schema.json](dist/formats/case_study/frontend/schema.json) to incorporate the same changes
   3. revalidate all example files to check if they are still valid after this change. This will pass, because the new field is optional
3. [Optional step] you could add an additional example to illustrate how your new field should be used. You can add a new file in [formats/case_study/frontend/examples](formats/case_study/frontend/examples)
4. create a new branch and commit and push your changes
   - this will run a branch build of govuk-content-schemas. This includes running the contract tests for each application which relies on the schemas. You'll get immediate feedback about whether publishing applications generate content items compatible with the new schema.
5. once the tests pass, someone will merge your pull request and the new schemas will be available to use

For more step-by step guides see [howtos](#howtos).

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
[`Makefile`](/Makefile)) combines the three component files into the final
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

The `combine_publisher_schema` script is provided to generate the combined
`schema.json` from the source files:

```
$ bundle exec ./bin/combine_publisher_schema formats/case_study/publisher
```

It will write its output to the `dist` directory (generating any folders if needed).

### Generation of frontend schemas

The output from publishing apps will be verified using the `publisher` schema,
so we know that they will generate output which complies with that schema.

However, the frontend json is slightly different from the `publisher`
json and so it needs a different schema.

In order to be sure that the frontend examples match up, we need to derive
a frontend schema from the backend schema.

A script and make task is provided to do this:

```sh
$ bundle exec ./bin/generate_frontend_schema formats/case_study/publisher/schema.json > formats/case_study/frontend/schema.json
```

### Validation of frontend examples

To actually validate a frontend example, use the `validate` script:

```sh
$ bundle exec ./bin/validate formats/case_study/frontend/examples/archived.json
formats/case_study/frontend/examples/archived.json: OK
```

This will exit with a non-zero status if validation fails. Invoke `validate`
with no arguments for full usage instructions.

### Makefile

A `Makefile` exists which combines these scripts. It
automatically re-generates the intermediate schema files and validates all the
examples.

To invoke the default task just invoke `make` on its own. Make prints out each
command as it is invoked:

```
$ make
bundle exec ./bin/combine_publisher_schema formats/case_study/publisher/
bundle exec ./bin/generate_frontend_schema formats/case_study/publisher/schema.json > formats/case_study/frontend/schema.json
bundle exec ./bin/validate formats/case_study/frontend/examples/archived.json && touch formats/case_study/frontend/examples/archived.json.valid
formats/case_study/frontend/examples/archived.json: OK
bundle exec ./bin/validate formats/case_study/frontend/examples/case_study.json && touch formats/case_study/frontend/examples/case_study.json.valid
formats/case_study/frontend/examples/case_study.json: OK
bundle exec ./bin/validate formats/case_study/frontend/examples/translated.json && touch formats/case_study/frontend/examples/translated.json.valid
formats/case_study/frontend/examples/translated.json: OK
```

If no files are changed, then make will not do anything:

```
$ make
make: Nothing to be done for `default'.
```

Make relies on the file timestamps to determine when things need updating.

Finally you can delete all of the derived files and force a re-run by using `make clean`:

```
$ make clean
rm -f formats/case_study/frontend/examples/archived.json.valid formats/case_study/frontend/examples/case_study.json.valid formats/case_study/frontend/examples/translated.json.valid
rm -f formats/case_study/frontend/schema.json
rm -f formats/case_study/publisher/schema.json
```

## Howtos

* [How to add a new content format](docs/adding-a-new-format.md)
* [How to convert finder schemas](docs/converting-finder-schemas.md) (needed when adding/changing specialist document formats)
* [Adding contract tests to your app](docs/contract-testing-howto.md)
* [Suggested workflows](docs/suggested-workflows.md)
* [Why do contract testing?](docs/why-contract-testing.md)
* [Running your frontend against the examples (content-store not needed)](https://github.com/alphagov/govuk-dummy_content_store).

