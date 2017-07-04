{
  document_type: null,
  base_path: "required",
  routes: "required",
  redirects: "forbidden",
  title: "required",
  description: "optional",
  rendering_app: "required",
  details: {
    required: true,
    definition: "details"
  },
  definitions: {

  },
  edition_links: import "_base_edition_links.jsonnet",
  links: import "_base_links.jsonnet"
}
