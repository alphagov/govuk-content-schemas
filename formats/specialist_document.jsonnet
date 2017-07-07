(import "shared/default_format.jsonnet") + {
  document_type: [
    "cma_case",
    "employment_appeal_tribunal_decision",
    "dfid_research_output",
    "employment_tribunal_decision",
    "service_standard_report",
    "utaac_decision",
    "aaib_report",
    "international_development_fund",
    "countryside_stewardship_grant",
    "medical_safety_alert",
    "maib_report",
    "esi_fund",
    "tax_tribunal_decision",
    "raib_report",
    "drug_safety_update",
    "specialist_document",
    "business_finance_support_scheme",
    "vehicle_recalls_and_faults_alert",
    "asylum_support_decision",
  ],
  definitions: (import "shared/definitions/specialist_document.jsonnet") + {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "body",
        "metadata",
      ],
      properties: {
        body: {
          "$ref": "#/definitions/body_html_and_govspeak",
        },
        attachments: {
          "$ref": "#/definitions/asset_link_list",
        },
        metadata: {
          "$ref": "#/definitions/any_metadata",
        },
        max_cache_time: {
          "$ref": "#/definitions/max_cache_time",
        },
        headers: {
          "$ref": "#/definitions/nested_headers",
        },
        change_history: {
          "$ref": "#/definitions/change_history",
        },
        temporary_update_type: {
          type: "boolean",
          description: "Indicates that the user should choose a new update type on the next save.",
        },
      },
    },
  },
  edition_links: {
    finder: {
      required: true,
      description: "The finder for this specialist document.",
      minItems: 1,
      maxItems: 1,
    },
  },
}
