(import "shared/default_format.jsonnet") + {
  document_type: "step_by_step_nav",
  publishing_app: "required",
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
        }
      }
    }
  }
}
