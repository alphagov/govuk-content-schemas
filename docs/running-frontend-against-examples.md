# Running your frontend against the examples

This repo contains a Sinatra app that allows you to run an instance of content store, serving the examples in this repo, without having to the run the [content-store](https://github.com/alphagov/content-store) application itself.

It has the same API as the real [content-store](https://github.com/alphagov/content-store) and can be used interchangably in your app. The only difference will be the content items available.

Note: The dummy content store also has an index page which lists all the example content items available, you can find this at the root path: `/`.

## Using the Heroku version

There is an instance of the dummy content store running on Heroku, which applications can use rather than running it locally. Whenever main changes, it will automatically be updated, and the available examples may change.

[govuk-content-store-examples.herokuapp.com](https://govuk-content-store-examples.herokuapp.com/)

To use the heroku version when running your application set `PLEK_SERVICE_CONTENT_STORE_URI` to point at Heroku, eg:

```
$ PLEK_SERVICE_CONTENT_STORE_URI=https://govuk-content-store-examples.herokuapp.com bundle exec rails s
```

## Using it locally

To start an instance of the dummy content store, from this repo, run:

```
$ bundle exec dummy_content_store
```

You can also include the dummy content store as a dependency when running Bowler, but you have to explicitly exclude the content store from being launched as well.

For example:

```
$ bowl my-application-frontend my-application-publisher dummy-content-store --without content-store
```

### On the GOV.UK VM

It will be available at: [content-store.dev.gov.uk](http://content-store.dev.gov.uk).

This is the default location an application will look for the content-store, so no changes are required.

### Not on the GOV.UK VM

It will be available at: [0.0.0.0:3068](http://0.0.0.0:3068).

You will need to configure your application to point at this version of content-store, which you can do by setting `PLEK_SERVICE_CONTENT_STORE_URI` while running your application, eg,

```
$ PLEK_SERVICE_CONTENT_STORE_URI=http://0.0.0.0:3068 bundle exec rails s
```
