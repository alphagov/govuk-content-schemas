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
      oneOf: [
        {
          type: "object",
          additionalProperties: false,
          required: [
            "email_signup_choice",
            "email_filter_by",
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
            subscription_list_title_prefix: {
              "$ref": "#/definitions/subscription_list_title_prefix",
            },
          }
        },
        {
          type: "object",
          additionalProperties: false,
          required: [
            "email_filter_facets",
            "subscription_list_title_prefix",
          ],
          properties: {
            beta: {
              "$ref": "#/definitions/finder_beta",
            },
            email_filter_facets : {
              type: "array",
              items: {
                type: "object",
                required: [
                  "facet_id",
                  "facet_name",
                  "facet_choices",
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
                },
              },
            },
            subscription_list_title_prefix: {
              "$ref": "#/definitions/subscription_list_title_prefix",
            },
          }
        },
      ],
    },
  },
  links: (import "shared/base_links.jsonnet") + {
    related: "",
    organisations: "",
  },
}
