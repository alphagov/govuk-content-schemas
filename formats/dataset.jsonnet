(import "shared/default_format.jsonnet") + {
  document_type: ["dataset"],

  definitions: {
    data_organisation: {
      type: "object",
      additionalProperties: false,
      properties: {
        title: { type: "string" },
        name: { type: "string" },
        description: { type: "string" },
        abbreviation: { type: "string" },
      }
    },
    datafile: {
      type: "object",
      additionalProperties: false,
      properties: {
        url: {
          type: "string",
          format: "uri",
        },
        uuid: {
          type: "string",
        },
        name: {
          type: "string",
        },
        format: {
          type: "string",
        },
        size: {
          type: "integer",
        },
        created_at: {
          type: "string",
          format: "date-time",
        },
        updated_at: {
          type: "string",
          format: "date-time",
        },
      },
    },
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        name: {
          type: "string",
        },
        frequency: {
          type: "string",
        },
        licence: {
          type: "string",
        },
        summary: {
          type: "string",
        },
        datafiles: {
          type: "array",
          items: { "$ref": "#/definitions/datafile" },
        },
        organisation: { "$ref": "#/definitions/data_organisation" },
      },
    },
  }
}
