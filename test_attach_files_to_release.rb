#!/usr/bin/env ruby

require 'appboy_sdk_release_utils'

CHANGELOG_RELATIVE_PATH="CHANGELOG.md"

release_utils = AppboySDKReleaseUtils.new()
new_version_number = release_utils.get_version_number(CHANGELOG_RELATIVE_PATH)

# Overriding the value for the example
new_version_number = "hub_test_tag"

puts "#{new_version_number}"
