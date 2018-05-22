(import "shared/default_format.jsonnet") + {
  base_path: "optional",
  routes: "optional",
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        body: {
          "$ref": "#/definitions/body_html_and_govspeak",
        },
        role_type: {
          type: "string",
          enum: [
            "Ambassador",
            "BoardMember",
            "ChiefProfessionalOfficer",
            "ChiefScientificAdvisor",
            "DeputyHeadOfMission",
            "Governor",
            "HighCommissioner",
            "Military",
            "Ministerial",
            "SpecialRepresentative",
            "TrafficCommissioner",
            "WorldwideOfficeStaff",
          ]
        },
        attends_cabinet_type: {
          type: [
            "string",
            "null",
          ],
          enum: [
            "Attends Cabinet",
            "Attends Cabinet when Ministerial responsibilities are on the agenda",
            null,
          ],
        },
        role_payment_type: {
          type: [
            "string",
            "null",
          ],
          enum: [
            "Unpaid",
            "Paid as a Parliamentary Secretary",
            null,
          ],
        },
        supports_historical_accounts: {
          type: "boolean",
        },
      },
    },
  }
}
