(import "shared/default_format.jsonnet") + {
  document_type: "step_by_step_nav",
  publishing_app: "required",
  edition_links: (import "shared/base_edition_links.jsonnet") + {
    pages_part_of_step_nav: "A list of content that should be navigable via this step by step journey",
    pages_related_to_step_nav: "A list of content that is related to this step by step navigation journey"
  },
  links: {
  },
  definitions: (import "shared/definitions/_step_by_step_nav.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "step_by_step_nav",
      ],
      properties: {
        step_by_step_nav: {
          "$ref": "#/definitions/step_by_step_nav"
        },
        tags: {
          "$ref": "#/definitions/tags",
        },
      }
    }
  }
}
