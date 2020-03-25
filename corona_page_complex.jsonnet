(import "shared/default_format.jsonnet") + {
  document_type: "corona_page",
  base_path: "/coronavirus",
  rendering_app: "collections",
  definitions: {
    details: {
      type: "object",
      additionalProperties: true,
      properties: {
        header_section: {
          description: "Header section of page for key messages",
          type: "array",
          items: {
            type: "object",
            additionalProperties: true,
            required: [
              "top_box",
              "guidance"
            ]
            properties: {
              top_box: {
                description: "currently 'stay at home' message block",
                type: "array",
                additionalProperties: true,
                items: {
                  type: "object",
                  additionalProperties: true,
                  required: [
                    "pretext",
                    "list"
                  ],
                  properties: {
                    pretext: {
                      type: "string",
                    },
                    list: {
                      description: "An ordered list of key messages"
                      type: "array",
                      items: {
                        type: "string"
                      },
                    }
                  }
                }
              },
              guidance: {
                description: "Guidance links"
              },
            },
          },
        },
        announcements: {
          description: "The links for the announcement section",
          type: "array",
          items: {
            description: "Announcements",
            type: "object",
            additionalProperties: true,
            required: [
              "text",
              "href",
            ],
            properties: {
              text: {
                type: "string",
              },
              href: {
                type: "string",
              }
            }
          }

        },
        sections: {

        }
      }
    }
  }

}
