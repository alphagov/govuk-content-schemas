(import "shared/default_format.jsonnet") + {
  document_type: "manual_section",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "manual",
        "organisations"
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body_html_and_govspeak"
        },
        attachments: {
          "$ref": "#/definitions/asset_link_list"
        },
        manual: {
          "$ref": "#/definitions/manual_section_parent"
        },
        organisations: {
          "$ref": "#/definitions/manual_organisations"
        }
      }
    }
  },
  links: (import "shared/base_links.jsonnet") + {
    organisations: "",
    manual: "",
    available_translations: ""
  }
}
