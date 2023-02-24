#!/usr/bin/env bash
# We cannot test cupy on CI so this script will test it manually. Assumes it
# is being run in an environment that has cupy and the array-api-tests
# dependencies installed
set -x
set -e

tmpdir=$(mktemp -d)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export PYTHONPATH=$SCRIPT_DIR

PYTEST_ARGS="--max-examples 200 -v -rxXfE --ci"

cd $tmpdir
git clone https://github.com/data-apis/array-api-tests
cd array-api-tests

# Remove this once https://github.com/data-apis/array-api-tests/pull/157 is
# merged
git remote add asmeurer https://github.com/asmeurer/array-api-tests
git fetch asmeurer
git checkout asmeurer/xfails-file

git submodule update --init

export ARRAY_API_TESTS_MODULE=array_api_compat.cupy
pytest ${PYTEST_ARGS} --xfails-file $SCRIPT_DIR/cupy-xfails.txt --skips-file $SCRIPT_DIR/cupy-skips.txt $@
