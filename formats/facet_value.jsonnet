(import "shared/default_format.jsonnet") + {
  document_type: "facet_value",
  base_path: "optional",
  routes: "optional",
  rendering_app: "optional",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "label",
        "value",
      ],
      properties: {
        label: {
          description: "A human readable label",
          type: "string",
        },
        value: {
          description: "A value to use for form controls",
          type: "string",
        },
        prechecked: {
          description: "Indicates option state when presenting email signup facets.",
          type: "boolean",
        },
      },
    }
  }
}
