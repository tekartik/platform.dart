#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings .

dart example/platform_context_io_example.dart

pub run test -p vm


# pub build example --web-compiler=dartdevc