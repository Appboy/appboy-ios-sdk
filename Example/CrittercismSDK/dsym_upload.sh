#!/bin/sh
# Copyright 2013-2015 Crittercism, Inc. All rights reserved.
#
# Usage:
#   * (These instructions assume you have dragged the "CrittercismSDK" folder
#     into your project in XCode)
#   * In the project editor, select your target.
#   * Click "Build Phases" at the top of the project editor.
#   * Click "Add Build Phase" in the lower right corner.
#   * Choose "Add Run Script."
#   * Paste the following script into the dark text box. You will have to 
#     uncomment the lines (remove the #s) of course.
#
# --- SCRIPT BEGINS ON NEXT LINE, COPY AND EDIT FROM THERE ---
# APP_ID="<YOUR_APP_ID>"
# API_KEY="<YOUR_API_KEY>"
# source ${SRCROOT}/CrittercismSDK/dsym_upload.sh
# --- END OF SCRIPT ---

################################################################################
# Advanced Settings
#
# You can over-ride these directly in XCode in your Run Script Build Phase, or
# change the defaults below.

# Should simulator builds cause symbols to be uploaded?
UPLOAD_SIMULATOR_SYMBOLS=${UPLOAD_SIMULATOR_SYMBOLS:=1}

# This setting determines whether or not your build will fail if the dSYM was
# not uploaded properly to Crittercism's servers.
#
# You may wish to change this setting if you are building without internet
# access, or otherwise are having difficulty connecting to Crittercism's
# servers.
REQUIRE_UPLOAD_SUCCESS=${REQUIRE_UPLOAD_SUCCESS:=1}

################################################################################
# You should not need to edit anything past this point.

exitWithMessageAndCode() {
  echo "${1}"
  exit ${2}
}

echo "Uploading dSYM to Crittercism."
echo ""

# Display build info
BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c 'Print CFBundleVersion' ${INFOPLIST_FILE})
BUNDLE_SHORT_VERSION=$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' ${INFOPLIST_FILE})

echo "Product Name: ${PRODUCT_NAME}"
echo "Version: ${BUNDLE_SHORT_VERSION}"
echo "Build: ${BUNDLE_VERSION}"
echo "Crittercism App ID: ${APP_ID}"
echo "Crittercism API key: ${API_KEY}"

# Possibly bail if this is a simulator build
if [ "$EFFECTIVE_PLATFORM_NAME" == "-iphonesimulator" ]; then
  if [ $UPLOAD_SIMULATOR_SYMBOLS -eq 0 ]; then
  	exitWithMessageAndCode "skipping simulator build" 0
  fi
fi

# Check to make sure the necessary parameters are defined
if [ ! "${APP_ID}" ]; then
  exitWithMessageAndCode "err: Crittercism App ID not defined." 1
fi

if [ ! "${API_KEY}" ]; then
  exitWithMessageAndCode "err: Crittercism API Key not defined." 1
fi

# Compute DSYM_UPLOAD_DOMAIN and DSYM_UPLOAD_URL based on APP_ID .
APP_ID_LENGTH=${#APP_ID}
if [ $APP_ID_LENGTH -eq 24 ]; then
  DSYM_UPLOAD_DOMAIN="api.crittercism.com"
elif [ $APP_ID_LENGTH -eq 40 ]; then
  APP_ID_LOCATION=${APP_ID:32}
  US_WEST_1_PROD_DESIGNATOR="00555300"
  EU_CENTRAL_1_PROD_DESIGNATOR="00444503"
  if [ "${APP_ID_LOCATION}" == "${US_WEST_1_PROD_DESIGNATOR}" ]; then
    DSYM_UPLOAD_DOMAIN="api.crittercism.com"
  elif [ "${APP_ID_LOCATION}" == "${EU_CENTRAL_1_PROD_DESIGNATOR}" ]; then
    DSYM_UPLOAD_DOMAIN="api.eu.crittercism.com"
  else
    echo "Unexpected APP_ID_LOCATION == ${APP_ID_LOCATION}"
  fi
else
  echo "Unexpected APP_ID_LENGTH == ${APP_ID_LENGTH}"
fi
if [ ! "${DSYM_UPLOAD_DOMAIN}" ]; then
  # DSYM_UPLOAD_DOMAIN didn't get defined.
  exitWithMessageAndCode "err: Invalid Crittercism App ID: ${APP_ID}" 1
fi
echo "dSym Upload Domain: ${DSYM_UPLOAD_DOMAIN}"
DSYM_UPLOAD_URL="https://${DSYM_UPLOAD_DOMAIN}/api_beta/dsym/${APP_ID}"
echo "dSym Upload URL: ${DSYM_UPLOAD_URL}"

# create dSYM .zip file
DSYM_SRC=${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}
DSYM_ZIP_FPATH="${TARGET_TEMP_DIR}/$DWARF_DSYM_FILE_NAME.zip"
echo "dSYM Source: ${DSYM_SRC}"
if [ ! -d "$DSYM_SRC" ]; then
  exitWithMessageAndCode "dSYM source not found: ${DSYM_SRC}" 1
fi

echo "Compressing dSYM to ${DSYM_ZIP_FPATH} ."
(/usr/bin/zip --recurse-paths --quiet "${DSYM_ZIP_FPATH}" "${DSYM_SRC}") || exitWithMessageAndCode "err: Failed creating zip." 1
echo ""
echo "dSym.zip archive created."

# Upload dSYM to Crittercism
echo "Uploading dSYM.zip to Crittercism: ${DSYM_UPLOAD_URL}"

STATUS=$(/usr/bin/curl "${DSYM_UPLOAD_URL}" --write-out %{http_code} --silent --output /dev/null -F dsym=@"${DSYM_ZIP_FPATH}" -F key="${API_KEY}")

echo Crittercism API server response: ${STATUS}
if [ $STATUS -ne 200 ]; then
  echo "err: dSYM.zip archive failed to upload to Crittercism."
  if [ $REQUIRE_UPLOAD_SUCCESS -eq 1 ]; then
  	echo "To ignore this server response and build succesfully add"
  	echo "REQUIRE_UPLOAD_SUCCESS=0"
  	echo "to the Run Script Build Phase invoking the dsym_upload.sh script."
    exit 1
  else
  	echo "Ignoring due to REQUIRE_UPLOAD_SUCCESS=0 ."
  fi
fi

# Remove temp dSYM archive
echo "Removing temporary dSYM.zip archive."
/bin/rm -f "${DSYM_ZIP_FPATH}"
if [ "$?" -ne 0 ]; then
  exitWithMessageAndCode "Error removing temporary dSYM.zip archive." 1
fi

echo "Crittercism dSYM upload complete."

