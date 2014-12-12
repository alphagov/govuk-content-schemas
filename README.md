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

We anticipate that the partial files will be stored in govuk-content-schemas
as a central repository of the files. We will also store a derived
`schema.json` as a convenient reference, but the `metadata.json`,
`details.json` and `links.json` should be considered the master definitions.

The `combine_publisher_schema` script is provided to generate the combined
`schema.json` from the source files:

```
$ bundle exec ./bin/combine_publisher_schema formats/case_study/publisher
```

Furthermore a `Makefile` exists which will re-compute `schema.json` files if
any of the input files have changed:

```
$ rm -f formats/case_study/publisher/schema.json
$ make
bundle exec ./bin/combine_publisher_schema formats/case_study/publisher/
$ make
make: Nothing to be done for `default'.
```

### Meaningful validation of frontend examples

We would like to prove that the frontend examples match up with what a backend
would generate. The output of the backends will be verified using the backend
schema, so we know that they will generate output which complies with that
schema.

However, the frontend json is slightly different from the backend
json and so it needs a different schema.

So in order to be sure that the frontend examples match up, we need to derive
a frontend schema from the backend schema.

TODO:

- provide a script and makefile task to do convert backend schema to frontend schema
- provide a script and makefile task to test all the frontend examples against the schema

## How to define a content format (tbd)
  - what files are needed
  - what each file is for

## How integration testing works (tbd)

## Suggested workflows (tbd)

  - when adding a new field to a content format
  - when removing a field from a content format
  - when modifying the metadata of formats
