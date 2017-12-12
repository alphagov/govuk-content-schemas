(import "shared/default_format.jsonnet") + {
  document_type: ["homepage", "service_manual_homepage"],
  definitions: {
    details: {
      type: "object",
      properties: {},
    },
  },
  links: {
    root_taxons: {
      description: "Defines a set of Taxonomy trees rooted in this node. (Deprecated - use level_one_taxons instead)",
    },
  },
}
