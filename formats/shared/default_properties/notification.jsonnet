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
  user_journey_document_supertype: {
    type: "string",
    description: "Document type grouping powering analytics of user journeys",
  },
  content_purpose_supergroup: {
    type: "string",
    description: "Document supergroup grouping documents by a purpose",
  },
  content_purpose_subgroup: {
    type: "string",
    description: "Document subgroup grouping documents by purpose. Narrows down the purpose defined in content_purpose_supergroup.",
  },
}
