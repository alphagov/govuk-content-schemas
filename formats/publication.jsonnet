(import "shared/default_format.jsonnet") + {
  document_type: [
    "guidance",
    "form",
    "foi_release",
    "promotional",
    "notice",
    "correspondence",
    "research",
    "official_statistics",
    "transparency",
    "statutory_guidance",
    "independent_report",
    "national_statistics",
    "corporate_report",
    "policy_paper",
    "decision",
    "map",
    "regulation",
    "international_treaty",
    "impact_assessment",
    "publication",
    "imported",
  ],
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "documents",
        "first_public_at",
        "government",
        "political",
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body",
        },
        documents: {
          "$ref": "#/definitions/attachments_with_thumbnails",
        },
        first_public_at: {
          "$ref": "#/definitions/first_public_at",
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
        government: {
          "$ref": "#/definitions/government",
        },
        political: {
          "$ref": "#/definitions/political",
        },
        national_applicability: {
          "$ref": "#/definitions/national_applicability",
        },
      },
    },
  },
  edition_links: (import "shared/whitehall_edition_links.jsonnet") + {
    ministers: "",
    people: "Used to power Email Alert Api subscriptions for Whitehall content",
    related_statistical_data_sets: "",
    roles: "Used to power Email Alert Api subscriptions for Whitehall content",
    world_locations: "",
  },
  links: (import "shared/base_links.jsonnet") + {
    ministers: "",
    related_policies: "",
    related_statistical_data_sets: "",
    topical_events: "",
    world_locations: "",
    roles: "Used to power Email Alert Api subscriptions for Whitehall content",
    people: "Used to power Email Alert Api subscriptions for Whitehall content",
  },
}
