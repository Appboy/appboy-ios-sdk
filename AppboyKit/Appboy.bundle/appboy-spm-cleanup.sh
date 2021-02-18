#! /bin/sh

# AppboyKitLibrary
find "$BUILT_PRODUCTS_DIR/" -name libAppboyKitLibrary.a -exec rm {} \;

# AppboyPushStory
rm -rf "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/AppboyPushStory.framework"
find "$BUILT_PRODUCTS_DIR/$PLUGINS_FOLDER_PATH/" -name "AppboyPushStory.framework" -exec rm -r {} \;
