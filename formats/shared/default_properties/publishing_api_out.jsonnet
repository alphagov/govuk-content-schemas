(import "all.jsonnet") + {
  content_id: {
    "$ref": "#/definitions/guid",
  },
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
  search_keywords: {
   "$ref": "#/definitions/search_keywords",
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
    description: "Document supertype grouping documents by user need",
  },
  withdrawn_notice: {
    "$ref": "#/definitions/withdrawn_notice",
  },
}
