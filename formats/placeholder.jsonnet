(import "shared/default_format.jsonnet") + {
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        analytics_identifier: {
          "$ref": "#/definitions/analytics_identifier",
        },
        change_note: {
          "$ref": "#/definitions/change_note",
        },
        start_date: {
          type: "string",
          format: "date-time",
          description: "Used for topical events, so that related documents can get the date. Remove when topical events are migrated.",
        },
        end_date: {
          type: "string",
          format: "date-time",
          description: "Used for topical events, so that related documents can get the date. Remove when topical events are migrated.",
        },
        brand: {
          type: [
            "string",
            "null",
          ],
          description: "Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.",
        },
        logo: {
          type: "object",
          properties: {
            formatted_title: {
              type: "string",
              description: "Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.",
            },
            crest: {
              type: [
                "string",
                "null",
              ],
              enum: [
                "bis",
                "eo",
                "hmrc",
                "ho",
                "mod",
                "portcullis",
                "single-identity",
                "so",
                "ukaea",
                "wales",
                null,
              ],
              description: "Used for organisations, to allow us to publish branding / logo information. Remove when organisations are migrated.",
            },
            image: {
              description: "An image for organisations that use a custom logo",
              "$ref": "#/definitions/image",
            },
          },
        },
        external_related_links: {
          "$ref": "#/definitions/external_related_links",
        },
        tags: {
          "$ref": "#/definitions/tags",
        },
      },
    },
  },
  edition_links: (import "shared/base_edition_links.jsonnet") + {
    featured_policies: "Featured policies primarily for use with Whitehall organisations",
  },
}
