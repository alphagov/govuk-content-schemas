metadata_schemas := $(wildcard formats/*/publisher/metadata.json)
examples := $(wildcard formats/*/frontend/examples/*.json)

publisher_schemas := $(metadata_schemas:metadata.json=schema.json)
frontend_schemas := $(metadata_schemas:publisher/metadata.json=frontend/schema.json)
validation_records := $(examples:.json=.json.valid)

combiner_bin := bundle exec ./bin/combine_publisher_schema
frontend_generator_bin := bundle exec ./bin/generate_frontend_schema
validation_bin := bundle exec ./bin/validate

default: $(publisher_schemas) $(frontend_schemas) $(validation_records)

%/publisher/schema.json: %/publisher/metadata.json %/publisher/details.json %/publisher/links.json
	$(combiner_bin) ${@:schema.json=}

%/frontend/schema.json: %/publisher/schema.json
	$(frontend_generator_bin) ${@:frontend/schema.json=publisher/schema.json} ${@}

%.valid: $(frontend_schemas) %
	$(validation_bin) ${@:.valid=} && touch ${@}
