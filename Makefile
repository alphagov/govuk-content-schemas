# All of the publisher example files
publisher_examples := $(wildcard formats/*/publisher/examples/*.json)
publisher_v2_links_examples := $(wildcard formats/*/publisher_v2/examples/*_links.json)
publisher_v2_examples := $(filter-out $(wildcard formats/*/publisher_v2/examples/*_links.json), $(wildcard formats/*/publisher_v2/examples/*.json))

# All of the frontend example files
frontend_examples := $(wildcard formats/*/frontend/examples/*.json)

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

# The validation records are temporary files which are created to indicate that a given
# example has been validated.
frontend_validation_records := $(frontend_examples:formats/%.json=dist/formats/%.json.frontend.valid)
publisher_validation_records := $(publisher_examples:formats/%.json=dist/formats/%.json.publisher.valid)
publisher_v2_validation_records := $(publisher_v2_examples:formats/%.json=dist/formats/%.json.publisher_v2.valid)
publisher_v2_links_validation_records := $(publisher_v2_links_examples:formats/%.json=dist/formats/%.json.publisher_v2_links.valid)

# The various scripts used in the build process
combiner_bin := bundle exec rake combine_publisher_schemas
frontend_generator_bin := bundle exec ./bin/generate_frontend_schema
validation_bin := bundle exec ./bin/validate
ensure_example_base_paths_unique_bin := bundle exec ./bin/ensure_example_base_paths_unique

# The tasks run as part of the default make process
default: $(dist_publisher_schemas) $(frontend_schemas) validate_unique_base_path $(frontend_validation_records) \
	$(publisher_validation_records) $(publisher_v2_links_validation_records) $(publisher_v2_validation_records)

# A task to remove all intermediary files and force a complete rebuild
clean:
	rm -f $(frontend_validation_records)
	rm -f $(publisher_validation_records)
	rm -f $(publisher_v2_validation_records)
	rm -f $(publisher_v2_links_validation_records)
	rm -f $(frontend_schemas)
	rm -f $(dist_publisher_schemas)

validate_unique_base_path: $(frontend_schemas)
	$(ensure_example_base_paths_unique_bin) $(frontend_examples)

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

# Recipes for validating examples (the build target is the `.valid` file)
dist/%.frontend.valid: $(frontend_schemas) %
	mkdir -p `dirname ${@}`
	$(validation_bin) ${@:dist/%.frontend.valid=%} && touch ${@}

dist/%.publisher.valid: $(hand_made_publisher_schemas) %
	mkdir -p `dirname ${@}`
	$(validation_bin) ${@:dist/%.publisher.valid=%} && touch ${@}

dist/%.publisher_v2.valid: $(dist_publisher_v2_schemas) %
	mkdir -p `dirname ${@}`
	$(validation_bin) ${@:dist/%.publisher_v2.valid=%} && touch ${@}

dist/%.publisher_v2_links.valid: $(dist_publisher_v2_links_schemas) %
	mkdir -p `dirname ${@}`
	$(validation_bin) ${@:dist/%.publisher_v2_links.valid=%} --schema $(shell dirname ${@})/../links.json && touch ${@}
