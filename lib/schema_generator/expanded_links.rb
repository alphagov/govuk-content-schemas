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

      # Taxons with a 'root_taxon' link are considered level one taxons and are linked to
      # the homepage. The homepage in turn has 'level_one_taxons' automatically added linking
      # back to the taxon.
      "level_one_taxons",

      # Content items that are linked to with a `pages_part_of_step_nav` link type
      # will automatically have a `part_of_step_navs` link type with those items
      "part_of_step_navs",

      # Taxons that have been created by merging old 'legacy' taxons will have
      # a reverse link to determine where the replacement Topic Taxonomy taxon
      # now resides
      "topic_taxonomy_taxons",
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
