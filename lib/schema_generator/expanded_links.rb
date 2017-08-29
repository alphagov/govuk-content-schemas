module SchemaGenerator
  class ExpandedLinks
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
    ].freeze

    def initialize(format)
      @format = format
    end

    def generate
      properties = {
        type: "object",
        additionalProperties: false,
        properties: links
      }
    end

  private

    attr_reader :format

    def links
      links = publishing_api_links.merge(content_links).merge(edition_links)
      Hash[ links.sort_by { |k| k } ]
    end

    def publishing_api_links
      LINK_TYPES_ADDED_BY_PUBLISHING_API.each_with_object({}) do |type, memo|
        memo[type] = {
          "description" => "Link type automatically added by Publishing API",
          "$ref": "#/definitions/frontend_links_with_base_path"
        }
      end
    end

    def content_links
      format.content_links.frontend_properties
    end

    def edition_links
      format.edition_links.frontend_properties
    end
  end
end
