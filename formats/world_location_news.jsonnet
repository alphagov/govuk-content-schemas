(import "shared/default_format.jsonnet") + {
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
         "ordered_featured_links",
         "mission_statement",
         "ordered_featured_documents"
       ],
      properties: {
        ordered_featured_links: {
          "$ref": "#/definitions/ordered_featured_links",
        },
        mission_statement: {
          type: "string"
        },
        ordered_featured_documents: {
          "$ref": "#/definitions/ordered_featured_documents",
        },
      },
    },
  },
}
