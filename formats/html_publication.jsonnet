(import "shared/default_format.jsonnet") + {
  document_type: "html_publication",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "headings",
        "public_timestamp",
        "first_published_version",
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body",
        },
        headings: {
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
  },
}
