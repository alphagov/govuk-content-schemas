(import "shared/default_format.jsonnet") + {
  document_type: [
    "about",
    "recruitment",
    "complaints_procedure",
    "about_our_services",
    "social_media_use",
    "publication_scheme",
    "our_governance",
    "procurement",
    "statistics",
    "membership",
    "research",
    "welsh_language_scheme",
    "media_enquiries",
    "access_and_opening",
    "our_energy_use",
    "personal_information_charter",
    "equality_and_diversity",
    "staff_update",
    "terms_of_reference",
    "petitions_and_campaigns"
  ],
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "organisation"
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body"
        },
        organisation: {
          description: "A single organisation that is the subject of this corporate information page",
          "$ref": "#/definitions/guid"
        },
        tags: {
          "$ref": "#/definitions/tags"
        },
        corporate_information_groups: {
          description: "Groups of corporate information to display on about pages",
          "$ref": "#/definitions/grouped_lists_of_links"
        }
      }
    }
  },
  edition_links: {
    corporate_information_pages: "",
    organisations: "All organisations linked to this content item. This should include lead organisations.",
    parent: {
      description: "The parent content item.",
      maxItems: 1,
    },
    primary_publishing_organisation: {
      description: "The organisation that published the page. Corresponds to the first of the 'Lead organisations' in Whitehall, and is empty for all other publishing applications.",
      maxItems: 1
    }
  },
  links: {
    corporate_information_pages: ""
  }
}
