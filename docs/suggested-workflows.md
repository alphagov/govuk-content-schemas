# Suggested workflows for schema changes

## General workflow

* create a branch
* make changes to the relevant schema fragment under `formats/<format name>/publisher/(details.json or links.json)`
* change the relevant frontend examples (or add a new example)
* run `make` to compile a new schema.json and test the example against the schema
* optional: run the rake task in content-store to validate the items in the database against the schema: `bundle exec rake check_content_items_against_schema[my_format_name]`
* commit and push
* open a PR
* watch the multi-build status to see if all apps are compatible with the change
* if the builds are successful, it can be merged


## Adding a new field

Follow the General workflow described above. You are now free to add support for the field to apps. If you are adding a mandatory field you will need to additionally:

* deploy the publishing app with changes to always populate the field
* populate the field in any records inside content-store
* follow the General workflow, adding the field to the `required` attribute
* you can then update the frontend app to expect the field to always be present


## Removing a field

If the field was mandatory:

* Remove the field from the `required` attribute by following the General workflow
  * Remove the field from examples to ensure that the frontend can handle the field being optional
* Deploy any frontend changes
* Change the publisher to stop sending the field
* Deploy the publisher
* Optional: change the records in content-store
* Remove the field by following the General workflow
