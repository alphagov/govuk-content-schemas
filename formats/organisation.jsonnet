(import "shared/default_format.jsonnet") + {
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        analytics_identifier: {
          "$ref": "#/definitions/analytics_identifier",
        },
        body: {
          "$ref": "#/definitions/body",
        },
        change_note: {
          "$ref": "#/definitions/change_note",
        },
        brand: {
          type: [
            "string",
            "null",
          ],
          description: "The organisation's brand class name, which is mapped to a colour in the frontend.",
        },
        foi_exempt: {
          type: "boolean",
          description: "Whether the organisation is exempt from Freedom of Information requests.",
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
          description: "The organisation's logo, including the logo image and formatted name.",
        },
        ordered_corporate_information_pages: {
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
          description: "A set of links to corporate information pages to display for the organisation.",
        },
        ordered_featured_links: {
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
          description: "A set of featured links to display for the organisation.",
        },
        ordered_featured_documents: {
          type: "array",
          items: {
            type: "object",
            additionalProperties: false,
            required: [
              "title",
              "href",
              "image",
              "summary",
              "public_updated_at",
              "document_type",
            ],
            properties: {
              title: {
                type: "string",
              },
              href: {
                type: "string",
              },
              image: {
                "$ref": "#/definitions/image",
              },
              summary: {
                type: "string",
              },
              public_updated_at: {
                type: [
                  "string",
                  "null",
                ],
              },
              document_type: {
                type: [
                  "string",
                  "null",
                ],
              },
            },
          },
          description: "A set of featured documents to display for the organisation. Turn into proper links once organisations are fully migrated.",
        },
        ordered_ministers: {
          "$ref": "#/definitions/people",
        },
        ordered_board_members: {
          "$ref": "#/definitions/people",
        },
        ordered_military_personnel: {
          "$ref": "#/definitions/people",
        },
        ordered_traffic_commissioners: {
          "$ref": "#/definitions/people",
        },
        ordered_chief_professional_officers: {
          "$ref": "#/definitions/people",
        },
        ordered_special_representatives: {
          "$ref": "#/definitions/people",
        },
        organisation_featuring_priority: {
          type: "string",
          enum: [
            "news",
            "service",
          ],
          description: "Whether to prioritise news or services on the organisation's home page.",
        },
        organisation_govuk_status: {
          type: "object",
          additionalProperties: false,
          required: [
            "status",
          ],
          properties: {
            status: {
              type: "string",
              enum: [
                "changed_name",
                "devolved",
                "exempt",
                "joining",
                "left_gov",
                "live",
                "merged",
                "no_longer_exists",
                "replaced",
                "split",
                "superseded_by_devolved_administration",
                "transitioning",
              ],
            },
            updated_at: {
              type: [
                "string",
                "null",
              ],
              format: "date-time",
            },
          },
          description: "The status of the organisation on GOV.UK.",
        },
        organisation_type: {
          type: "string",
          enum: [
            "adhoc_advisory_group",
            "advisory_ndpb",
            "civil_service",
            "court",
            "devolved_administration",
            "executive_agency",
            "executive_ndpb",
            "executive_office",
            "independent_monitoring_body",
            "ministerial_department",
            "non_ministerial_department",
            "other",
            "public_corporation",
            "sub_organisation",
            "tribunal_ndpb",
          ],
          description: "The type of organisation.",
        },
        social_media_links: {
          type: "array",
          items: {
            type: "object",
            additionalProperties: false,
            required: [
              "service_type",
              "title",
              "href",
            ],
            properties: {
              service_type: {
                type: "string",
                enum: [
                  "blog",
                  "email",
                  "facebook",
                  "flickr",
                  "foursquare",
                  "google-plus",
                  "instagram",
                  "linkedin",
                  "other",
                  "pinterest",
                  "twitter",
                  "youtube",
                ],
              },
              title: {
                type: "string",
              },
              href: {
                type: "string",
                format: "uri",
              },
            },
          },
          description: "A set of links to social media profiles for the organisation.",
        },
        external_related_links: {
          "$ref": "#/definitions/external_related_links",
        },
      },
    },
  },
  edition_links: (import "shared/base_edition_links.jsonnet") + {
    ordered_contacts: "Contact details primarily for use with Whitehall organisations.",
    ordered_featured_policies: "Featured policies primarily for use with Whitehall organisations.",
    ordered_parent_organisations: "Parent organisations primarily for use with Whitehall organisations.",
    ordered_child_organisations: "Child organisations primarily for use with Whitehall organisations.",
    ordered_successor_organisations: "Successor organisations primarily for use with closed Whitehall organisations.",
    ordered_roles: "Organisational roles primarily for use with Whitehall organisations.",
  },
}
