# All of the publisher details schemas used as input
details_schemas := $(wildcard formats/*/publisher/details.json)
links_schemas := $(wildcard formats/*/publisher/links.json)

# Derive the publisher schema files from the details schemas by substitution
combined_publisher_schemas := $(details_schemas:formats/%/details.json=dist/formats/%/schema.json)
combined_publisher_v2_schemas := $(details_schemas:formats/%/publisher/details.json=dist/formats/%/publisher_v2/schema.json) $(links_schemas:formats/%/publisher/links.json=dist/formats/%/publisher_v2/links.json)
hand_made_publisher_schemas := $(wildcard formats/*/publisher/schema.json)
dist_hand_made_publisher_schemas := $(hand_made_publisher_schemas:%=dist/%)
dist_publisher_schemas := $(combined_publisher_schemas) $(dist_hand_made_publisher_schemas) $(combined_publisher_v2_schemas)

# Derive the frontend schemas from the publisher schemas by substitution
frontend_schemas := $(combined_publisher_schemas:publisher/schema.json=frontend/schema.json)

# The various scripts used in the build process
combiner_bin := bundle exec rake combine_publisher_schemas
frontend_generator_bin := bundle exec ./bin/generate_frontend_schema

# The tasks run as part of the default make process
default: $(dist_publisher_schemas) $(frontend_schemas) validate_unique_base_path validate_examples

# A task to remove all intermediary files and force a complete rebuild
clean:
	rm -rf dist/formats

validate_unique_base_path: $(frontend_schemas)
	bundle exec rake validate_uniqueness_of_frontend_example_base_paths

validate_examples:
	bundle exec rake validate_examples

# Recipe for building publisher schemas from the metadata, details and links schemas
$(dist_hand_made_publisher_schemas): $(hand_made_publisher_schemas)
	$(combiner_bin)

dist/%/publisher/schema.json: formats/definitions.json formats/metadata.json formats/v1_metadata.json formats/base_links.json %/publisher/*.json
	$(combiner_bin)

dist/%/publisher_v2/schema.json: formats/definitions.json formats/metadata.json formats/v2_metadata.json %/publisher/details.json
	$(combiner_bin)

dist/%/publisher_v2/links.json: formats/definitions.json formats/links_metadata.json formats/base_links.json %/publisher/links.json
	$(combiner_bin)

# Recipe for building the frontend schema from the publisher schema and frontend links definition
dist/%/frontend/schema.json: dist/%/publisher/schema.json formats/frontend_links_definition.json
	mkdir -p `dirname ${@}`
	$(frontend_generator_bin) -f formats/frontend_links_definition.json ${@:frontend/schema.json=publisher/schema.json} > ${@}
