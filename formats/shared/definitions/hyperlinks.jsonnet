{
  local base_hyperlink_properties = {
    href: {
      type: "string",
      format: "uri"
    },
    lang: {
      type: "string",
    },
    rel: {
      type: "string",
    }
  },
  hyperlink: {
    type: "object",
    additionalProperties: false,
    required: ["href"],
    properties: base_hyperlink_properties,
  },
  hyperlink_with_text: {
    type: "object",
    additionalProperties: false,
    required: ["href", "text"],
    properties: base_hyperlink_properties + {
      text: {
        description: "The text shown to users",
        type: "string",
      },
    },
  },
}
