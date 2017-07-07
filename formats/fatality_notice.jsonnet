(import "shared/default_format.jsonnet") + {
  document_type: "fatality_notice",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "first_public_at",
        "change_history",
        "emphasised_organisations",
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body",
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
      },
    },
  },
  edition_links: (import "shared/base_edition_links.jsonnet") + {
    field_of_operation: {
      maxItems: 1,
      minItems: 1,
    },
    ministers: "",
    organisations: "All organisations linked to this content item. This should include lead organisations.",
    people: "Used to power Email Alert Api subscriptions for Whitehall content",
    primary_publishing_organisation: {
      description: "The organisation that published the page. Corresponds to the first of the 'Lead organisations' in Whitehall, and is empty for all other publishing applications.",
      maxItems: 1,
    },
    roles: "Used to power Email Alert Api subscriptions for Whitehall content",
  },
  links: (import "shared/base_links.jsonnet") + {
    field_of_operation: {
      maxItems: 1,
    },
    ministers: "",
    people: "Used to power Email Alert Api subscriptions for Whitehall content",
    roles: "Used to power Email Alert Api subscriptions for Whitehall content",
  },
}
