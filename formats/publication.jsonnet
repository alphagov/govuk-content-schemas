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
    "imported",
  ],
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "documents",
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
        brexit_no_deal_notice: {
          "$ref": "#/definitions/brexit_no_deal_notice",
        }
      },
    },
  },
  edition_links: (import "shared/whitehall_edition_links.jsonnet") + {
    ministers: "Deprecated. These are relations to minister people pages, this is superseded by 'people'",
    people: "People that are associated with this document, typically the person part of a role association",
    related_statistical_data_sets: "",
    roles: "Government roles that are associated with this document, typically the role part of a role association",
    world_locations: "",
  },
  links: (import "shared/base_links.jsonnet") + {
    government: {
      description: "The government associated with this document",
      maxItems: 1,
    },
    ministers: "Deprecated. These are relations to minister people pages, this is superseded by 'people'",
    related_policies: "",
    related_statistical_data_sets: "",
    topical_events: "",
    world_locations: "",
    roles: "Government roles that are associated with this document, typically the role part of a role association",
    people: "People that are associated with this document, typically the person part of a role association",
  },
}
