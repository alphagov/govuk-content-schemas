{
  government: {
    type: "object",
    additionalProperties: false,
    required: [
      "title",
      "slug",
      "current",
    ],
    properties: {
      title: {
        type: "string",
        description: "Name of the government that first published this document, eg '1970 to 1974 Conservative government'.",
      },
      slug: {
        type: "string",
        description: "Government slug, used for analytics, eg '1970-to-1974-conservative-government'.",
      },
      current: {
        type: "boolean",
        description: "Is the government that published this document still the current government.",
      },
    },
  },
  image: {
    type: "object",
    additionalProperties: false,
    required: [
      "url",
    ],
    properties: {
      url: {
        type: "string",
        format: "uri",
      },
      alt_text: {
        type: "string",
      },
      caption: {
        anyOf: [
          {
            type: "string",
          },
          {
            type: "null",
          },
        ],
      },
    },
  },
  people: {
    type: "array",
    items: {
      type: "object",
      additionalProperties: false,
      required: [
        "name",
        "role",
        "href",
      ],
      properties: {
        name_prefix: {
          type: [
            "string",
            "null",
          ],
        },
        name: {
          type: "string",
        },
        role: {
          type: "string",
        },
        href: {
          type: "string",
        },
        role_href: {
          type: [
            "string",
            "null",
          ],
        },
        image: {
          "$ref": "#/definitions/image",
        },
        payment_type: {
          type: [
            "string",
            "null",
          ],
        },
        attends_cabinet_type: {
          type: [
            "string",
            "null",
          ],
        },
      },
    },
    description: "A list of people. Turn into proper links once organisations, people and roles are fully migrated.",
  },
  summary_organisations: {
    type: "array",
    items: {
      type: "object",
      additionalProperties: false,
      required: [
        "title",
        "href",
        "separate_website",
      ],
      properties: {
        title: {
          type: "string",
        },
        href: {
          type: "string",
        },
        brand: {
          type: [
            "string",
            "null",
          ],
        },
        logo: {
          type: "object",
          properties: {
            formatted_title: {
              type: "string",
            },
            crest: {
              type: [
                "string",
                "null",
              ],
              enum: [
                "bis",
                "dit",
                "eo",
                "hmrc",
                "ho",
                "mod",
                "portcullis",
                "single-identity",
                "so",
                "ukaea",
                "wales",
                null,
              ],
            },
            image: {
              "$ref": "#/definitions/image",
            },
          },
        },
        separate_website: {
          type: "boolean",
        },
        works_with: {
          type: "object",
          additionalProperties: false,
          properties: {
            adhoc_advisory_group: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            advisory_ndpb: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            civil_service: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            devolved_administration: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            executive_agency: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            executive_ndpb: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            executive_office: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            independent_monitoring_body: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            ministerial_department: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            non_ministerial_department: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            other: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            public_corporation: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            sub_organisation: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
            tribunal_ndpb: {
              "$ref": "#/definitions/list_of_sub_organisations",
            },
          },
        },
      },
    },
    description: "A list of all organisations of a particular type. Turn into proper links once details for organisations no longer need to be expanded.",
  },
  list_of_sub_organisations: {
    type: "array",
    items: {
      type: "object",
      additionalProperties: false,
      required: [
        "title",
        "href",
      ],
      properties: {
        title: {
          type: "string",
        },
        href: {
          type: "string",
        },
      },
    },
    description: "A list of all sub-organisations of a particular type for a parent organisation. Turn into proper links once details for organisations no longer need to be expanded.",
  },
  political: {
    type: "boolean",
    description: "If the content is considered political in nature, reflecting views of the government it was published under.",
  },
  emphasised_organisations: {
    description: "The content ids of the organisations that should be displayed first in the list of organisations related to the item, these content ids must be present in the item organisation links hash.",
    type: "array",
    items: {
      "$ref": "#/definitions/guid",
    },
  },
  attachments_with_thumbnails: {
    description: "An ordered list of attachments",
    type: "array",
    items: {
      description: "Generated HTML for each attachment including thumbnail and download link",
      type: "string",
    },
  },
  first_public_at: {
    description: "DEPRECATED. The date the content was first published. Used in details. Will be deprecated in favour of top level first_published_at when publishing API allows it to be edited.",
    type: "string",
    format: "date-time",
  },
}
