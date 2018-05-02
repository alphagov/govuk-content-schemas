(import "shared/default_format.jsonnet") + {
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {},
    },
  },
  links: (import "shared/base_links.jsonnet") + {
    ordered_executive_offices: "All organisations of the type 'executive office', ordered alphabetically ignoring any prefixes.",
    ordered_ministerial_departments: "All organisations of the type 'ministerial department', ordered alphabetically ignoring any prefixes.",
    ordered_non_ministerial_departments: "All organisations of the type 'non-ministerial department', ordered alphabetically ignoring any prefixes.",
    ordered_agencies_and_other_public_bodies: "All organisations of the type 'agency' and other public bodies, ordered alphabetically ignoring any prefixes.",
    ordered_high_profile_groups: "All organisations that have a parent organisation, ordered alphabetically ignoring any prefixes.",
    ordered_public_corporations: "All organisations of the type 'public corporation', ordered alphabetically ignoring any prefixes.",
    ordered_devolved_administrations: "All organisations of the type 'devolved administration', ordered alphabetically ignoring any prefixes.",
  },
}
