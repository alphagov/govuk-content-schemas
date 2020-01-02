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
          filter_values: {
            type: "array",
            items: {
              type: "string"
            }
          },
          key: {
            type: "string",
          },
          content_id: {
            type: "string",
            description: "Content id corresponding to the facet value, required by the email-alert-api for constructing facet value linked subscriber lists.",
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
              option_lookup: {
                description: "An array of key values where the key is the value of a selected facet and the value(s) are what these are converted to in a Rummager query",
                type: "object",
                additionalProperties: true,
                patternProperties: {
                  "^[a-z_]+$": {
                    type: "array",
                    items: {
                      type: "string"
                    }
                  }
                }
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
            content_purpose_subgroup: {
              type: "array",
              items: {
                type: "string",
              },
            },
            content_purpose_supergroup: {
              type: "string",
            },
            all_part_of_taxonomy_tree: {
              type: "string"
            },
            part_of_taxonomy_tree: {
              type: "string"
            },
            document_type: {
              type: "string"
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
        combine_mode: {
          type: "string",
          description: "Controls which logic facets on the subscriber list should be joined by. Default is blank which maps to 'and'",
          enum: [
            "",
            "or",
          ],
        },
      },
    },
  },
  links: (import "shared/base_links.jsonnet") + {
    related: "",
    organisations: "",
  },
}
