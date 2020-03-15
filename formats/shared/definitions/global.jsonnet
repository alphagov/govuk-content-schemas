{
  global: {
    type: "object",
    description: "Configuration for the header and footer chrome of GOV.UK",
    additionalProperties: false,
    required: ["header", "footer"],
    properties: {
      header: {
        "$ref": "#/definitions/global_header",
      },
      footer: {
        "$ref": "#/definitions/global_footer",
      },
    },
  },
  global_header: {
    type: "object",
    description: "Configuration for the global header options for GOV.UK",
    additionalProperties: false,
    properties: {
      alert_bar: {
        type: "object",
        description: "Used to populate a global alert across all GOV.UK pages",
        additionalProperties: false,
        required: ["heading"],
        properties: {
          alert_type: {
            type: "string",
            enum: ["warning"]
          },
          description: {
            type: "string",
          },
          description_link: {
            "$ref": "#/definitions/hyperlink",
          },
          persistent: {
            type: "boolean",
          },
          heading: {
            type: "string",
          },
          heading_link: {
            "$ref": "#/definitions/hyperlink",
          },
        },
      },
      emergency_banner: {
        type: "object",
        additionalProperties: false,
        required: ["emergency_type", "heading"],
        properties: {
          emergency_type: {
            type: "string",
            enum: ["notable_death", "national_emergency", "local_emergency"],
          },
          description: {
            type: "string",
          },
          heading: {
            type: "string",
          },
          more_info: {
            "$ref": "#/definitions/hyperlink_with_text",
          },
        },
      },
    },
  },
  global_footer: {
    type: "object",
    description: "Configuration for the global footer options for GOV.UK",
    additionalProperties: false,
    required: [
      "services_and_information_links",
      "departments_and_policy_links",
      "support_links",
    ],
    properties: {
      transition_links: {
        type: "array",
        items: {
          "$ref": "#/definitions/hyperlink_with_text",
        },
      },
      services_and_information_links: {
        type: "array",
        items: {
          "$ref": "#/definitions/hyperlink_with_text",
        },
      },
      departments_and_policy_links: {
        type: "array",
        items: {
          "$ref": "#/definitions/hyperlink_with_text",
        },
      },
      support_links: {
        type: "array",
        items: {
          "$ref": "#/definitions/hyperlink_with_text",
        },
      },
    },
  },
}
