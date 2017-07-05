(import "shared/default_format.jsonnet") + {
  document_type: "working_group",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        email: {
          type: "string"
        },
        body: {
          "$ref": "#/definitions/body"
        }
      }
    }
  }
}
