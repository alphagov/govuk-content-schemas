task :regenerate do
  `rm dist/formats/**/publisher_v2/schema.json`
  `rm dist/formats/**/frontend/schema.json`

  generator = Generator.new

  Dir.glob("formats/*").each do |filename|
    generator.generate(filename)
  end
end

class Schema
  def self.read(filename)
    JSON.parse(File.read(filename))
  end
end

class Generator
  def generate(filename)
    return unless File.directory?(filename)
    schema_name = File.basename(filename)

    begin
      file = File.read("#{filename}/publisher_v2/schema.json")
      File.write("dist/#{filename}/publisher_v2/schema.json", file)
      return
    rescue Errno::ENOENT
    end

    details = Schema.read("#{filename}/publisher/details.json")

    publisher_schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "additionalProperties" => false,
      "required" => [

      ],
      "properties" => {},
      "definitions" => {
        "details" => details.slice("type", "additionalProperties", "required", "properties")
      }
    }

    publisher_schema["required"] = metadata["required"] + other_metadata["required"] + %w[document_type schema_name]

    # TODO: this can move to the initial `schema` hash. It's here to avoid diff noise.
    document_type_and_schema = {
      "document_type" => {
        "type" => "string"
      },
      "schema_name" => {
        "type" => "string",
        "enum" => [
          schema_name
        ]
      }
    }

    if schema_name == "placeholder"
      document_type_and_schema["schema_name"] = {
        "type": "string",
        "pattern": "^(placeholder|placeholder_.+)$",
        "description": "Should be of the form 'placeholder_my_format_name'. 'placeholder' is allowed for backwards compatibility.",
      }
    end

    publisher_schema["properties"] = publisher_schema["properties"]
      .merge(metadata["properties"])
      .merge(other_metadata["properties"])
      .merge(document_type_and_schema)

    publisher_schema["definitions"] = publisher_schema["definitions"]
      .merge(metadata["definitions"])
      .merge(definitions["definitions"])
      .merge(details["definitions"].to_h)

    # TODO: remove this special behaviour
    if schema_name == "contact"
      publisher_schema["required"] = publisher_schema["required"] - %w[rendering_app routes base_path]
    end

    File.write("dist/#{filename}/publisher_v2/schema.json", JSON.pretty_generate(publisher_schema) + "\n")

    # Frontend schema
    links_schema = Schema.read("formats/links_metadata.json")
    links_schema["properties"]["links"] = Schema.read("formats/base_links.json").slice("type", "additionalProperties", "properties")

    begin
      links_schema["properties"]["links"]["properties"] = Schema.read("#{filename}/publisher/links.json")["properties"].merge(links_schema["properties"]["links"]["properties"])
    rescue
    end

    links_schema["definitions"] = definitions["definitions"]
    File.write("dist/#{filename}/publisher_v2/links.json", JSON.pretty_generate(links_schema) + "\n")

    frontend_schema = FrontendSchema.new.generate(publisher_schema, links_schema)

    File.write("dist/#{filename}/frontend/schema.json", JSON.pretty_generate(frontend_schema) + "\n")
  end

  def metadata
    Schema.read("formats/metadata.json")
  end

  def definitions
    Schema.read("formats/definitions.json")
  end

  def other_metadata
    # TODO: once the v1 schemas are gone, we can merge this with `metadata.json`
    Schema.read("formats/v2_metadata.json")
  end
end

class FrontendSchema
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
  ].freeze

  def generate(publisher_schema, links_schema)
    publisher_schema["required"] = [
      "base_path",
      "links",
      "title",
      "details",
      "locale",
      "content_id",
      "document_type",
      "schema_name"
    ]

    frontend_link_names = links_schema["properties"]["links"]["properties"].keys + LINK_NAMES_ADDED_BY_PUBLISHING_API

    publisher_schema["definitions"] = {
      "frontend_links" => Schema.read("formats/frontend_links_definition.json").slice("type", "items")
    }.merge(publisher_schema["definitions"])

    publisher_schema["properties"] = publisher_schema["properties"].merge(
      "content_id" => {
        "$ref" => "#/definitions/guid"
      },
      "links" => {
        "type" => "object",
        "additionalProperties" => false,
        "properties" => frontend_link_names.inject({}) { |hash, link_name|
          hash.merge(link_name => { "$ref" => "#/definitions/frontend_links" })
        }
      },
      "format" => {
        "type" => "string",
      },
      "updated_at" => {
        "type" => "string",
        "format" => "date-time"
      },
    )

    # TODO: This is done to make sure that this rewrite produces the exact same
    # JSON as before. After this is merged we can simplify this.
    publisher_schema["properties"] = publisher_schema["properties"].slice(*%w[
      base_path title description public_updated_at first_published_at
      publishing_app rendering_app locale need_ids analytics_identifier phase
      details withdrawn_notice content_id last_edited_at links document_type
      schema_name format updated_at
    ])

    publisher_schema
  end
end

class Hash
  def slice(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end
end
