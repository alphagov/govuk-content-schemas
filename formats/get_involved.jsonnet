(import "shared/default_format.jsonnet") + {
  document_type: "get_involved",

  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: ["body"],
      properties: {
        body: { type: "string" },
      },
    },
  },
}
