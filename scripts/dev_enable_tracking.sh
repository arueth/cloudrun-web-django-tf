#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASE_PATH=${SCRIPT_PATH%/*}

git update-index --no-assume-unchanged ${BASE_PATH}/terraform/*.auto.tfvars
