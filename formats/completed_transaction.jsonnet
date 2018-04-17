(import "shared/default_format.jsonnet") + {
  document_type: "completed_transaction",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        external_related_links: {
          "$ref": "#/definitions/external_related_links",
        },
        promotion: {
          type: "object",
          additionalProperties: false,
          required: [
            "category",
            "url",
          ],
          properties: {
            category: {
              enum: [
                "mot_reminder",
                "organ_donor",
                "register_to_vote",
              ],
            },
            url: {
              type: "string",
              format: "uri",
            },
          },
        },
      },
    },
  },
}
