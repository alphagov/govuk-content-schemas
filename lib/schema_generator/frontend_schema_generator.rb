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
          "properties" => frontend_links(publisher_content_schema, publisher_links_schema)
        },
        "navigation_document_supertype" => {
          "type" => "string",
          "description" => "Document type grouping powering the new taxonomy-based navigation pages",
        },
        "user_journey_document_supertype" => {
          "type" => "string",
          "description" => "Document type grouping powering analytics of user journeys",
        },
        "email_document_supertype" => {
          "type" => "string",
          "description" => "Document supertype grouping intended to power the Whitehall finders and email subscriptions",
        },
        "government_document_supertype" => {
          "type" => "string",
          "description" => "Document supertype grouping intended to power the Whitehall finders and email subscriptions",
        },
        "updated_at" => {
          "type" => "string",
          "format" => "date-time"
        },
        "publishing_request_id" => {
          "$ref" => "#/definitions/publishing_request_id",
        },
      )

      # TODO: This is done to make sure that this rewrite produces the exact same
      # JSON as before. After this is merged we can simplify this by just removing
      # the fields from the publisher_content_schema we don't want.
      props.slice(*%w[
        base_path title description public_updated_at first_published_at
        publishing_app rendering_app locale need_ids analytics_identifier phase
        details withdrawn_notice content_id last_edited_at links document_type
        schema_name format navigation_document_supertype user_journey_document_supertype email_document_supertype government_document_supertype updated_at
        publishing_request_id
      ])
    end

    def definitions
      the_definitions = {
        "frontend_links" => Schema.read("formats/frontend_links_definition.json").slice("type", "items")
      }.merge(publisher_content_schema["definitions"])

      the_definitions.delete("links")

      replace_multiple_content_types(the_definitions).tap do |converted|
        if schema_name == "specialist_document"
          converted["details"]["required"] << "change_history"
        end

        if details_should_contain_change_history?(converted)
          converted["details"]["properties"]["change_history"] = { "$ref"=>"#/definitions/change_history" }
        end
      end
    end

    def publishing_api_expanded_links
      LINK_TYPES_ADDED_BY_PUBLISHING_API.each_with_object({}) do |link_type, memo|
        memo[link_type] = { "description" => "Link type automatically added by Publishing API" }
      end
    end

    def frontend_links(publisher_content_schema, publisher_links_schema)
      edition_links = publisher_content_schema.dig("definitions", "links", "properties") || {}
      link_set_links = publisher_links_schema.dig("properties", "links", "properties") || {}

      link_set_links.merge(edition_links)
        .merge(publishing_api_expanded_links)
        .each_with_object({}) do |(type, properties), memo|
          # We can't know of the presence of any items due to reliance on when
          # they're published, so at best we can know the maxItems
          memo[type] = properties.slice("description", "maxItems")
            .merge("$ref" => "#/definitions/frontend_links")
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

    def details_should_contain_change_history?(definition)
      return if !definition.dig("details", "properties") || definition["details"]["properties"]["change_history"]
      publisher_content_schema["properties"].has_key?("change_note")
    end
  end
end
