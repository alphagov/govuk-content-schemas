#!/usr/bin/env groovy

library("govuk")

REPOSITORY = 'govuk-content-schemas'

def dependentApplications = [
  'collections-publisher',
  'collections',
  'contacts',
  'content-data-api',
  'content-publisher',
  'content-store',
  'content-tagger',
  'email-alert-frontend',
  'email-alert-service',
  'feedback',
  'finder-frontend',
  'frontend',
  'government-frontend',
  'hmrc-manuals-api',
  'info-frontend',
  'licencefinder',
  'manuals-frontend',
  'manuals-publisher',
  'publisher',
  'publishing-api',
  'search-api',
  'search-admin',
  'service-manual-frontend',
  'service-manual-publisher',
  'short-url-manager',
  'smartanswers',
  'specialist-publisher',
  'static',
  'travel-advice-publisher',
  'whitehall',
]

node {

  properties([
    buildDiscarder(
      logRotator(
        numToKeepStr: '50')
      ),
    [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
  ])

  try {
    stage("Checkout") {
      checkout scm
      env.GIT_COMMIT_HASH = govuk.getFullCommitHash()
    }

    stage("Merge master") {
      govuk.mergeMasterBranch();
    }

    stage("bundle install") {
      govuk.bundleApp();
    }

    stage("Lint Ruby") {
      govuk.runRakeTask("lint")
    }

    stage("Run tests") {
      govuk.runRakeTask("spec")
    }

    stage("Check generated schemas are up-to-date") {
      govuk.runRakeTask("build")
      schemasAreUpToDate = sh(script: "git diff --exit-code", returnStatus: true) == 0

      if (!schemasAreUpToDate) {
        error("Changes to checked-in files detected after running 'rake build'. "
          + "If these are generated files, you might need to run 'rake build' "
          + "to ensure they are regenerated and push the changes.")
      }
    }

    if (env.BRANCH_NAME == 'master') {
      stage("Push release tag") {
        govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
      }

      govuk.deployIntegration(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER, 'deploy')
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
    // Dummy parameter to prevent mutation of the parameter used
    // inside the closure below. If this is not defined, all of the
    // builds will be for the last application in the array.
    def app = dependentApp

    dependentBuilds[app] = {
      start = System.currentTimeMillis()

      build job: "/${app}/deployed-to-production",
        parameters: [
          [$class: 'BooleanParameterValue',
            name: 'IS_SCHEMA_TEST',
            value: true],
          [$class: 'StringParameterValue',
            name: 'SCHEMA_BRANCH',
            value: env.BRANCH_NAME],
          [$class: 'StringParameterValue',
            name: 'SCHEMA_COMMIT',
            value: env.GIT_COMMIT_HASH]
        ], wait: false
    }
  }

  parallel dependentBuilds

}
