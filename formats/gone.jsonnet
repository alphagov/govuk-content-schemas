(import "shared/default_format.jsonnet") + {
  document_type: "gone",
  base_path: "optional",
  rendering_app: "forbidden",
  title: "forbidden",
  description: "forbidden",
  details: "optional",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        explanation: {
          type: [
            "string",
            "null",
          ],
        },
        alternative_path: {
          type: [
            "string",
            "null",
          ],
          format: "uri",
        },
      },
    },
  },
  edition_links: {},
  links: {},
  routes: "optional",
}
