# All of the publisher example files
publisher_examples := $(wildcard formats/*/publisher/examples/*.json)

# All of the frontend example files
frontend_examples := $(wildcard formats/*/frontend/examples/*.json)

# All of the publisher details schemas used as input
details_schemas := $(wildcard formats/*/publisher/details.json)

# Derive the publisher schema files from the details schemas by substitution
combined_publisher_schemas := $(details_schemas:formats/%/details.json=dist/formats/%/schema.json)
hand_made_publisher_schemas := $(wildcard formats/*/publisher/schema.json)
dist_hand_made_publisher_schemas := $(hand_made_publisher_schemas:%=dist/%)
dist_publisher_schemas := $(combined_publisher_schemas) $(dist_hand_made_publisher_schemas)

# Derive the frontend schemas from the publisher schemas by substitution
frontend_schemas := $(combined_publisher_schemas:publisher/schema.json=frontend/schema.json)

# The validation records are temporary files which are created to indicate that a given
# example has been validated.
frontend_validation_records := $(frontend_examples:formats/%.json=dist/formats/%.json.frontend.valid)
publisher_validation_records := $(publisher_examples:formats/%.json=dist/formats/%.json.publisher.valid)

# The various scripts used in the build process
combiner_bin := bundle exec ./bin/combine_publisher_schema
frontend_generator_bin := bundle exec ./bin/generate_frontend_schema
validation_bin := bundle exec ./bin/validate
ensure_example_base_paths_unique_bin := bundle exec ./bin/ensure_example_base_paths_unique

# The tasks run as part of the default make process
default: $(dist_publisher_schemas) $(frontend_schemas) validate_unique_base_path $(frontend_validation_records) $(publisher_validation_records)

# A task to remove all intermediary files and force a complete rebuild
clean:
	rm -f $(frontend_validation_records)
	rm -f $(publisher_validation_records)
	rm -f $(frontend_schemas)
	rm -f $(dist_publisher_schemas)

validate_unique_base_path: $(frontend_schemas)
	$(ensure_example_base_paths_unique_bin) $(frontend_examples)

# Recipe for building publisher schemas from the metadata, details and links schemas
$(dist_hand_made_publisher_schemas): $(hand_made_publisher_schemas)
	cp ${@:dist/%=%} ${@}

dist/%/publisher/schema.json: formats/metadata.json %/publisher/*.json
	$(combiner_bin) ${@:dist/%/schema.json=%} ${@}

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
