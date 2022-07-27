(import "shared/default_format.jsonnet") + {
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: ["ordered_featured_links"],
      properties: {
        ordered_featured_links: {
          "$ref": "#/definitions/ordered_featured_links",
        },
      },
    },
  },
}
