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

The rest of this readme will describe:

1. how to define a format
  - what files are needed
  - what each file is for
2. how integration/contract testing works
3. suggested workflows for making changes to schemas
  - when adding a new field to a content format
  - when removing a field from a content format
  - when modifying the metadata of formats

## How to define a content format

## How integration testing works

## Suggested workflows
