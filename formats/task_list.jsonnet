(import "shared/default_format.jsonnet") + {
  document_type: "task_list",
  publishing_app: "required",
  definitions: {
    details: {
      type: "object",
      additionalProperties: false,
      required: [
        "tasklist",
      ],
      properties: {
        tasklist: {
          description: "A tasklist object",
          type: "object",
        }
      }
    }
  }
}
