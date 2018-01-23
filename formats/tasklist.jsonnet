{
  base_path: "required",
  document_type: "task_list",
  publishing_app: "required",
  rendering_app: "required",
  routes: "required",
  redirects: "forbidden",
  title: "required",
  description: "optional",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      properties: {
        tasklist: {
          type: "object",
          description: "This is the tasklist structure itself",
          required: [
            "groups",
          ],
          groups: {
            type: "array",
            description: "This is the different groups in the tasklist"
          }
        }
      }
    }
  }
}
