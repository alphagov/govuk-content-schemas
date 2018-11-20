(import "shared/default_format.jsonnet") + {
  document_type: "html_publication",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "public_timestamp",
        "first_published_version",
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body",
        },
        headings: {
          description: "DEPRECATED. A list of headings used to display a contents list. Superceded in https://github.com/alphagov/government-frontend/pull/384",
          type: "string",
        },
        public_timestamp: {
          type: "string",
          format: "date-time",
        },
        first_published_version: {
          type: "boolean",
        },
        isbn: {
          type: "string",
          description: "Identifies the Print ISBN to be displayed when printing an HTML Publication",
        },
        web_isbn: {
          type: "string",
          description: "Identifies the Web ISBN to be displayed when printing an HTML Publication",
        },
        print_meta_data_contact_address: {
          type: "string",
          description: "Identifies the contact address of the institution which has produced the HTML Publication. To be displayed when printing an HTML Publication",
        },
        tags: {
          "$ref": "#/definitions/tags",
        },
      },
    },
  },
  edition_links: (import "shared/base_edition_links.jsonnet") + {
    organisations: "",
    parent: "",
    primary_publishing_organisation: {
      description: "The organisation that published the page. Corresponds to the first of the 'Lead organisations' in Whitehall, and is empty for all other publishing applications.",
      maxItems: 1,
    },
    original_primary_publishing_organisation: "The organisation that published the original version of the page. Corresponds to the first of the 'Lead organisations' in Whitehall for the first edition, and is empty for all other publishing applications.",
  },
}
