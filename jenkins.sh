#!/bin/bash
set -x
export DISPLAY=:99
export GOVUK_APP_DOMAIN=test.gov.uk
export GOVUK_ASSET_ROOT=http://static.test.gov.uk
export REPO_NAME="alphagov/govuk-content-schemas"
env

function error_handler {
  trap - ERR # disable error trap to avoid recursion.
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}

trap "error_handler ${LINENO}" ERR

# Try to merge master into the current branch, and abort if it doesn't exit
# cleanly (ie there are conflicts). This will be a noop if the current branch
# is master.
git merge --no-commit origin/master || git merge --abort

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment --without development
bundle exec rake spec
bundle exec rake clean build

export EXIT_STATUS=$?

if ! git diff --exit-code; then
  echo "Changes to checked-in files detected after running 'rake clean' and 'rake build'. If these are generated files, you might need to 'rake clean build' to ensure they are regenerated and push the changes"
  export EXIT_STATUS=1
fi

exit $EXIT_STATUS
