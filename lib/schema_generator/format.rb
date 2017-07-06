require "yaml"

module SchemaGenerator
  class Format

    ALWAYS_REQUIRED = %w(publishing_app locale document_type schema_name)
    SOURCE_PROPERTIES = %w(base_path routes redirects title description details)

    attr_reader :schema_name

    def initialize(schema_name, data)
      @schema_name = schema_name
      @data = data
    end

    def publisher_content_schema
      schema = base_schema.merge(
        required: content_schema_required_fields,
        properties: content_schema_properties
      )
      schema[:definitions] = DefinitionsResolver.new(
        schema[:properties],
        Jsonnet.load("jsonnet_formats/shared/shared_definitions.jsonnet").merge(data["definitions"])
      ).call
      schema
    end

    def publisher_links_schema
      schema = base_schema.merge(
        properties: links_schema_properties
      )
      schema[:definitions] = DefinitionsResolver.new(
        schema[:properties],
        Jsonnet.load("jsonnet_formats/shared/shared_definitions.jsonnet").merge(data["definitions"])
      ).call
      schema
    end

    def notification_schema
      convert_to_notifcation(publisher_content_schema)
    end

  private

    attr_reader :data

    def content_schema_required_fields
      required_source_properties = SOURCE_PROPERTIES.select do |property|
        data[property] == "required" || data[property]["required"]
      end
      (ALWAYS_REQUIRED + required_source_properties).sort
    end

    def content_schema_properties
      customisable = {
        base_path: schema_property(data["base_path"], "$ref": "#/definitions/absolute_path"),
        title: schema_property(data["title"], type: "string"),
        description: schema_property(data["description"], type: "string"),
        routes: routes_property(data["routes"]),
        redirects: redirects_property(data["redirects"]),
        details: schema_property(data["details"], "$ref": "#/definitions/details"),
        document_type: document_type_property(data["document_type"]),
        links: LinksIn.call(data["edition_links"]),
        rendering_app: schema_property(data["rendering_app"], "$ref": "#/definitions/rendering_app_name"),
      }.delete_if { |_, v| v.nil? }

      customisable.merge(consistent_schema_properties)
    end

    def links_schema_properties
      {
        previous_version: { type: "string" },
        links: LinksIn.call(data["links"])
      }
    end

    def consistent_schema_properties
      Jsonnet.load("jsonnet_formats/shared/consistent_schema_properties.jsonnet")
    end

    def schema_property(definition, default)
      definition_hash = definition_as_hash(definition)
      return if definition_hash["forbidden"]

      type = definition_or_default(definition_hash["definition"], default)

      definition["required"] ? type : { anyOf: [type, { type: "null" }] }
    end

    def routes_property(property)
      return if property == "forbidden"

      definition = {
        type: "array",
        items: {
          "$ref": "#/definitions/route"
        }
      }

      definition[:minItems] = 1 if property == "required"
      definition
    end

    def build_definitions(definitions)
      shared_definitions = Jsonnet.load("jsonnet_formats/shared/shared_definitions.jsonnet")
      shared_definitions.merge(data["definitions"]).delete_if do |k, v|
        !definitions.include?(k)
      end
    end

    def extract_definitions(properties)
      definitions = properties.inject([]) do |memo, (k, v)|
        next memo + extract_definitions(v) if v.is_a?(Hash)
        k.to_s == "$ref" ? memo << v.sub("#/definitions/", "") : memo
      end
      definitions.uniq
    end

    def redirects_property(property)
      return if property == "forbidden"

      definition = {
        type: "array",
        items: {
          "$ref": "#/definitions/redirect_route"
        }
      }

      definition[:minItems] = 1 if property == "required"
      definition
    end

    def document_type_property(property)
      return { "$ref": "#/definitions/document_type" } unless property
      { enum: Array(property), type: "string" }
    end

    def definition_as_hash(definition)
      definition.is_a?(Hash) ? definition : { definition => true }
    end

    def definition_or_default(definition, default)
      return default unless definition

      if definition.is_a?(Hash)
        definition
      else
        { "$ref" => "#/definitions/#{definition}" }
      end
    end

    def base_schema
      {
        "$schema": "http://json-schema.org/draft-04/schema#",
        type: "object",
        additionalProperties: false
      }
    end

    def convert_to_notifcation(schema)
      schema
    end

    class LinksIn
      def self.call(defined_links)
        self.new(defined_links).call
      end

      def initialize(defined_links)
        @links = normalise_links(defined_links)
        @required = determine_required(defined_links)
      end

      def call
        properties = {
          type: "object",
          additionalProperties: false,
          properties: links
        }
        properties[:required] = required unless required.empty?
        properties
      end

    private
      attr_reader :links, :required

      def determine_required(defined_links)
        defined_links.select { |link| link["required"] }.keys
      end

      def normalise_links(defined_links)
        defined_links.each_with_object({}) do |(k, v), hash|
          if v.is_a?(Hash)
            definition = v.clone.delete_if { |k| k == "required" }
              .merge("$ref": "#/definitions/guid_list")
          else
            definition = {
              description: v,
              "$ref": "#/definitions/guid_list"
            }
          end

          hash[k] = definition
        end
      end
    end

    class DefinitionsResolver
      def initialize(properties, definitions)
        @properties = properties
        @definitions = definitions
      end

      def call
        definitions_from_properties = extract_definitions(properties)
        definitions_with_dependencies = resolve_depenencies(
          definitions_from_properties, definitions_from_properties
        )

        definitions.clone.delete_if { |k, _| !definitions_with_dependencies.include?(k) }

      end

    private

      attr_reader :properties, :definitions

      def definition_dependencies
        @definition_dependencies ||= calculate_definition_dependencies
      end

      def calculate_definition_dependencies
        definitions.each_with_object({}) do |(k, v), memo|
          memo[k] = extract_definitions(v)
        end
      end

      def extract_definitions(properties)
        definitions = properties.inject([]) do |memo, (key, value)|
          if value.is_a?(Hash)
            memo + extract_definitions(value)
          elsif value.respond_to?(:map)
            memo + value.flat_map { |item| item.is_a?(Hash) ? extract_definitions(item) : nil }
          else
            key.to_s == "$ref" ? memo << value.sub("#/definitions/", "") : memo
          end
        end
        definitions.compact.uniq
      end

      def resolve_depenencies(definition_names, dependencies_found = [])
        names = definition_names.flat_map do |name|
          dependencies = definition_dependencies[name]
          raise "Undefined definition: #{name}" unless dependencies
          new_dependencies = dependencies - dependencies_found
          current_dependencies = dependencies_found + new_dependencies
          current_dependencies + resolve_depenencies(new_dependencies, current_dependencies)
        end
        names.uniq
      end
    end
  end
end
