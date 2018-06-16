#!/usr/bin/env bash

set -xe

pushd platform
pub get
tool/travis.sh
popd

pushd platform_io
pub get
tool/travis.sh
popd

pushd platform_browser
pub get
tool/travis.sh
popd