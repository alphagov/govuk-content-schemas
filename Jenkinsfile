#!/usr/bin/env groovy

REPOSITORY = 'govuk-content-schemas'

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
      throttleEnabled: true,
      throttleOption: 'category'],
  ])

  try {
    stage("Checkout") {
      checkout scm
    }

    stage("Run jenkins.sh") {
      sh('./jenkins.sh')
    }

    stage("Push release tag") {
      govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
    }

    govuk.deployIntegration(REPOSITORY, env.BRANCH_NAME, 'release', 'deploy')

  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }
}
