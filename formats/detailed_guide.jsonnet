(import "shared/default_format.jsonnet") + {
  document_type: [
    "detailed_guide",
    "detailed_guidance",
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
        related_mainstream_content: {
          description: "The ordered list of related and additional mainstream content item IDs. Use in conjunction with the (unordered) `related_mainstream_content` link.",
          type: "array",
          items: {
            "$ref": "#/definitions/guid",
          },
        },
        first_public_at: {
          "$ref": "#/definitions/first_public_at",
        },
        image: {
          "$ref": "#/definitions/image",
        },
        change_history: {
          "$ref": "#/definitions/change_history",
        },
        alternative_scotland_url: {
          type: "string",
        },
        alternative_wales_url: {
          type: "string",
        },
        alternative_nothern_ireland_url: {
          type: "string",
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
        emphasised_organisations: {
          "$ref": "#/definitions/emphasised_organisations",
        },
        national_applicability: {
          "$ref": "#/definitions/national_applicability",
        },
        has_brexit_update: {
          "$ref": "#/definitions/has_brexit_update",
        },
      },
    },
  },
  links: (import "shared/base_links.jsonnet") + {
    related_guides: "",
    related_policies: "",
    related_mainstream_content: "",
  },
}
