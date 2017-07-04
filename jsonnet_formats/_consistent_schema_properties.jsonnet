{
  "public_updated_at": {
    "$ref": "#/definitions/public_updated_at"
  },
  "first_published_at": {
    "$ref": "#/definitions/first_published_at"
  },
  "publishing_app": {
    "$ref": "#/definitions/publishing_app_name"
  },
  "rendering_app": {
    "$ref": "#/definitions/rendering_app_name"
  },
  "locale": {
    "$ref": "#/definitions/locale"
  },
  "need_ids": {
    "type": "array",
    "items": {
      "type": "string"
    }
  },
  "access_limited": {
    "$ref": "#/definitions/access_limited"
  },
  "analytics_identifier": {
    "$ref": "#/definitions/analytics_identifier"
  },
  "phase": {
    "description": "The service design phase of this content item - https://www.gov.uk/service-manual/phases",
    "type": "string",
    "enum": [
      "alpha",
      "beta",
      "live"
    ]
  },
  "details": {
    "$ref": "#/definitions/details"
  },
  "withdrawn_notice": {
    "$ref": "#/definitions/withdrawn_notice"
  },
  "change_note": {
    "type": [
      "null",
      "string"
    ]
  },
  "last_edited_at": {
    "type": "string",
    "format": "date-time",
    "description": "Last time when the content received a major or minor update."
  },
  "previous_version": {
    "type": "string"
  },
  "update_type": {
    "enum": [
      "major",
      "minor",
      "republish"
    ]
  }
}
