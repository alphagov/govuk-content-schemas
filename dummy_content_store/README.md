# Dummy content store

The dummy content store allows you to run a frontend using the examples from
the `govuk-content-schemas` repo. You will not need to run the content store
itself.

To run the dummy content store:

```sh
$ ./dummy_content_store/startup.sh
```

by default it will use the examples from the `formats` folder.

To use a different folder set the `EXAMPLES_PATH` environment variable:

```sh
$ EXAMPLES_PATH=/path/to/my/examples ./dummy_content_store/startup.sh
```

