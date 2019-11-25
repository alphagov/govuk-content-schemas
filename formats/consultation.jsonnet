(import "shared/default_format.jsonnet") + {
  document_type: [
    "closed_consultation",
    "open_consultation",
    "consultation",
    "consultation_outcome",
  ],
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "government",
        "political",
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body",
        },
        opening_date: {
          type: "string",
          format: "date-time",
        },
        closing_date: {
          type: "string",
          format: "date-time",
        },
        government: {
          "$ref": "#/definitions/government",
        },
        political: {
          "$ref": "#/definitions/political",
        },
        image: {
          "$ref": "#/definitions/image",
        },
        held_on_another_website_url: {
          type: "string",
        },
        first_public_at: {
          "$ref": "#/definitions/first_public_at",
        },
        change_history: {
          "$ref": "#/definitions/change_history",
        },
        national_applicability: {
          "$ref": "#/definitions/national_applicability",
        },
        emphasised_organisations: {
          "$ref": "#/definitions/emphasised_organisations",
        },
        documents: {
          "$ref": "#/definitions/attachments_with_thumbnails",
        },
        ways_to_respond: {
          type: "object",
          additionalProperties: false,
          properties: {
            link_url: {
              type: "string",
            },
            email: {
              type: "string",
            },
            postal_address: {
              type: "string",
            },
            attachment_url: {
              type: "string",
            },
          },
        },
        public_feedback_publication_date: {
          type: "string",
          format: "date-time",
        },
        public_feedback_detail: {
          type: "string",
        },
        public_feedback_documents: {
          "$ref": "#/definitions/attachments_with_thumbnails",
        },
        final_outcome_publication_date: {
          type: "string",
          format: "date-time",
        },
        final_outcome_detail: {
          type: "string",
        },
        final_outcome_documents: {
          "$ref": "#/definitions/attachments_with_thumbnails",
        },
        tags: {
          "$ref": "#/definitions/tags",
        },
      },
    },
  },
  edition_links: (import "shared/whitehall_edition_links.jsonnet") + {
    government: "The government associated with this document",
    ministers: "Deprecated. These are relations to minister people pages, this is superseded by 'people'",
    people: "People that are associated with this document, typically the person part of a role association",
    roles: "Government roles that are associated with this document, typically the role part of a role association",
  },
  links: (import "shared/base_links.jsonnet") + {
    government: "The government associated with this document",
    related_policies: "",
    ministers: "Deprecated. These are relations to minister people pages, this is superseded by 'people'",
    topical_events: "",
    people: "People that are associated with this document, typically the person part of a role association",
    roles: "Government roles that are associated with this document, typically the role part of a role association",
  },
}
