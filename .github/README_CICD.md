# CI/CD Pipeline Configuration

[Versão em português](README_CICD.pt-BR.md)

This document explains how to configure the CI/CD pipeline for automated builds, GitHub releases, Google Play deployment and TestFlight uploads.

## Overview

The pipeline (`.github/workflows/integration.yaml`) has two trigger modes:

- **Push to `main`/`develop` or a pull request to `main`**: runs the `test` job only (`flutter analyze` + `flutter test --coverage`). Cheap and fast, runs on every commit.
- **Push of a tag matching `v*.*.*`** (e.g. `v1.2.3`): runs `build_android`, `release`, `deploy_play_store` and `build_ios`. Building, signing and shipping only happen when you deliberately cut a release, not on every merge.

To ship a release:

```bash
git tag v1.2.3
git push origin v1.2.3
```

### Jobs

| Job | Runs on | Trigger | Does |
|---|---|---|---|
| `test` | ubuntu | push/PR (not tags) | `flutter analyze`, `flutter test --coverage`, uploads coverage to Codecov |
| `build_android` | ubuntu | tag `v*.*.*` | Builds signed split-per-ABI APKs + an App Bundle |
| `release` | ubuntu | tag `v*.*.*` | Publishes a GitHub Release with the APKs attached |
| `deploy_play_store` | ubuntu | tag `v*.*.*` | Uploads the App Bundle to Play Store (internal track) |
| `build_ios` | macos | tag `v*.*.*` | Archives, exports and uploads the IPA to TestFlight |

---

## Required Secrets

Configure these under `Settings -> Secrets and variables -> Actions -> New repository secret`.

### App configuration

| Secret | Description | Example |
|---|---|---|
| `API_BASE_URL` | Base URL of your API | `https://api.yourapp.com` |
| `APP_NAME` | Application name | `MyApp` |
| `PACKAGE_NAME` | Android package name | `com.example.base_clean_arch_bloc` |

### Android signing + Google Play

| Secret | Description |
|---|---|
| `KEYSTORE_BASE64` | Upload keystore, base64-encoded |
| `KEY_ALIAS` | Alias of the key inside the keystore |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_PASSWORD` | Key password |
| `SERVICE_ACCOUNT_JSON` | Google Cloud service account JSON (Play Store uploads) |

If `KEYSTORE_BASE64` is not set, `build_android` still runs but falls back to debug signing (see `android/app/build.gradle`) - useful for testing the pipeline before secrets are configured, but the resulting APK/AAB cannot be uploaded to Play Store.

### iOS signing + App Store Connect

| Secret | Description |
|---|---|
| `APP_STORE_CONNECT_API_KEY_ID` | Key ID of the App Store Connect API key |
| `APP_STORE_CONNECT_API_KEY_BASE64` | The `.p8` private key file, base64-encoded |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Issuer ID from App Store Connect |

No certificate or provisioning profile secrets are needed: `xcodebuild` receives the API key directly with `-allowProvisioningUpdates`, and Apple's servers issue the distribution certificate and provisioning profile on demand, even on a clean runner.

---

## Setup Walkthrough

### 1. Android keystore

Generate one if you don't already have it:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Encode it and store the result in `KEYSTORE_BASE64`:

```bash
# macOS/Linux
base64 -i ~/upload-keystore.jks | pbcopy

# Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$HOME\upload-keystore.jks")) | Set-Clipboard
```

Store the alias and both passwords you used above as `KEY_ALIAS`, `KEYSTORE_PASSWORD` and `KEY_PASSWORD`.

Keep the keystore and its passwords somewhere safe outside the repo - losing them means you can no longer update the app on Play Store.

### 2. Google Play Console

1. Create the app in [Play Console](https://play.google.com/console) and note its package name.
2. Play Store requires the **first** upload to be manual:
   ```bash
   flutter build appbundle --release
   ```
   Upload `build/app/outputs/bundle/release/app-release.aab` under Internal Testing, fill in the required listing info, and save as a draft (no need to publish).
3. In [Google Cloud Console](https://console.cloud.google.com), create a service account (`IAM & Admin -> Service Accounts`), then generate a JSON key for it (`Keys -> Add key -> JSON`).
4. Back in Play Console, go to `Setup -> API access`, link the Google Cloud project, then grant the service account:
   - **View app information** (read-only)
   - **Create and edit draft releases**
   - **Release to testing tracks**
5. Paste the full JSON key content into `SERVICE_ACCOUNT_JSON`.

### 3. App Store Connect API key

1. In [App Store Connect](https://appstoreconnect.apple.com), go to `Users and Access -> Integrations -> App Store Connect API`.
2. Create a key with the **App Manager** role and download the `.p8` file (Apple only lets you download it once).
3. Note the **Key ID** and **Issuer ID** shown on that page.
4. Encode the key and store the secrets:
   ```bash
   base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
   ```
   - `APP_STORE_CONNECT_API_KEY_ID` = the Key ID
   - `APP_STORE_CONNECT_API_KEY_BASE64` = the base64 output above
   - `APP_STORE_CONNECT_API_ISSUER_ID` = the Issuer ID
5. Open `ios/ExportOptions.plist` and replace `YOUR_TEAM_ID` with your Apple Developer Team ID.

---

## Troubleshooting

**"No service account found" / Play Store 401** - the service account isn't linked or lacks permissions; redo the API access step in Play Console.

**"Package not found"** - `PACKAGE_NAME` doesn't match the app created in Play Console, or the manual first upload (step 2.2 above) hasn't been done yet.

**"Version code X has already been used"** - bump the version in `pubspec.yaml` (`1.0.0+1` -> `1.0.0+2`), or note that `build_android` already offsets `versionCode` by `1000 + github.run_number` to avoid colliding with prior manual uploads.

**iOS archive fails with "No Accounts" / "No profiles found"** - the App Store Connect API key secrets are missing or wrong; this flow does not use a local Apple ID, so signing depends entirely on those three secrets plus the `teamID` in `ios/ExportOptions.plist`.

**Invalid keystore format** - re-run the base64 encode command and paste the output exactly, with no extra whitespace or line breaks.
