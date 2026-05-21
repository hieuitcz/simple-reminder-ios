# SimpleReminder iOS

Simple SwiftUI reminder app:
- Add reminder with title + due date
- Mark reminder done/undone
- Delete reminder
- Local persistence via `@AppStorage` + JSON

## Project structure

- `SimpleReminder.xcodeproj`
- `SimpleReminder/`

## Build and run on Mac

1. Open `SimpleReminder.xcodeproj` in Xcode.
2. In target `SimpleReminder`, set:
   - `Signing & Capabilities` -> Team
   - Bundle Identifier if needed
3. Select an iPhone simulator or device and run.

## Export IPA

1. Edit `ExportOptions.plist` and set your real `teamID`.
2. Run:

```bash
chmod +x export_ipa.sh
./export_ipa.sh
```

IPA output path:

- `build/ipa/`

## Build IPA on GitHub Actions (from Windows)

Workflow file:

- `.github/workflows/ios-build-ipa.yml`

Required repository secrets:

- `IOS_P12_BASE64`: base64 of Apple Distribution certificate (`.p12`)
- `IOS_P12_PASSWORD`: password of that `.p12`
- `IOS_MOBILEPROVISION_BASE64`: base64 of provisioning profile (`.mobileprovision`)
- `APPLE_TEAM_ID`: your Apple Developer Team ID
- `IOS_BUNDLE_ID`: bundle id that matches provisioning profile (example: `com.yourcompany.SimpleReminder`)

How to run:

1. Push source code to GitHub repo.
2. Add the 5 secrets above in `Settings -> Secrets and variables -> Actions`.
3. Go to `Actions -> Build iOS IPA -> Run workflow`.
4. Download `.ipa` from workflow artifact `ios-ipa`.
