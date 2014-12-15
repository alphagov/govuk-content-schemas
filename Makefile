metadata_schemas := $(wildcard formats/*/publisher/metadata.json)

publisher_schemas := $(metadata_schemas:metadata.json=schema.json)
frontend_schemas := $(metadata_schemas:publisher/metadata.json=frontend/schema.json)

combiner_bin := bundle exec ./bin/combine_publisher_schema
frontend_generator_bin := bundle exec ./bin/generate_frontend_schema

default: $(publisher_schemas) $(frontend_schemas)

%/publisher/schema.json: %/publisher/metadata.json %/publisher/details.json %/publisher/links.json
	$(combiner_bin) ${@:schema.json=}

%/frontend/schema.json: %/publisher/schema.json
	$(frontend_generator_bin) ${@:frontend/schema.json=publisher/schema.json} ${@}
