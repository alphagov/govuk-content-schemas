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
  "locale": {
    "$ref": "#/definitions/locale"
  },
  "need_ids": {
    "type": "array",
    "items": {
      "type": "string"
    }
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
  "withdrawn_notice": {
    "$ref": "#/definitions/withdrawn_notice"
  },
  "last_edited_at": {
    "type": "string",
    "format": "date-time",
    "description": "Last time when the content received a major or minor update."
  },
  "update_type": {
    "enum": [
      "major",
      "minor",
      "republish"
    ]
  },
  "govuk_request_id": {
    "type": [
      "string",
      "null"
    ]
  },
  "expanded_links": {
    "type": "object",
    "patternProperties": {
      "^[a-z_]+$": {
        "$ref": "#/definitions/frontend_links"
      }
    }
  },
  "links": {
    "type": "object",
    "patternProperties": {
      "^[a-z_]+$": {
        "$ref": "#/definitions/guid_list"
      }
    }
  }
}
