# Repository Guidelines

## Project Structure & Module Organization
- `entry/src/main/ets`: ArkTS UI and ability code (components, pages, abilities).
- `entry/src/main/resources`: App resources (strings, media, profiles).
- `entry/src/test`: Local unit tests (`*.test.ets`).
- `entry/src/ohosTest`: Device/instrumentation tests and test module config.
- `entry/src/mock`: Mock data and helpers for tests.
- Root configs: `build-profile.json5`, `hvigorfile.ts`, `code-linter.json5`, `oh-package.json5`.

## Build, Test, and Development Commands
This project uses Hvigor (via DevEco Studio or the `hvigor` CLI if installed).
- Build HAP: `hvigor assembleHap` (builds the `entry` module).
- Run locally: use DevEco Studio Run/Debug for the `entry` module.
- Run tests: `hvigor test` (runs local tests; use module filters if needed).
If your environment differs, check the DevEco Studio task list for the exact targets.

## SDK/API Compatibility
- Target SDK: 6.0.1 with API level 21.
- Keep new dependencies, APIs, and features compatible with SDK 6.0.1 / API 21 to avoid regressions.

## Coding Style & Naming Conventions
- Indentation: 2 spaces in `.ets` files (see `entry/src/main/ets/pages/Index.ets`).
- Components/abilities use PascalCase (e.g., `Index`, `EntryAbility`).
- Test files use `*.test.ets` naming under `entry/src/test`.
- Linting: rules configured in `code-linter.json5` with performance and TypeScript ESLint recommendations; security rules are enforced for crypto usage.

## Testing Guidelines
- Frameworks: Hypium (`@ohos/hypium`) with `@ohos/hamock` for mocks.
- Local unit tests live in `entry/src/test`; device tests in `entry/src/ohosTest`.
- Keep test names descriptive and aligned with `*.test.ets` pattern.

## Commit & Pull Request Guidelines
- No git history is present in this checkout, so no local commit convention can be inferred.
- Suggested format: `type(scope): short summary` (e.g., `feat(entry): add settings page`).
- PRs should include a concise description, linked issue (if any), and screenshots for UI changes.

## Security & Configuration Tips
- `local.properties` should point to your local SDK paths; avoid committing machine-specific changes.
- Generated folders like `oh_modules/` and build outputs should stay out of version control.
