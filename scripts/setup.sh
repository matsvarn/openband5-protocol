#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
if [[ $# -gt 1 || (${1:-} != "" && ${1:-} != --check) ]]; then
  echo "Usage: bash scripts/setup.sh [--check]" >&2
  exit 2
fi

dart_bin=${DART_BIN:-}
if [[ -z "$dart_bin" ]]; then
  dart_bin=$(command -v dart || true)
fi
if [[ -z "$dart_bin" ]]; then
  for candidate in \
    "$HOME/.local/share/flutter/3.41.6/bin/dart" \
    "$HOME/.local/share/openstrap/dart-3.5.0/dart-sdk/bin/dart"; do
    if [[ -x "$candidate" ]]; then
      dart_bin=$candidate
      break
    fi
  done
fi
if [[ -z "$dart_bin" ]] || ! command -v "$dart_bin" >/dev/null; then
  echo "Install Dart SDK compatible with pubspec.yaml, then put dart on PATH or set DART_BIN to its absolute path. See https://dart.dev/get-dart." >&2
  exit 1
fi

"$dart_bin" --version
# This library intentionally ignores its lockfile. Resolve once per checkout,
# then preserve that checkout's resolved versions during later setup runs.
if [[ -f pubspec.lock ]]; then
  "$dart_bin" pub get --enforce-lockfile
else
  "$dart_bin" pub get
fi

if [[ ${1:-} == --check ]]; then
  "$dart_bin" analyze --fatal-infos
  "$dart_bin" test --reporter=expanded --concurrency=2
fi
