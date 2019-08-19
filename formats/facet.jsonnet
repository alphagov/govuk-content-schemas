(import "shared/default_format.jsonnet") + {
  document_type: "facet",
  base_path: "optional",
  routes: "optional",
  rendering_app: "optional",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        filter_key: {
          description: "DEPRECATED - This field isn't used.",
          type: "string",
        },
        filter_value: {
          description: "DEPRECATED - This field isn't used.",
          type: "string"
        },
        key: {
          description: "DEPRECATED - This field isn't used.",
          type: "string",
        },
        keys: {
          description: "DEPRECATED - This field isn't used.",
          type: "array",
          items: {
            type: "string",
          },
        },
        filterable: {
          description: "DEPRECATED - This field isn't used.",
          type: "boolean",
        },
        display_as_result_metadata: {
          description: "DEPRECATED - This field isn't used.",
          type: "boolean",
        },
        name: {
          description: "DEPRECATED - This field isn't used.",
          type: "string",
        },
        preposition: {
          description: "DEPRECATED - This field isn't used.",
          type: "string",
        },
        short_name: {
          description: "DEPRECATED - This field isn't used.",
          type: "string",
        },
        type: {
          description: "DEPRECATED - This field isn't used.",
          type: "string",
          enum: [
            "autocomplete",
            "checkbox",
            "content_id",
            "date",
            "hidden",
            "taxon",
            "text",
            "topical",
          ],
        },
        open_value: {
          description: "DEPRECATED - This field isn't used.",
        },
        closed_value: {
          description: "DEPRECATED - This field isn't used.",
        },
        combine_mode: {
          description: "DEPRECATED - This field isn't used.",
          type: "string",
          enum: [
            "and",
            "or",
          ],
          default: "and",
        },
      },
    },
  },
  links: {
    facet_values: {
      description: "Possible facet_values to show for non-dynamic select facets. All values are shown regardless of the search.",
    },
    parent: {
      description: "The facet_group this facet belongs to.",
      maxItems: 1,
    },
  },
}
