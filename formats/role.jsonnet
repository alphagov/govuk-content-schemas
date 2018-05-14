(import "shared/default_format.jsonnet") + {
  definitions: (import "shared/definitions/_whitehall.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        permanent_secretary: {
          type: "boolean",
        },
        cabinet_member: {
          type: "boolean",
        },
        slug: {
          type: "string",
          description: "eg: 'prime-minister'.",
        },
        whip_organisation: {
          type: [
            "string",
            "null",
          ],
          enum: [
            "Assistant Whips",
            "Baronesses and Lords in Waiting",
            "House of Commons",
            "House of Lords",
            "Junior Lords of the Treasury",
            null,
          ]
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
        seniority: {
          type: "integer",
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
            "Attends Cabinet",
            "Attends Cabinet when Ministerial responsibilities are on the agenda",
            null,
          ],
        },
        supports_historical_accounts: {
          type: "boolean",
        },
        whip_ordering: {
          type: "integer",
        },
      },
    },
  }
}
