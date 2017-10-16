(import "shared/default_format.jsonnet") + {
  document_type: "local_transaction",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "lgsl_code",
        "service_tiers",
      ],
      properties: {
        lgsl_code: {
          description: "The Local Government Service List code for the local transaction service",
          type: "integer",
        },
        lgil_override: {
          description: "[DEPRECATED]The Local Government Interaction List override code for the local transaction interaction",
          anyOf: [
            {
              type: "integer",
            },
            {
              type: "null",
            },
          ],
        },
        lgil_code: {
          description: "The Local Government Interaction List code for the local transaction interaction",
          anyOf: [
            {
              type: "integer",
            },
            {
              type: "null",
            },
          ],
        },
        service_tiers: {
          description: "List of local government tiers that provide the service",
          type: "array",
          items: {
            type: "string",
          },
        },
        introduction: {
          "$ref": "#/definitions/body_html_and_govspeak",
        },
        more_information: {
          "$ref": "#/definitions/body_html_and_govspeak",
        },
        need_to_know: {
          "$ref": "#/definitions/body_html_and_govspeak",
        },
        external_related_links: {
          "$ref": "#/definitions/external_related_links",
        },
      },
    },
  },
}
