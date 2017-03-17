module SchemaGenerator
  class FrontendSchema
    def initialize(schema_name, publisher_content_schema, publisher_links_schema)
      @schema_name = schema_name
      @publisher_content_schema = publisher_content_schema
      @publisher_links_schema = publisher_links_schema
    end

    def generate
      {
        "$schema" => "http://json-schema.org/draft-04/schema#",
        "type" => "object",
        "additionalProperties" => false,
        "required" => required,
        "properties" => properties,
        "definitions" => definitions,
      }
    end

  private

    attr_reader :schema_name, :publisher_content_schema, :publisher_links_schema

    LINK_TYPES_ADDED_BY_PUBLISHING_API = [
      # The Publishing API will automatically link to any translations (content
      # with the same content_id but a different locale).
      "available_translations",

      # Content items that are linked to with a `parent` link type will automatically
      # have a `children` link type with those items.
      "children",

      # Working groups have a `policies` link type containing the policies it is
      # tagged to.
      "policies",

      # Content items that are members of a collection will have a `document_collections`
      # link type
      "document_collections",

      # Content items that are linked to with a `parent_taxon` link type will automatically
      # have a `child_taxon` link type with those items.
      "child_taxons",

      # Content items that are linked to as a `topic` will automatically have a
      # `topic_content` link type with those items.
      "topic_content",

      # Content items that are linked to as a `mainstream_browse_page` will automatically
      # have a `mainstream_browse_content` link type with those items.
      "mainstream_browse_content",
    ].freeze

    # TODO: Add all attributes that the content-store is currently sending.
    REQUIRED_FRONTEND_ATTRIBUTES = %w(
      base_path
      links
      title
      details
      locale
      content_id
      document_type
      schema_name
    ).freeze

    def required
      REQUIRED_FRONTEND_ATTRIBUTES
    end

    def properties
      props = publisher_content_schema["properties"].merge(
        "content_id" => {
          "$ref" => "#/definitions/guid"
        },
        "links" => {
          "type" => "object",
          "additionalProperties" => false,
          "properties" => frontend_links(publisher_links_schema)
        },
        "format" => {
          "type" => "string",
          "description" => "DEPRECATED: use `document_type` instead. This field will be removed."
        },
        "navigation_document_supertype" => {
          "type" => "string",
          "description" => "Document type grouping powering the new taxonomy-based navigation pages",
        },
        "user_journey_document_supertype" => {
          "type" => "string",
          "description" => "Document type grouping powering analytics of user journeys",
        },
        "whitehall_document_supertype" => {
          "type" => "string",
          "description" => "Document type grouping intended to power the Whitehall finders and email subscriptions",
        },
        "updated_at" => {
          "type" => "string",
          "format" => "date-time"
        },
      )

      # TODO: This is done to make sure that this rewrite produces the exact same
      # JSON as before. After this is merged we can simplify this by just removing
      # the fields from the publisher_content_schema we don't want.
      props.slice(*%w[
        base_path title description public_updated_at first_published_at
        publishing_app rendering_app locale need_ids analytics_identifier phase
        details withdrawn_notice content_id last_edited_at links document_type
        schema_name format navigation_document_supertype user_journey_document_supertype whitehall_document_supertype updated_at
      ])
    end

    def definitions
      the_definitions = {
        "frontend_links" => Schema.read("formats/frontend_links_definition.json").slice("type", "items")
      }.merge(publisher_content_schema["definitions"])

      if schema_name == "specialist_document"
        the_definitions["details"]["required"] << "change_history"
      end

      replace_multiple_content_types(the_definitions)
    end

    def frontend_links(publisher_links_schema)
      link_types_sent_by_publishing_apps = publisher_links_schema["properties"]["links"]["properties"].keys

      frontend_link_names = link_types_sent_by_publishing_apps + LINK_TYPES_ADDED_BY_PUBLISHING_API

      frontend_link_names.reduce({}) do |hash, link_name|
        hash.merge(link_name => { "$ref" => "#/definitions/frontend_links" })
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
