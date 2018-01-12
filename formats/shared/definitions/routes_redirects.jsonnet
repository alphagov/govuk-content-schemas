{
  routes: {
    type: "array",
    minItems: 1,
    items: {
      "$ref": "#/definitions/route",
    },
  },
  routes_optional: {
    type: "array",
    items: {
      ref: "#/definitions/route",
    },
  },
  redirects: {
    type: "array",
    minItems: 1,
    items: {
      "$ref": "#/definitions/redirect_route",
    },
  },
  redirects_optional: {
    type: "array",
    items: {
      "$ref": "#/definitions/redirect_route",
    },
  },
  route: {
    type: "object",
    additionalProperties: false,
    required: [
      "path",
      "type",
    ],
    properties: {
      path: {
        "$ref": "#/definitions/absolute_path",
      },
      type: {
        enum: [
          "prefix",
          "exact",
        ],
      },
    },
  },
  redirect_route: {
    type: "object",
    additionalProperties: false,
    required: [
      "path",
      "type",
      "destination",
    ],
    properties: {
      path: {
        "$ref": "#/definitions/absolute_path",
      },
      type: {
        enum: [
          "prefix",
          "exact",
        ],
      },
      destination: {
        type: "string",
        anyOf: [
          {
            "$ref": "#/definitions/absolute_fullpath",
          },
          {
            "$ref": "#/definitions/govuk_subdomain_url",
          },
        ],
      },
      segments_mode: {
        enum: [
          "preserve",
          "ignore",
        ],
        description: "For prefix redirects, preserve or ignore the rest of the fullpath. For exact, preserve or ignore the querystring.",
      },
    },
  },
  govuk_subdomain_url: {
    type: "string",
    pattern: "^https://([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[A-Za-z0-9])?\\.)*gov\\.uk(/(([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})+(/([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})*)*)?(\\?([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})*)?(#([a-zA-Z0-9._~!$&'()*+,;=:@-]|%[0-9a-fA-F]{2})*)?)?$",
    description: "A URL under the gov.uk domain with optional query string and/or fragment.",
  },
}
