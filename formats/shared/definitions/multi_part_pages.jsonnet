{
  parts: {
    type: "array",
    items: {
      type: "object",
      additionalProperties: false,
      required: [
        "title",
        "slug",
        "body",
      ],
      properties: {
        title: {
          type: "string",
        },
        slug: {
          type: "string",
          format: "uri",
        },
        body: {
          "$ref": "#/definitions/body_html_and_govspeak",
        },
        hide_chapter_navigation: {
          type: "boolean",
          description: "Hide guide elements if this part is part of a step by step navigation"
        },
      },
    },
  },
}
