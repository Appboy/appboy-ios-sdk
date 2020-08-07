#!/usr/bin/env ruby
require 'pathname'
require 'fileutils'
require 'pbxplorer'

ROOT_DIR = Pathname.getwd().to_s()

class ProjectWriter
  def initialize(project_name)
    @project_name = project_name

    # TODO (daniel): update after reorganizing sample projects
    if @project_name == 'HelloSwift'

      # Removed Public/ for both of these files for the example
      @base_directory = File.join(ROOT_DIR, "HelloSwift")
    else
      @base_directory = File.join(ROOT_DIR, "Samples/Core/ObjCSample")
    end
  end

  def update_main_proj(add_i386)
    project_file = XCProjectFile.new File.join(@base_directory, "#{@project_name}.xcodeproj/project.pbxproj")
    project = project_file.project

    list = project_file.objects_of_class XCBuildConfiguration
    list.each {
      |conf|
      if conf["buildSettings"]["ARCHS"]
        conf["buildSettings"].delete("ARCHS")
      end
      if conf["buildSettings"]["CODE_SIGN_ENTITLEMENTS"] == "#{@project_name}/#{@project_name}.entitlements"
        if add_i386
          conf["buildSettings"]["ARCHS"] = [ "$(ARCHS_STANDARD)", "i386" ]
        else
          conf["buildSettings"]["ARCHS"] = [ "$(ARCHS_STANDARD)" ]
        end
        conf["buildSettings"]["ONLY_ACTIVE_ARCH"] = "NO"
      end
    }
    project_file.save
  end

  def update_pods_proj
    project_file = XCProjectFile.new File.join(@base_directory, 'Pods/Pods.xcodeproj/project.pbxproj')
    project = project_file.project

    list = project_file.objects_of_class XCBuildConfiguration
    list.each { |conf|
      if conf["buildSettings"]["ONLY_ACTIVE_ARCH"] == "YES"
        puts('found')
        conf["buildSettings"]["ONLY_ACTIVE_ARCH"] = "NO"
      end
      project_file.save
    }
  end

end

workspace_name = ARGV[0]
v1 = ARGV[1]
add_i386 = false
update_pods = false
if v1 == '--add-i386'
  add_i386 = true
end
if v1 == '--update-pods'
  update_pods = true
end

writer = ProjectWriter.new(workspace_name)
writer.update_main_proj(add_i386)
if update_pods
  writer.update_pods_proj
end

exit(0)
