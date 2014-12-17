#!/bin/bash

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

SCRIPT_PATH="`realpath "$0"`"
DUMMY_CONTENT_STORE_DIR=`dirname "${SCRIPT_PATH}"`

bundle install
bundle exec rackup "${DUMMY_CONTENT_STORE_DIR}"/config.ru -p 3068
