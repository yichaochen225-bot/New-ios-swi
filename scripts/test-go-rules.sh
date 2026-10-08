#!/usr/bin/env bash
set -euo pipefail
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cp tests/GoRulesTests.swift "$tmp/main.swift"
swiftc -D GO_RULE_TESTS FreeSwiftUIStarter/GoEngine.swift "$tmp/main.swift" -o "$tmp/go-tests"
"$tmp/go-tests"
