#!/bin/bash

sourceFile=$(find src/* -name "*.toc")
addonName="Unknown"
addonNameRegexPattern="## Title: ([A-Za-z]+)"

while IFS= read -r line1; do
    # Extract addon name
    if [[ "$line1" =~ $addonNameRegexPattern ]]; then
        addonName=${BASH_REMATCH[1]}
    fi

done < $sourceFile

echo "Deploying $addonName"

ADDON_PATH="/Applications/World of Warcraft/_retail_/Interface/AddOns/${addonName}"
ADDON_PATH_WINDOWS="C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\\${addonName}"

if [ "$OSTYPE" == "msys" ]; then
    ADDON_PATH="$ADDON_PATH_WINDOWS"
fi
echo "Using path: $ADDON_PATH"

rm -vrf "$ADDON_PATH" | echo "$(wc -l) files deleted"
mkdir -p "$ADDON_PATH"

cp -R -a "src/." "${ADDON_PATH}";
cp -R "README.md" "${ADDON_PATH}/README.md";

echo "Successfully deployed to $ADDON_PATH"
exit
