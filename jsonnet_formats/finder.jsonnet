(import "shared/default_format.jsonnet") + {
  document_type: "finder",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "document_noun",
        "facets"
      ],
      properties: {
        beta: {
          "$ref": "#/definitions/finder_beta"
        },
        beta_message: {
          "anyOf": [
            {
              "type": "string"
            },
            {
              "type": "null"
            }
          ]
        },
        document_noun: {
          "$ref": "#/definitions/finder_document_noun"
        },
        default_documents_per_page: {
          "$ref": "#/definitions/finder_default_documents_per_page"
        },
        logo_path: {
          "type": "string"
        },
        default_order: {
          "$ref": "#/definitions/finder_default_order"
        },
        filter: {
          "$ref": "#/definitions/finder_filter"
        },
        reject: {
          "$ref": "#/definitions/finder_reject_filter"
        },
        facets: {
          "$ref": "#/definitions/finder_facets"
        },
        format_name: {
          "type": "string"
        },
        show_summaries: {
          "$ref": "#/definitions/finder_show_summaries"
        },
        summary: {
          "$ref": "#/definitions/finder_summary"
        }
      }
    }
  },
  links: (import "shared/base_links.jsonnet") + {
    related: "",
    email_alert_signup: "",
    available_translations: ""
  }
}
