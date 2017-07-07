(import "shared/default_format.jsonnet") + {
  document_type: [
    "closed_consultation",
    "open_consultation",
    "consultation",
    "consultation_outcome",
  ],
  definitions: {
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
    ministers: "",
    people: "Used to power Email Alert Api subscriptions for Whitehall content",
    roles: "Used to power Email Alert Api subscriptions for Whitehall content",
  },
  links: (import "shared/base_links.jsonnet") + {
    related_policies: "",
    ministers: "",
    topical_events: "",
    roles: "Used to power Email Alert Api subscriptions for Whitehall content",
    people: "Used to power Email Alert Api subscriptions for Whitehall content",
  },
}
