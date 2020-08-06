#!/bin/sh

# This script generates the Fat & Thin iOS SDK frameworks using
# HelloSwift and then generates the Core framework with ObjCSample

PROJECT_NAME=""
ROOT_DIR=$PWD"/"
TMP_DIR=$ROOT_DIR"tmp/"
DERIVED_DATA_DIR=""
IOS_DIR="iOS"
SIMULATORS_DIR="Simulators"
FRAMEWORKS_ARCHIVE_DIR=""
SIMULATORS_ARCHIVE_DIR="Build/Products/Debug-iphonesimulator/"
THIN_FRAMEWORK_FILE_NAME="Appboy_iOS_SDK_thin.framework.zip"
CORE_FRAMEWORK_FILE_NAME="Appboy_iOS_SDK_core.framework.zip"

function step_header {
  echo $'\n======================================================='
  echo "$1"
  echo $'=======================================================\n'
}

function get_derived_data_folder {
  FOLDER=( ~/Library/Developer/Xcode/DerivedData/${PROJECT_NAME}*/ )

  for d in ${FOLDER[@]}
  do
    DERIVED_DATA_DIR="${d}"
    return "1"
  done
}

function set_frameworks_archive_dir {
  FRAMEWORKS_ARCHIVE_DIR="Build/Intermediates.noindex/ArchiveIntermediates/${PROJECT_NAME}/IntermediateBuildFilesPath/UninstalledProducts/iphoneos/"
}

function delete_derived_data {
  rm -rf "${DERIVED_DATA_DIR}"
}

function cd_project_folder {
  if [[ "${PROJECT_NAME}" == 'HelloSwift' ]]; then
    cd $ROOT_DIR"HelloSwift"
  else 
    cd $ROOT_DIR"Samples/Core/ObjCSample"
  fi
}

function cd_root {
  cd $ROOT_DIR
}

function update_pods {
  pod update
}

function archive_proj {
  xcodebuild -workspace "${PROJECT_NAME}.xcworkspace/" -scheme "${PROJECT_NAME}" -configuration Release clean archive | xcpretty
}

function run_proj {
  xcodebuild -workspace "${PROJECT_NAME}.xcworkspace/" -scheme "${PROJECT_NAME}" -configuration Debug -destination "platform=iOS Simulator,name=iPhone 8" clean build | xcpretty
}

function mk_new_dir {
  if [ -d "$1" ]; then
    rm -rf "$1"
  fi
  mkdir "$1"
}

function copy_ios_frameworks {
  SOURCE_DIR=$1
  DEST_DIR=$2
  FRAMEWORKS_DIR=$DERIVED_DATA_DIR$1
  cp -r $FRAMEWORKS_DIR"Appboy_iOS_SDK.framework" $DEST_DIR

  if [[ "${PROJECT_NAME}" == 'HelloSwift' ]]; then
    cp -r $FRAMEWORKS_DIR"SDWebImage.framework" $DEST_DIR
  fi
}

function copy_simulators_frameworks {
  SOURCE_DIR=$1
  DEST_DIR=$2
  FRAMEWORKS_DIR=$DERIVED_DATA_DIR$1
  cp -r $FRAMEWORKS_DIR"Appboy-iOS-SDK/Appboy_iOS_SDK.framework" $DEST_DIR

  if [[ "${PROJECT_NAME}" == 'HelloSwift' ]]; then
    cp -r $FRAMEWORKS_DIR"SDWebImage/SDWebImage.framework" $DEST_DIR
  fi
}

function pack_frameworks {
  lipo -create -output ./iOS/Appboy_iOS_SDK.framework/Appboy_iOS_SDK ./iOS/Appboy_iOS_SDK.framework/Appboy_iOS_SDK ./Simulators/Appboy_iOS_SDK.framework/Appboy_iOS_SDK

  if [[ "${PROJECT_NAME}" == 'HelloSwift' ]]; then
    lipo -create -output ./iOS/SDWebImage.framework/SDWebImage ./iOS/SDWebImage.framework/SDWebImage ./Simulators/SDWebImage.framework/SDWebImage
  fi
}

function verify_archs {
  lipo -info ./iOS/Appboy_iOS_SDK.framework/Appboy_iOS_SDK
  
  if [[ "${PROJECT_NAME}" == 'HelloSwift' ]]; then
    lipo -info ./iOS/SDWebImage.framework/SDWebImage
  fi

  step_header "Please verify that frameworks support i386 x86_64 armv7 arm64 architecture set above.

Type \"continue\" to proceed with the build."

  read continue
  if [[ continue != "continue" ]]; then
    exit 0
  fi
}

function zip_frameworks {
  if [[ "${PROJECT_NAME}" == 'HelloSwift' ]]; then
    zip -r -X $TMP_DIR"Appboy_iOS_SDK.framework.zip" iOS
    zip -r -X $TMP_DIR$THIN_FRAMEWORK_FILE_NAME iOS/Appboy_iOS_SDK.framework

    echo "
Fat framework: "$TMP_DIR"Appboy_iOS_SDK.framework.zip
Thin framework: "$TMP_DIR$THIN_FRAMEWORK_FILE_NAME

  else
    zip -r -X $TMP_DIR$CORE_FRAMEWORK_FILE_NAME iOS/Appboy_iOS_SDK.framework
  fi
}

function rm_dirs {
  rm -rf $IOS_DIR
  rm -rf $SIMULATORS_DIR
}

function create_frameworks_for_project {
  PROJECT_NAME=$1
  set_frameworks_archive_dir

  get_derived_data_folder
  step_header "Deleting the DerivedData folder."
  delete_derived_data

  cd_project_folder
  step_header "Updating Cocoapods."
  update_pods

  cd_root
  bundle exec "./Support/project_writer.rb ${PROJECT_NAME}"
  cd_project_folder
  step_header "Archiving the project."
  archive_proj
  get_derived_data_folder

  step_header "Copying frameworks."
  mk_new_dir $IOS_DIR
  copy_ios_frameworks $FRAMEWORKS_ARCHIVE_DIR $IOS_DIR

  step_header "Setting i386 architecture."
  cd_root
  bundle exec "./Support/project_writer.rb ${PROJECT_NAME} --add-i386"
  cd_project_folder
  step_header "Recompiling Pods."
  update_pods
  cd_root
  bundle exec "./Support/project_writer.rb ${PROJECT_NAME} --update-pods"
  cd_project_folder
  step_header "Building the project."
  run_proj

  step_header "Copying frameworks"
  mk_new_dir $SIMULATORS_DIR
  copy_simulators_frameworks $SIMULATORS_ARCHIVE_DIR $SIMULATORS_DIR

  step_header "Packing frameworks."
  pack_frameworks
  verify_archs

  step_header "Zipping frameworks."
  mkdir -p $TMP_DIR
  zip_frameworks

  step_header "Cleaning."
  rm_dirs

  step_header "Completed successfully using ${PROJECT_NAME} 🎉"
}

step_header "Generating Fat & Thin Frameworks using HelloSwift."
create_frameworks_for_project "HelloSwift"

echo $'*******************************************************************\n'

step_header "Generating Core Framework using ObjCSample."
create_frameworks_for_project "ObjCSample"
