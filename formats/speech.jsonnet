(import "shared/default_format.jsonnet") + {
  document_type: [
    "speech",
    "authored_article",
    "written_statement",
    "oral_statement",
  ],
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "government",
        "political",
        "delivered_on",
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body",
        },
        first_public_at: {
          "$ref": "#/definitions/first_public_at",
        },
        speech_type_explanation: {
          description: "Details about the type of speech",
          type: "string",
        },
        speaker_without_profile: {
          description: "A speaker that does not have a GOV.UK profile (eg the Queen)",
          type: "string",
        },
        location: {
          type: "string",
        },
        delivered_on: {
          type: "string",
          format: "date-time",
        },
        government: {
          "$ref": "#/definitions/government",
        },
        political: {
          "$ref": "#/definitions/political",
        },
        has_brexit_update: {
          "$ref": "#/definitions/has_brexit_update",
        },
        image: {
          "$ref": "#/definitions/image",
        },
        change_history: {
          "$ref": "#/definitions/change_history",
        },
        emphasised_organisations: {
          "$ref": "#/definitions/emphasised_organisations",
        },
        tags: {
          "$ref": "#/definitions/tags",
        },
      },
    },
  },
  links: (import "shared/base_links.jsonnet") + {
    speaker: {
      description: "A speaker that has a GOV.UK profile",
      maxItems: 1,
    },
    related_policies: "",
    ministers: "Deprecated. These are relations to minister people pages, this is superseded by 'people'",
    topical_events: "",
    world_locations: "",
    roles: "Government roles that are associated with this document, typically the role part of a role association",
    people: "People that are associated with this document, typically the person part of a role association",
  },
}
