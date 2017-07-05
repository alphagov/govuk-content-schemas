(import "shared/default_format.jsonnet") + {
  document_type: "finder_email_signup",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "email_signup_choice",
        "email_filter_by",
        "subscription_list_title_prefix"
      ],
      properties: {
        beta: {
          "$ref": "#/definitions/finder_beta"
        },
        email_signup_choice: {
          type: "array",
          items: {
            type: "object",
            required: [
              "key",
              "radio_button_name",
              "topic_name",
              "prechecked"
            ],
            properties: {
              key: {
                type: "string"
              },
              radio_button_name: {
                type: "string"
              },
              topic_name: {
                type: "string"
              },
              prechecked: {
                type: "boolean"
              }
            }
          }
        },
        email_filter_by: {
          oneOf: [
            {
              type: "string"
            },
            {
              type: "null"
            }
          ]
        },
        email_filter_name: {
          oneOf: [
            {
              type: "object",
              properties: {
                plural: {
                  type: "string"
                },
                singular: {
                  type: "string"
                }
              }
            },
            {
              type: "string"
            },
            {
              type: "null"
            }
          ]
        },
        subscription_list_title_prefix: {
          oneOf: [
            {
              type: "object",
              properties: {
                plural: {
                  type: "string"
                },
                singular: {
                  type: "string"
                },
                many: {
                  type: "string"
                }
              }
            },
            {
              type: "string"
            }
          ]
        }
      }
    }
  },
  links: (import "shared/base_links.jsonnet") + {
    related: "",
    organisations: "",
  }
}
