# Deployment

Deploy your changes with the [Deploy GOVUK Content Schemas](https://deploy.publishing.service.gov.uk/job/Deploy_GOVUK_Content_Schemas/) Jenkins job.  This makes your changes available to the publishing API for validation and dependency resolution.

Deployment is done by the `deploy.sh` script, which will copy the files in
`dist` on to the relevant servers.
