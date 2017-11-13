(import "shared/default_format.jsonnet") + {
  document_type: "guide",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        parts: {
          description: "List of guide parts",
          "$ref": "#/definitions/parts",
        },
        external_related_links: {
          "$ref": "#/definitions/external_related_links",
        },
      },
    },
  },
}
