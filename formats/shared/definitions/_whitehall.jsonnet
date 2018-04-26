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
