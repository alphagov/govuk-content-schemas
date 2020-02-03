local FileAttachmentAssetProperties = {
  accessible: { type: "boolean", },
  alternative_format_contact_email: { type: "string", },
  attachment_type: { type: "string", enum: ["file"], },
  content_type: { type: "string", },
  file_size: { type: "integer", },
  filename: { type: "string", },
  id: { type: "string" },
  locale: { "$ref": "#/definitions/locale", },
  number_of_pages: { type: "integer", },
  preview_url: { type: "string", format: "uri", },
  title: { type: "string", },
  url: { type: "string", format: "uri", },
};

{
  image_asset: {
    type: "object",
    additionalProperties: false,
    required: [
      "content_type",
      "url",
    ],
    properties: {
      alt_text: { type: "string", },
      caption: { type: "string", },
      content_type: { type: "string", },
      credit: { type: "string", },
      url: { type: "string", format: "uri", },
    },
  },

  file_attachment_asset: {
    type: "object",
    additionalProperties: false,
    required: [
      "content_type",
      "url",
    ],
    properties: FileAttachmentAssetProperties,
  },

  specialist_publisher_attachment_asset: {
    type: "object",
    additionalProperties: false,
    required: [
      "content_id",
      "content_type",
      "url",
    ],
    properties: FileAttachmentAssetProperties + {
      content_id: { "$ref": "#/definitions/guid", },
      created_at: { format: "date-time", },
      updated_at: { format: "date-time", },
    },
  },
}
