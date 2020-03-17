(import "shared/default_format.jsonnet") + {
  document_type: "finder",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      optional: ['reshuffle'],
      properties: {
        reshuffle: {
          message: "string",
        },
      },
    },
  },
}
