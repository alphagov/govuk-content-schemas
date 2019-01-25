{
  rendering_app: {
    description: "The application that renders this item.",
    type: "string",
    enum: [
      "calculators",
      "calendars",
      "collections",
      "email-alert-frontend",
      "email-campaign-frontend",
      "feedback",
      "finder-frontend",
      "frontend",
      "government-frontend",
      "info-frontend",
      "licencefinder",
      "manuals-frontend",
      "performanceplatform-big-screen-view",
      "publicapi",
      "rummager",
      "search-api",
      "service-manual-frontend",
      "smartanswers",
      "spotlight",
      "static",
      "tariff",
      "whitehall-admin",
      "whitehall-frontend",
    ],
  },
  rendering_app_optional: {
    anyOf: [
      {
        "$ref": "#/definitions/rendering_app",
      },
      {
        type: "null",
      },
    ],
  },
}
