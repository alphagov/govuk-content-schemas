(import "shared/default_format.jsonnet") + {
  document_type: "policy",
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "document_noun",
        "facets",
      ],
      properties: {
        internal_name: {
          "$ref": "#/definitions/taxonomy_internal_name",
        },
        document_noun: {
          "$ref": "#/definitions/finder_document_noun",
        },
        default_documents_per_page: {
          "$ref": "#/definitions/finder_default_documents_per_page",
        },
        email_signup_enabled: {
          type: "boolean",
        },
        default_order: {
          "$ref": "#/definitions/finder_default_order",
        },
        emphasised_organisations: {
          "$ref": "#/definitions/emphasised_organisations",
        },
        filter: {
          "$ref": "#/definitions/finder_filter",
        },
        facets: {
          "$ref": "#/definitions/finder_facets",
        },
        human_readable_finder_format: {
          type: "string",
        },
        show_summaries: {
          "$ref": "#/definitions/finder_show_summaries",
        },
        summary: {
          "$ref": "#/definitions/finder_summary",
        },
        nation_applicability: {
          description: "TODO: Switch to using national_applicability pattern",
          type: "object",
          additionalProperties: false,
          required: [
            "applies_to",
            "alternative_policies",
          ],
          properties: {
            applies_to: {
              type: "array",
              items: {
                type: "string",
              },
            },
            alternative_policies: {
              type: "array",
              items: {
                type: "object",
                required: [
                  "nation",
                  "alt_policy_url",
                ],
                properties: {
                  nation: {
                    type: "string",
                  },
                  alt_policy_url: {
                    type: "string",
                  },
                },
              },
            },
          },
        },
      },
    },
  },
  links: (import "shared/base_links.jsonnet") + {
    people: "",
    working_groups: "",
    lead_organisations: "DEPRECATED: A subset of organisations that should be emphasised in relation to this content item. All organisations specified here should also be part of the organisations array.",
    related: "",
    email_alert_signup: "",
    available_translations: "",
  },
}
