(import "shared/default_format.jsonnet") + {
  document_type: "facet_group",
  base_path: "optional",
  routes: "optional",
  rendering_app: "optional",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "name",
        "description",
      ],
      properties: {
        name: {
          description: "Name of the facet group.",
          type: "string",
        },
        description: {
          description: "Describes the purpose or context of this facet group.",
          type: "string",
        },
      },
    },
  },
  links: {
    facets: {
      description: "Facets belonging to this group.",
    },
  }
}
