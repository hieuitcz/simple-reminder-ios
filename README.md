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

## Build unsigned IPA on GitHub Actions (from Windows)

Workflow file:

- `.github/workflows/ios-build-ipa.yml`

Required repository secrets:

- None

How to run:

1. Push source code to GitHub repo.
2. Go to `Actions -> Build Unsigned iOS IPA -> Run workflow`.
3. Download `.ipa` from workflow artifact `ios-ipa-unsigned`.

Notes:

- This is an unsigned IPA (`ipa trang`).
- For sideloading, tools like Sideloadly/AltStore typically re-sign at install time with your Apple ID.
