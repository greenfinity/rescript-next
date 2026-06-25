# Release process

How to cut a release of `@greenfinity/rescript-next`. The package is published
to **Greenfinity's private registry** (`https://npm.greenfinity.hu/`), configured
under `npmScopes.greenfinity` in `.yarnrc.yml`; auth lives in the global
`~/.yarnrc.yml`. Tooling: Yarn Berry (4.x) + [`auto-changelog`](https://github.com/CookPete/auto-changelog).

## Prerequisites

- The feature PR(s) for this release are **merged into `main`**, and you are on
  `main`, up to date (`git pull --ff-only`).
- Feature PRs must **not** bump the `version` field — the release does that.

## Steps

Run these on `main`:

1. **Bump the version.**

   ```sh
   yarn version minor   # or: yarn version patch   (semver: minor for features, patch for fixes)
   ```

   Berry edits `package.json` only — it does not commit or tag.

2. **Generate the changelog.**

   ```sh
   yarn changelog       # runs `auto-changelog -p && git add HISTORY.md`
   ```

   `-p` makes it use the new `package.json` version as the latest section. It
   picks up merged PRs / commits since the previous tag and prepends them to
   `HISTORY.md`.

3. **Commit the release.** Stage `package.json` + `HISTORY.md` and commit with a
   message **prefixed `Release,`**:

   ```sh
   git add package.json HISTORY.md
   git commit -m "Release, vX.Y.Z"
   ```

   > **Why the prefix:** `.auto-changelog`'s `ignoreCommitPattern` filters out any
   > commit containing `Release`/`release` (and `Chore`/`chore`), so release
   > commits never clutter the changelog. **Every** commit you make on `main`
   > during a release (including the RELEASE.md update below) must carry the
   > `Release,` prefix.

4. **Tag the release** following the `v<version>` convention:

   ```sh
   git tag vX.Y.Z
   ```

5. **Publish** to the private registry:

   ```sh
   yarn npm publish
   ```

   The package ships `src/` (both `.res` and the compiled `.bs.mjs`) +
   `rescript.json` — run `yarn rescript build` first if the artifacts might be
   stale. If we ever move the package to the **public** npm registry instead, the
   command is `yarn npm publish --access public` (the `--access public` flag is
   **not** used for the private registry).

6. **Push** the branch and **only the new tag** (never `git push --tags`, which
   would push every local tag):

   ```sh
   git push
   git push origin vX.Y.Z
   ```

## Updating this file

Changes to `RELEASE.md` itself go in a final commit on `main`, also prefixed
`Release,` (so it stays out of the changelog), e.g.
`git commit -m "Release, update RELEASE.md"`.
