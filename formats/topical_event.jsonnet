(import "shared/default_format.jsonnet") + {
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        start_date: {
          type: "string",
          format: "date-time",
        },
        end_date: {
          type: "string",
          format: "date-time",
        },
        ordered_featured_documents: {
          type: "array",
          items: {
            type: "object",
            additionalProperties: false,
            required: [
              "title",
              "href",
              "image",
              "summary",
            ],
            properties: {
              title: {
                type: "string",
              },
              href: {
                type: "string",
              },
              image: {
                "$ref": "#/definitions/image",
              },
              summary: {
                type: "string",
              },
            },
          },
          description: "A set of featured documents to display for the Topical Event.",
        },
      },
    },
  },
}
