(import "shared/default_format.jsonnet") + {
  base_path: "optional",
  routes: "optional",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        body: {
          "$ref": "#/definitions/body_html_and_govspeak",
        },
        attends_cabinet_type: {
          type: [
            "string",
            "null",
          ],
          enum: [
            "Attends Cabinet",
            "Attends Cabinet when Ministerial responsibilities are on the agenda",
            null,
          ],
        },
        role_payment_type: {
          type: [
            "string",
            "null",
          ],
          enum: [
            "Unpaid",
            "Paid as a Parliamentary Secretary",
            null,
          ],
        },
        supports_historical_accounts: {
          type: "boolean",
        },
      },
    },
  },
  edition_links: (import "shared/base_edition_links.jsonnet") + {
    ordered_parent_organisations: "Organisations that own this role.",
    ordered_current_appointments: "People who are currently assigned to this role.",
    ordered_previous_appointments: "People who were previously assigned to this role.",
  },
}
