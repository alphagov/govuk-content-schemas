(import "shared/default_format.jsonnet") + {
  document_type: "finder_email_signup",
  definitions: {
    subscription_list_title_prefix: {
      oneOf: [
        {
          type: "object",
          properties: {
            plural: {
              type: "string",
            },
            singular: {
              type: "string",
            },
            many: {
              type: "string",
            },
          },
        },
        {
          type: "string",
        },
      ],
    },
    facet_name: {
      oneOf: [
        {
          type: "object",
          properties: {
            plural: {
              type: "string",
            },
            singular: {
              type: "string",
            },
          },
        },
        {
          type: "string",
        },
      ],
    },
    facet_choices: {
      type: "array",
      items: {
        type: "object",
        required: [
          "key",
          "radio_button_name",
          "topic_name",
          "prechecked",
        ],
        properties: {
          key: {
            type: "string",
          },
          radio_button_name: {
            type: "string",
          },
          topic_name: {
            type: "string",
          },
          prechecked: {
            type: "boolean",
          },
        },
      },
    },
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "subscription_list_title_prefix",
      ],
      properties: {
        beta: {
          "$ref": "#/definitions/finder_beta",
        },
        email_signup_choice: {
          "$ref": "#/definitions/facet_choices",
        },
        email_filter_name: {
          oneOf: [
            {
              "$ref": "#/definitions/facet_name"
            },
            {
              type: "null",
            },
          ]
        },
        email_filter_by: {
          oneOf: [
            {
              type: "string",
            },
            {
              type: "null",
            },
          ],
        },
        email_filter_facets : {
          type: "array",
          items: {
            type: "object",
            required: [
              "facet_id",
              "facet_name",
            ],
            properties: {
              facet_id: {
                type: "string",
              },
              facet_name: {
                "$ref": "#/definitions/facet_name"
              },
              facet_choices: {
                "$ref": "#/definitions/facet_choices",
              },
              filter_key: {
                type: "string",
              },
              filter_value: {
                type: "string",
              },
            },
          },
        },
        subscription_list_title_prefix: {
          "$ref": "#/definitions/subscription_list_title_prefix",
        },
        filter: {
          type: "object",
          additionalProperties: false,
          properties: {
            content_purpose_supergroup: {
              type: "string",
            },
          },
        },
        reject: {
          type: "object",
          additionalProperties: false,
          properties: {
            content_purpose_supergroup: {
              type: "string",
            },
          },
        },
      },
    },
  },
  links: (import "shared/base_links.jsonnet") + {
    related: "",
    organisations: "",
  },
}
