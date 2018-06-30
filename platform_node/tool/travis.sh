#!/usr/bin/env bash

# Fast fail the script on failures.
set -xe

# Check dart2js warning: using dart2js example/demo_idb.dart --show-package-warnings -o /tmp/out.js

dartanalyzer --fatal-warnings .

pub run build_runner build example --output=example:build
node build/platform_context_node_example.dart.js

pub run test -p node
pub run build_runner test -- -p node
