#!/usr/bin/env bash
set -euo pipefail

PROJECT="SimpleReminder.xcodeproj"
SCHEME="SimpleReminder"
CONFIGURATION="Release"
ARCHIVE_PATH="build/SimpleReminder.xcarchive"
EXPORT_PATH="build/ipa"
EXPORT_OPTIONS_PLIST="ExportOptions.plist"

if [[ ! -f "${EXPORT_OPTIONS_PLIST}" ]]; then
  echo "Missing ${EXPORT_OPTIONS_PLIST}."
  exit 1
fi

rm -rf build
mkdir -p build

echo "Archiving app..."
xcodebuild \
  -project "${PROJECT}" \
  -scheme "${SCHEME}" \
  -configuration "${CONFIGURATION}" \
  -destination "generic/platform=iOS" \
  -archivePath "${ARCHIVE_PATH}" \
  clean archive

echo "Exporting IPA..."
xcodebuild \
  -exportArchive \
  -archivePath "${ARCHIVE_PATH}" \
  -exportPath "${EXPORT_PATH}" \
  -exportOptionsPlist "${EXPORT_OPTIONS_PLIST}"

echo "Done. IPA is in ${EXPORT_PATH}"
