(import "publishing_api_out.jsonnet") + {
  update_type: {
    "$ref": "#/definitions/update_type",
  },
  first_published_at: {
    "$ref": "#/definitions/first_published_at",
  },
  govuk_request_id: {
    "$ref": "#/definitions/govuk_request_id",
  },
  public_updated_at: {
    "$ref": "#/definitions/public_updated_at",
  },
  payload_version: {
    "$ref": "#/definitions/payload_version",
  },
  email_document_supertype: {
    type: "string",
    description: "Document supertype grouping intended to power the Whitehall finders and email subscriptions",
  },
  government_document_supertype: {
    type: "string",
    description: "Document supertype grouping intended to power the Whitehall finders and email subscriptions",
  },
}
