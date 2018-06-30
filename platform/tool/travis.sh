#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings .

pub run build_runner test -- -p vm
pub run build_runner test -- -p chrome
# pub run test -p firefox

# pub build example --web-compiler=dartdevc