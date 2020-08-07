#!/usr/bin/env ruby

require 'appboy_sdk_release_utils'

# CHANGELOG_FILE_RELATIVE_PATH = "CHANGELOG.md"


puts "Dir.getwd: #{Dir.getwd}"

CHANGELOG_FILE_PATH="#{Dir.getwd}/CHANGELOG.md"


puts "CHANGELOG_FILE_PATH: #{CHANGELOG_FILE_PATH}"
release_utils = AppboySDKReleaseUtils.new()
new_version_number = release_utils.get_version_number(CHANGELOG_FILE_PATH)
puts "Extracted the tag to use from CHANGELOG: #{new_version_number}"

# Overriding the value for the example
new_version_number = "hub_test_tag"

puts "#{new_version_number}"
