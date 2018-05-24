(import "shared/default_format.jsonnet") + {
  base_path: "forbidden",
  routes: "forbidden",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        started_on: {
          type: "string",
          format: "date-time",
        },
        ended_on: {
          type: [
            "string",
            "null",
          ],
          format: "date-time",
        },
      },
    },
  },
  edition_links: (import "shared/base_edition_links.jsonnet") + {
    person: "The person that is currently appointed to the relevant role.",
    role: "The role that the relevant person is currently appointed to.",
  },
}
