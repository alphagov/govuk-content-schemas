require "govuk_content_schemas"
require "govuk_content_schemas/utils"
require "json-schema"

class GovukContentSchemas::FrontendSchemaGenerator
  include ::GovukContentSchemas::Utils

  attr_reader :publisher_schema, :frontend_links_definition, :format_name

  INTERNAL_PROPERTIES = %w{
    access_limited
    redirects
    routes
    update_type
    change_note
  }.freeze

  OPTIONAL_PROPERTIES = %w{
    publishing_app
    rendering_app
  }.freeze

  LINK_NAMES_ADDED_BY_PUBLISHING_API = [
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

  CHANGE_HISTORY_REQUIRED = ['specialist_document'].freeze

  def initialize(publisher_schema, frontend_links_definition, format_name)
    @publisher_schema = publisher_schema
    @frontend_links_definition = frontend_links_definition
    @format_name = format_name
  end

  def generate
    JSON::Schema.new({
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "additionalProperties" => false,
      "required" => required_properties,
      "properties" => frontend_properties,
      "definitions" => frontend_definitions
    }, publisher_schema.uri)
  end

private

  def internal?(property_name)
    INTERNAL_PROPERTIES.include?(property_name)
  end

  def required_properties
    required = publisher_schema.schema["required"].to_a

    if required.empty?
      []
    else
      (%w[content_id base_path links] + (required - INTERNAL_PROPERTIES - OPTIONAL_PROPERTIES)).uniq
    end
  end

  def publisher_properties
    @pub_properties ||= publisher_schema.schema["properties"] || {}
  end

  def publisher_links
    publisher_schema.schema["definitions"]["links"] || publisher_properties["links"] || { "properties" => {} }
  end

  def frontend_properties
    properties = publisher_properties.reject { |property_name| internal?(property_name) }
    properties = resolve_multiple_content_types(properties)

    properties = properties.merge(
      "links" => frontend_links,
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
      "updated_at" => updated_at,
      "base_path" => { "$ref" => "#/definitions/absolute_path" },
      "content_id" => { "$ref" => "#/definitions/guid" },
    )

    properties
  end

  def frontend_link_names
    publisher_links.fetch("properties", {}).keys + LINK_NAMES_ADDED_BY_PUBLISHING_API
  end

  def frontend_link_properties
    frontend_link_names.inject({}) do |hash, link_name|
      hash.merge(link_name => frontend_links_ref)
    end
  end

  def frontend_links
    clone_hash(publisher_links || {}).merge(
      "additionalProperties" => false,
      "type" => "object",
      "properties" => frontend_link_properties
    )
  end

  def publisher_definitions
    clone_hash(publisher_schema.schema["definitions"]) || {}
  end

  def converted_definitions
    resolve_multiple_content_types(publisher_definitions.reject { |k| k == "links" }).tap do |converted|
      if change_history_required?
        converted["details"]["required"] << "change_history"
      end

      if details_should_contain_change_history?(converted)
        converted["details"]["properties"]["change_history"] = { "$ref"=>"#/definitions/change_history" }
      end
   end
  end

  def change_history_required?
    CHANGE_HISTORY_REQUIRED.include?(format_name)
  end

  def details_should_contain_change_history?(definition)
    return if !definition.dig("details", "properties") || definition["details"]["properties"]["change_history"]
    publisher_properties.has_key?("change_note")
  end

  def frontend_definitions
    {
      "frontend_links" => frontend_links_definition.schema.reject { |k| k == "$schema" }
    }.merge(converted_definitions)
  end

  def updated_at
    {
      "type" => "string",
      "format" => "date-time"
    }
  end

  def frontend_links_ref
    { "$ref" => "#/definitions/frontend_links" }
  end

  def multiple_content_types_ref
    { "$ref" => "#/definitions/multiple_content_types" }
  end

  def resolve_multiple_content_types(object)
    if object == multiple_content_types_ref
      { "type" => "string" }
    elsif object.is_a?(Hash)
      object.each.with_object({}) do |(key, value), hash|
        hash.merge!(key => resolve_multiple_content_types(value))
      end
    elsif object.is_a?(Array)
      object.map { |element| resolve_multiple_content_types(element) }
    else
      object
    end
  end
end
