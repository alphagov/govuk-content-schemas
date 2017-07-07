module SchemaGenerator
  class FrontendSchemaGenerator
    def initialize(format)
      @format = format
    end

    def generate
      schema = {
        "$schema" => "http://json-schema.org/draft-04/schema#",
        "type" => "object",
        "additionalProperties" => false,
        "required" => required,
        "properties" => properties,
        "definitions" => change_multiple_content_types(definitions),
      }
      ApplyChangeHistory.call(schema)
    end

  private

    attr_reader :format

    def required
      # These properties are always returned from content store but there are
      # lots of examples in this repo to fix before able to use them:
      # - analytics_identifier
      # - email_document_supertype
      # - first_published_at
      # - government_document_supertype
      # - navigation_document_supertype
      # - need_ids
      # - phase
      # - publishing_app
      # - publishing_request_id
      # - rendering_app
      # - user_journey_document_supertype
      # - withdrawn_notice
      %w(
        base_path
        content_id
        description
        document_type
        details
        links
        locale
        public_updated_at
        schema_name
        title
        updated_at
      ).sort
    end

    def properties
      all_properties = default_properties.merge(derived_properties)
    end

    def definitions
      all_definitions = Jsonnet
        .load("formats/shared/definitions/all.jsonnet")
        .merge(format.definitions)
      DefinitionsResolver.new(properties, all_definitions).call
    end

    def default_properties
      Jsonnet.load("formats/shared/default_properties/frontend.jsonnet")
    end

    def derived_properties
      properties = {
        "document_type" => format.document_type.definition,
        "description" => format.description.definition,
        "details" => format.details.definition,
        "links" => ExpandedLinks.new(format).generate,
        "rendering_app" => format.rendering_app.definition,
        "schema_name" => format.schema_name_definition,
        "title" => format.title.definition,
      }
    end

    def change_multiple_content_types(definitions)
      replace_multiple_content_types(definitions).delete_if do |k|
        k == "multiple_content_types"
      end
    end

    def replace_multiple_content_types(object)
      if object == { "$ref" => "#/definitions/multiple_content_types" }
        { "type" => "string" }
      elsif object.is_a?(Hash)
        object.each.with_object({}) do |(key, value), hash|
          hash.merge!(key => replace_multiple_content_types(value))
        end
      elsif object.is_a?(Array)
        object.map { |element| replace_multiple_content_types(element) }
      else
        object
      end
    end
  end
end
