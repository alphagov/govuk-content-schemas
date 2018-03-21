{
  finder_document_noun: {
    description: "How to refer to documents when presenting the search results",
    type: "string",
  },
  finder_default_documents_per_page: {
    description: "Specify this to paginate results",
    type: "integer",
  },
  finder_default_order: {
    description: "Rummager fields to order the results by",
    type: "string",
  },
  finder_filter: {
    description: "This is the fixed filter that scopes the finder",
    type: "object",
    additionalProperties: false,
    properties: {
      document_type: {
        type: "string",
      },
      organisations: {
        type: "array",
        items: {
          type: "string",
        },
      },
      policies: {
        type: "array",
        items: {
          type: "string",
        },
      },
      format: {
        type: "string",
      },
    },
  },
  finder_reject_filter: {
    description: "A fixed filter that rejects documents which match the conditions",
    type: "object",
    additionalProperties: false,
    properties: {
      policies: {
        type: "array",
        items: {
          type: "string",
        },
      },
    },
  },
  finder_facets: {
    description: "The facets shown to the user to refine their search.",
    type: "array",
    items: {
      type: "object",
      additionalProperties: false,
      required: [
        "key",
        "filterable",
        "display_as_result_metadata",
      ],
      properties: {
        filter_key: {
          description: "The exact rummager field name for this facet. Allows 'key' to be aliased to a rummager filter field",
          type: "string",
        },
        key: {
          description: "The rummager field name used for this facet.",
          type: "string",
        },
        filterable: {
          description: "This must be true to show the facet to users.",
          type: "boolean",
        },
        display_as_result_metadata: {
          description: "Include this in search result metadata. Can be set for non-filterable facets.",
          type: "boolean",
        },
        name: {
          description: "Label for the facet.",
          type: "string",
        },
        preposition: {
          description: "Text used to augment the description of the search when the facet is used.",
          type: "string",
        },
        short_name: {
          type: "string",
        },
        type: {
          description: "Defines the UI component and how the facet is queried from the search API",
          type: "string",
          enum: [
            "text",
            "date",
            "topical",
            "hidden",
          ],
        },
        allowed_values: {
          description: "Possible values to show for non-dynamic select facets. All values are shown regardless of the search.",
          type: "array",
          items: {
            "$ref": "#/definitions/label_value_pair",
          },
        },
        open_value: {
          description: "Value that determines the open state (the key field is in the future) of a topical facet.",
          "$ref": "#/definitions/label_value_pair",
        },
        closed_value: {
          description: "Value that determines the closed state (the key field is in the past) of a topical facet.",
          "$ref": "#/definitions/label_value_pair",
        },
      },
    },
  },
  finder_show_summaries: {
    type: "boolean",
  },
  finder_signup_link: {
    anyOf: [
      {
        type: "string",
      },
      {
        type: "null",
      },
    ],
  },
  finder_summary: {
    anyOf: [
      {
        type: "string",
      },
      {
        type: "null",
      },
    ],
  },
  finder_beta: {
    description: "Indicates if finder is in beta. TODO: Switch to top-level phase label",
    anyOf: [
      {
        type: "boolean",
      },
      {
        type: "null",
      },
    ],
  },
}
