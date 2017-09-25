{
  asset_link: {
    type: "object",
    additionalProperties: false,
    required: [
      "url",
      "content_type",
    ],
    properties: {
      content_id: {
        "$ref": "#/definitions/guid",
      },
      url: {
        type: "string",
        format: "uri",
      },
      content_type: {
        type: "string",
      },
      title: {
        type: "string",
      },
      created_at: {
        format: "date-time",
      },
      updated_at: {
        format: "date-time",
      },
    },
  },
  asset_link_list: {
    description: "An ordered list of asset links",
    type: "array",
    items: {
      "$ref": "#/definitions/asset_link",
    },
  },
}
