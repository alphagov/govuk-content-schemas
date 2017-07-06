module SchemaGenerator
  class NotificationSchemaGenerator
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
        "definitions" => definitions,
      }
      ApplyChangeHistory.call(schema)
    end

  private

    attr_reader :format

    def required
      %w(
        analytics_identifier
        base_path
        content_id
        description
        details
        document_type
        email_document_supertype
        expanded_links
        first_published_at
        government_document_supertype
        links
        locale
        navigation_document_supertype
        need_ids
        phase
        public_updated_at
        publishing_app
        redirects
        rendering_app
        routes
        schema_name
        title
        update_type
        user_journey_document_supertype
      ).sort
    end

    def properties
      all_properties = default_properties.merge(derived_properties)
      Hash[ all_properties.sort_by { |k, _| k } ]
    end

    def default_properties
      Jsonnet.load("jsonnet_formats/shared/default_properties/notification.jsonnet")
    end

    def derived_properties
      properties = {
        "base_path" => format.base_path.definition,
        "document_type" => format.document_type.definition,
        "description" => format.description.definition,
        "details" => format.details.definition,
        "expanded_links" => ExpandedLinks.new(format).generate,
        "links" => unexpanded_links,
        "redirects" => format.redirects.definition,
        "rendering_app" => format.rendering_app.definition,
        "routes" => format.routes.definition,
        "schema_name" => format.schema_name_definition,
        "title" => format.title.definition,
      }
    end

    def definitions
      all_definitions = Jsonnet
        .load("jsonnet_formats/shared/definitions/all.jsonnet")
        .merge(format.definitions)
      DefinitionsResolver.new(properties, all_definitions).call
    end

    def unexpanded_links
      content_links = format.content_links.guid_definition
      edition_links = format.edition_links.guid_definition
      content_links.merge(edition_links)
    end
  end
end
