# Development setup

- This is a pure Dart library with no runtime dependencies or services. Read CONTRIBUTING.md before changing a protocol decoder or command.
- Run `bash scripts/setup.sh` from any working directory. Use a Dart SDK compatible with `pubspec.yaml`, currently Dart 3.5 or newer within Dart 3. CI tests Dart 3.5.0 and stable.
- Setup uses `DART_BIN`, then `dart` on PATH, then the shared Flutter 3.41.6 or OpenStrap Dart 3.5.0 installation. It never installs an SDK, edits shell profiles, or runs the Linux-only `.agents/setup` host bootstrap.
- `pubspec.lock` is intentionally ignored for this library. The first setup resolves dependencies; later setups enforce the existing checkout's lockfile. Choose dependency upgrades explicitly with `dart pub upgrade`, and review them separately from setup.
- Run `bash scripts/setup.sh --check` for dependency setup, `dart analyze --fatal-infos`, and the complete test suite with two workers. No build or browser is required.

# T3 Code and parallel work

- Import the repository's Setup and Check actions into each T3 project/environment. Setup must run automatically on worktree creation and finish before the agent starts. A checked-in `t3.json` alone does not activate the actions.
- Give each independent task its own branch and worktree. Keep each checkout's `.dart_tool`, ignored lockfile, and build output separate. This package has no API ports or development database to allocate.
- Agree on file ownership when several agents work at once. One integration owner combines overlapping decoder changes and runs the full checks.
- Transfer committed branches between machines with Git. Project grouping does not sync files or dependencies. Do not copy private device captures into another checkout automatically.
- Offline fixture and parity tests do not prove live BLE behavior, hardware support, or medical accuracy. Tests needing the external `whoop_hist.jsonl` capture skip when it is absent. Do not connect to hardware, transmit commands, or modify live health accounts during setup.
- Do not add AI attribution to commits.
