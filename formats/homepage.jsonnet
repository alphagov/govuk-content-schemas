(import "shared/default_format.jsonnet") + {
  document_type: ["homepage", "service_manual_homepage"],
  definitions: {
    details: {
      type: "object",
      properties: {},
    },
  },
  links: {
    root_taxons: "Defines a set of Taxonomy trees rooted in this node.",
  },
}
