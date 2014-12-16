details_schemas := $(wildcard formats/*/publisher/details.json)
examples := $(wildcard formats/*/frontend/examples/*.json)

publisher_schemas := $(details_schemas:details.json=schema.json)
frontend_schemas := $(details_schemas:publisher/details.json=frontend/schema.json)
validation_records := $(examples:.json=.json.valid)

combiner_bin := bundle exec ./bin/combine_publisher_schema
frontend_generator_bin := bundle exec ./bin/generate_frontend_schema
validation_bin := bundle exec ./bin/validate

default: $(publisher_schemas) $(frontend_schemas) $(validation_records)
clean:
	rm -f $(validation_records)
	rm -f $(frontend_schemas)
	rm -f $(publisher_schemas)

%/publisher/schema.json: %/../metadata.json %/publisher/details.json $(wildcard %/publisher/links.json)
	$(combiner_bin) ${@:schema.json=}

%/frontend/schema.json: %/publisher/schema.json
	$(frontend_generator_bin) ${@:frontend/schema.json=publisher/schema.json} > ${@}

%.valid: $(frontend_schemas) %
	$(validation_bin) ${@:.valid=} && touch ${@}
