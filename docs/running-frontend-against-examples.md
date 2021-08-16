# Running your frontend against the examples

This repo contains a Sinatra app that allows you to run an instance of content store, serving the examples in this repo, without having to the run the [content-store](https://github.com/alphagov/content-store) application itself.

It has the same API as the real [content-store](https://github.com/alphagov/content-store) and can be used interchangably in your app. The only difference will be the content items available.

Note: The dummy content store also has an index page which lists all the example content items available, you can find this at the root path: `/`.

## Using the Heroku version

There is an instance of the dummy content store running on Heroku, which applications can use rather than running it locally. Whenever `main` changes, it will automatically be updated, and the available examples may change.

[govuk-content-store-examples.herokuapp.com](https://govuk-content-store-examples.herokuapp.com/)

To use the heroku version when running your application set `PLEK_SERVICE_CONTENT_STORE_URI` to point at Heroku, eg:

```
$ PLEK_SERVICE_CONTENT_STORE_URI=https://govuk-content-store-examples.herokuapp.com bundle exec rails s
```
