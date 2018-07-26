(import "shared/default_format.jsonnet") + {
  document_type: [
    "press_release",
    "news_story",
    "government_response",
    "world_news_story",
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
        image: {
          "$ref": "#/definitions/image",
        },
        first_public_at: {
          "$ref": "#/definitions/first_public_at",
        },
        change_history: {
          "$ref": "#/definitions/change_history",
        },
        tags: {
          "$ref": "#/definitions/tags",
        },
        emphasised_organisations: {
          "$ref": "#/definitions/emphasised_organisations",
        },
        government: {
          "$ref": "#/definitions/government",
        },
        political: {
          "$ref": "#/definitions/political",
        },
      },
    },
  },
  links: (import "shared/base_links.jsonnet") + {
    related_policies: "",
    ministers: "",
    topical_events: "",
    world_locations: "",
    worldwide_organisations: "",
    roles: "Used to power Email Alert Api subscriptions for Whitehall content",
    people: "Used to power Email Alert Api subscriptions for Whitehall content",
  },
}
