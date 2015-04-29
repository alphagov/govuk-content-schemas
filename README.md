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

We're still evolving how this all works, so please bear with us!

## Publisher schema defined using component parts

We think that it will be useful to define the 'publisher' schema in terms of
three separate parts:

  - **metadata**: the top level set of fields which are the same for every content
    format
  - **details**: the content of the details hash which is allowed to be different
    for each content format, and is essentially under the control of the
    publishing application.
  - **links**: the list of 'related links'. This is also allowed to be different
    for each content format

This will allow ownership of each of those files to reside in the appropriate
place, namely:

  - **metadata**: owned by content-store
  - **details** and **links**: owned by the corresponding publishing applications

These files will be stored in govuk-content-schemas as a central repository of
the files. We will also store a derived `schema.json` as a convenient
reference, but the `metadata.json`, `details.json` and `links.json` should be
considered the master definitions.

The folder structure is:

```
formats
├── case_study
│   ├── frontend
│   │   ├── examples
│   │   │   ├── archived.json
│   │   │   ├── case_study.json
│   │   │   ├── translated.json
│   │   └── schema.json
│   └── publisher
│       ├── details.json
│       ├── links.json
│       └── schema.json
└── metadata.json
```

The `combine_publisher_schema` script is provided to generate the combined
`schema.json` from the source files:

```
$ bundle exec ./bin/combine_publisher_schema formats/case_study/publisher
```

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

## How to add a new content format

See [adding-a-new-format.md](docs/adding-a-new-format.md)

## Adding contract tests to your app

See [contract-testing-howto.md](docs/contract-testing-howto.md)

## Suggested workflows

See [suggested-workflows.md](docs/suggested-workflows.md)

## Why do contract testing?

See [why-contract-testing.md](docs/why-contract-testing.md)

## Running your frontend against the examples (content-store not needed)

You can use the [`govuk-dummy_content_store` gem](https://github.com/alphagov/govuk-dummy_content_store).

