module MacOS
  module XcodeHelper
    def xcversion_command
      '/opt/chef/embedded/bin/xcversion'.freeze
    end

    def current_xcode_version
      version_plist = '/Applications/Xcode.app/Contents/version.plist'
      short_version_key = 'CFBundleShortVersionString'
      version_key_value_output = shell_out('/usr/bin/defaults', 'read', version_plist, short_version_key).stdout
      version_key_value_output.strip
    end

    def requested_xcode_already_installed?(semantic_version = nil)
      version = semantic_version || node['macos']['xcode']['version']
      xcversion_output = shell_out(xcversion_command, 'installed').stdout.split
      installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
      installed_xcodes.include?(version)
    end

    def xcversion_version(semantic_version)
      split_version = semantic_version.split('.')
      if split_version.length == 2 && split_version.last == '0'
        split_version.first
      else
        semantic_version
      end
    end

    def simulator_already_installed?(semantic_version)
      available_simulator_versions.include?("#{semantic_version} Simulator (installed)")
    end

    def highest_semantic_simulator_version(major_version, simulators)
      requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
      highest = simulators.select { |name, vers| requirement.match?(name, vers) }.max
      if highest.nil?
        Chef::Application.fatal!("iOS #{major_version} Simulator no longer available from Apple!")
      else
        highest.join(' ')
      end
    end

    def included_simulator_major_version
      version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
      sdks               = shell_out!('/usr/bin/xcodebuild', '-showsdks').stdout
      included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
      included_simulator[:version].split('.').first.to_i
    end

    def simulator_list
      available_simulator_versions.split(/\n/).map { |version| version.split[0...2] }
    end

    def available_simulator_versions
      shell_out!(xcversion_command, 'simulators').stdout
    end
  end
end

Chef::Recipe.include(MacOS::XcodeHelper)
Chef::Resource.include(MacOS::XcodeHelper)
