#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings lib example test

pub run test -p vm,chrome
pub run build_runner test -- -p vm,chrome
# pub run test -p firefox

# pub build example --web-compiler=dartdevc