(import "shared/default_format.jsonnet") + {
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        analytics_identifier: {
          "$ref": "#/definitions/analytics_identifier",
        },
        body: {
          "$ref": "#/definitions/body_html_and_govspeak",
        },
        full_name: {
          type: "string",
          description: "Name of the person, including titles and any letters, eg: 'Sir Lord Snoopy DOG'",
        },
        minister: {
          type: "boolean",
        },
        privy_counsellor: {
          type: "boolean",
        },
        image: {
          "$ref": "#/definitions/image",
        },
      },
    },
  },
  edition_links: (import "shared/base_edition_links.jsonnet") + {
    ordered_current_appointments: "Roles that are currently assigned to this person.",
    ordered_previous_appointments: "Roles that were previously assigned to this person.",
  },
}
