#!/usr/bin/env ruby
require 'appboy_sdk_release_utils'

CHANGELOG_FILE_RELATIVE_PATH = "CHANGELOG.md"

release_utils = AppboySDKReleaseUtils.new()
new_version_number = release_utils.get_version_number(CHANGELOG_FILE_RELATIVE_PATH)

puts "extracted new_version_number: #{new_version_number}"