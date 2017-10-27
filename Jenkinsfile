#!/usr/bin/env groovy

REPOSITORY = 'govuk-content-schemas'

// second boolean parameter describes whether the app is using the central
// buildProject script - if so it will report its success individually, so this
// job does not need to wait for it.
def dependentApplications = [
  ['calculators', true],
  ['calendars', true],
  ['collections-publisher', true],
  ['collections', true],
  ['content-store', true],
  ['content-tagger', true],
  ['email-alert-frontend', true],
  ['email-alert-service', true],
  ['finder-frontend', true],
  ['frontend', true],
  ['government-frontend', true],
  ['hmrc-manuals-api', true],
  ['info-frontend', true],
  ['manuals-frontend', true],
  ['manuals-publisher', true],
  ['policy-publisher', true],
  ['publisher', true],
  ['rummager', true],
  ['service-manual-publisher', true],
  ['short-url-manager', true],
  ['specialist-publisher', true],
  ['static', true],

  ['contacts', false],
  ['licencefinder', false],
  ['publishing-api', false],
  ['service-manual-frontend', false],
  ['smartanswers', false],
  ['whitehall', false],
]

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

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
      env.GIT_COMMIT = sh(
        script: 'git rev-parse HEAD',
        returnStdout: true
      ).trim()
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
    // Dummy parameters to prevent mutation of the parameter used inside the
    // closure below. If this is not defined, all of the builds will be for the
    // last application in the array.
    def app = dependentApp[0]
    def wait = !dependentApp[1]

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
            value: env.GIT_COMMIT]
        ], wait: wait
    }
  }

  parallel dependentBuilds

}
