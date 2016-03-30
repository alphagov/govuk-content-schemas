## How to change a content format

Imagine that you need to add a new optional field to the details hash of the
`case_study` format.

The steps would be:

1. edit the case_study [`details.json`](/formats/case_study/publisher/details.json) to
   add the new optional field
2. run `rake`. This will:
   1. regenerate the publisher [`schema.json`](/dist/formats/case_study/publisher/schema.json) to incorporate the changes you made to the `details.json`
   2. regenerate the frontend [schema.json](/dist/formats/case_study/frontend/schema.json) to incorporate the same changes
   3. revalidate all example files to check if they are still valid after this change. This will pass, because the new field is optional
3. [Optional step] you could add an additional example to illustrate how your new field should be used. You can add a new file in [formats/case_study/frontend/examples](/formats/case_study/frontend/examples)
4. create a new branch and commit and push your changes
   - this will run a branch build of govuk-content-schemas. This includes running the contract tests for each application which relies on the schemas. You'll get immediate feedback about whether publishing applications generate content items compatible with the new schema.
5. once the tests pass, someone will merge your pull request and the new schemas will be available to use
6. Deploy your changes with the [Deploy GOVUK Content Schemas](https://deploy.publishing.service.gov.uk/job/Deploy_GOVUK_Content_Schemas/) Jenkins job.  This makes your changes available to the publishing API for validation and dependency resolution.
