(import "all.jsonnet") + {
  email_document_supertype: {
    type: "string",
    description: "Document supertype grouping intended to power the Whitehall finders and email subscriptions",
  },
  government_document_supertype: {
    type: "string",
    description: "Document supertype grouping intended to power the Whitehall finders and email subscriptions",
  },
  navigation_document_supertype: {
    type: "string",
    description: "Document type grouping powering the new taxonomy-based navigation pages",
  },
  publishing_request_id: {
    "$ref": "#/definitions/publishing_request_id",
  },
  search_user_need_document_supertype: {
    type: "string",
    description: "Document supertype grouping core and government documents",
  },
  user_journey_document_supertype: {
    type: "string",
    description: "Document type grouping powering analytics of user journeys",
  },
  user_need_document_supertype: {
    type: "string",
    description: "DEPRECATED. Use `content_purpose_document_supertype`.",
  },
  content_purpose_document_supertype: {
    type: "string",
    description: "Document supertype grouping documents by purpose",
  },
  withdrawn_notice: {
    "$ref": "#/definitions/withdrawn_notice",
  },
}
