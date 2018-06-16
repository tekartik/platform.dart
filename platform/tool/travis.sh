#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings .

pub run test -p vm
pub run test -p firefox,chrome

# pub build example --web-compiler=dartdevc