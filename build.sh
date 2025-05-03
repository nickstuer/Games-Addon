#!/bin/bash

##### LOAD ADDON INFORMATION #####
sourceFile=$(find src/* -name "*.toc")

version="vUnknown"
addonName="Unknown"
versionRegexPattern="## Version: ([0-9]+\.[0-9]+\.[0-9]+)"
addonNameRegexPattern="## Title: ([A-Za-z]+)"

while IFS= read -r line1; do
    # Extract version
    if [[ "$line1" =~ $versionRegexPattern ]]; then
        version=${BASH_REMATCH[1]}
    fi

    # Extract addon name
    if [[ "$line1" =~ $addonNameRegexPattern ]]; then
        addonName=${BASH_REMATCH[1]}
    fi

done < $sourceFile

##### BUILD ZIP FILE #####
FILENAME=$"${addonName}-v${version}.zip"
BUILD_DIRECTORY=$"${PWD}/dist"

rm -vrf "$BUILD_DIRECTORY" | echo "$(wc -l) files deleted"
mkdir -p "$BUILD_DIRECTORY"
mkdir -p $"${BUILD_DIRECTORY}/temp"

cp -R "src" "${BUILD_DIRECTORY}/temp/${addonName}";
cp -R "README.md" "${BUILD_DIRECTORY}/temp/${addonName}/README.md";

if [ "$OSTYPE" == "msys" ]; then # Crappy work around
    (cd dist/temp && "C:\Program Files\Git\bin\zip.exe" -r $"../${FILENAME}" .)  # Requires installing zip manually to git bins folder on windows
else
    (cd dist/temp && "zip" -r $"../${FILENAME}" .) # This would work if I just added zip to path in windows
fi

