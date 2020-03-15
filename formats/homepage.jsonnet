(import "shared/default_format.jsonnet") + {
  document_type: ["homepage", "service_manual_homepage"],
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        global: {
          "$ref": "#/definitions/global",
        },
      },
    },
  },
  links: {},
}
