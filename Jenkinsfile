#!/usr/bin/env groovy

REPOSITORY = 'govuk-content-schemas'

def dependentApplications = [
  'businesssupportfinder',
  'contacts',
  'contacts-frontend',
  'collections',
  'collections-publisher',
  'content-tagger',
  'email-alert-frontend',
  'email-alert-service',
  'finder-frontend',
  'hmrc-manuals-api',
  'licencefinder',
  'manuals-frontend',
  'manuals-publisher',
  'policy-publisher',
  'publisher',
  'publishing-api',
  'service-manual-frontend',
  'service-manual-publisher',
  'specialist-frontend',
  'specialist-publisher',
  'static',
  'whitehall',
]

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  properties([
    buildDiscarder(
      logRotator(
        numToKeepStr: '50')
      ),
    [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
    [$class: 'ThrottleJobProperty',
      categories: [],
      limitOneJobWithMatchingParams: true,
      maxConcurrentPerNode: 1,
      maxConcurrentTotal: 0,
      paramsToUseForLimit: 'govuk-content-schemas',
      throttleEnabled: false,
      throttleOption: 'category'],
  ])

  try {
    stage("Checkout") {
      checkout scm
    }

    stage("Merge master") {
      govuk.mergeMasterBranch();
    }

    stage("bundle install") {
      govuk.bundleApp();
    }

    stage("Run tests") {
      govuk.runRakeTask("spec")
    }

    stage("Check generated schemas are up-to-date") {
      govuk.runRakeTask("clean build")
      schemasAreUpToDate = sh(script: "git diff --exit-code", returnStatus: true) == 0

      if (!schemasAreUpToDate) {
        error("Changes to checked-in files detected after running 'rake clean' "
          + "and 'rake build'. If these are generated files, you might need to "
          + "'rake clean build' to ensure they are regenerated and push the "
          + "changes.")
      }
    }

    if (env.BRANCH_NAME == 'master') {
      stage("Push release tag") {
        govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
      }

      govuk.deployIntegration(REPOSITORY, env.BRANCH_NAME, 'release', 'deploy')
    }
  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }
}

// Run schema tests outside of 'node' definition, so that they do not block the
// original executor while the downstream tests are being run
stage("Check dependent projects against updated schema") {
  def dependentBuilds = [:]

  for (dependentApp in dependentApplications) {
    // Dummy parameter to prevent mutation of the parameter used inside the
    // closure below. If this is not defined, all of the builds will be for the
    // last application in the array.
    def app = dependentApp

    dependentBuilds[app] = {
      build job: "${app}/deployed-to-production",
        parameters: [
          [$class: 'BooleanParameterValue',
            name: 'IS_SCHEMA_TEST',
            value: true],
          [$class: 'StringParameterValue',
            name: 'SCHEMA_BRANCH',
            value: env.BRANCH_NAME],
        ]
    }
  }

  dependentBuilds.failFast = true

  parallel dependentBuilds
}
