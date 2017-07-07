(import "shared/default_format.jsonnet") + {
  document_type: "take_part",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "image",
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body",
        },
        image: {
          "$ref": "#/definitions/image",
        },
      },
    },
  },
}
