include Chef::Mixin::ShellOut

module MacOS
  module PlistBuddyHelpers
    def self.exist?
      command = format_plistbuddy_command('print', entry, value)
      shell_out(command).error?
    end

    def convert_to_string_from_data_type(plist_entry)
      data_type_cases = { Array => "array #{plist_entry}",
                          Integer => "int #{plist_entry}",
                          TrueClass => 'bool TRUE',
                          FalseClass => 'bool FALSE',
                          Hash => "dict #{plist_entry}",
                          String => "string #{plist_entry}",
                          Float => "float #{plist_entry}" }
      data_type_cases[plist_entry.class]
    end

    def format_plistbuddy_command(action_property, plist_entry, plist_value = nil)
      value_with_data_type = convert_to_string_from_data_type plist_value
      "/usr/libexec/Plistbuddy -c \'#{action_property.to_s.capitalize} :#{plist_entry} #{value_with_data_type}\'"
    end
  end
end

Chef::Recipe.include(MacOS::PlistBuddyHelpers)
Chef::Resource.include(MacOS::PlistBuddyHelpers)
