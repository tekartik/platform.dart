#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings lib example test

dart example/platform_context_io_example.dart

pub run test -p vm
pub run build_runner test -- -p vm


# pub build example --web-compiler=dartdevc