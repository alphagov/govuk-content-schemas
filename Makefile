metadata_schemas := $(wildcard formats/*/publisher/metadata.json)

publisher_schemas := $(metadata_schemas:metadata.json=schema.json)

combiner_bin := bundle exec ./bin/combine_publisher_schema

default: $(publisher_schemas)

%/schema.json: %/metadata.json %/details.json %/links.json
	$(combiner_bin) ${@:schema.json=}
