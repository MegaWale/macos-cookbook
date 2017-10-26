require 'spec_helper'

include MacOS::PlistBuddyHelpers

describe MacOS::PlistBuddyHelpers, '#format_plistbuddy_command' do
  context 'When given some commands' do
    it 'the add command is formatted properly' do
      expect(format_plistbuddy_command(:add, 'FooEntry', true)).to eq "/usr/libexec/Plistbuddy -c 'Add :FooEntry bool TRUE'"
    end

    it 'the delete command is formatted properly' do
      expect(format_plistbuddy_command(:delete, 'BarEntry')).to eq "/usr/libexec/Plistbuddy -c 'Delete :BarEntry '"
    end

    it 'the set command is formatted properly' do
      expect(format_plistbuddy_command(:set, 'BazEntry', false)).to eq "/usr/libexec/Plistbuddy -c 'Set :BazEntry bool FALSE'"
    end

    it 'the print command is formatted properly' do
      expect(format_plistbuddy_command(:print, 'QuxEntry')).to eq "/usr/libexec/Plistbuddy -c 'Print :QuxEntry'"
    end
  end
end

describe MacOS::PlistBuddyHelpers, '#convert_to_string_from_data_type' do
  context 'When given a certain data type' do
    it 'returns the required PlistBuddy boolean entry' do
      expect(convert_to_string_from_data_type(true)).to eq 'bool TRUE'
    end

    xit 'returns the required PlistBuddy array entry' do # TODO: Implement proper plist array syntax (i.e. containers)
      expect(convert_to_string_from_data_type(%w(foo bar))).to eq 'array foo bar'
    end

    xit 'returns the required PlistBuddy dictionary entry' do # TODO: Implement proper plist dict syntax (i.e. containers)
      expect(convert_to_string_from_data_type('baz' => 'qux')).to eq 'dict key value'
    end

    it 'returns the required PlistBuddy string entry' do
      expect(convert_to_string_from_data_type('quux')).to eq 'string quux'
    end

    it 'returns the required PlistBuddy int entry' do
      expect(convert_to_string_from_data_type(1)).to eq 'int 1'
    end

    it 'returns the required PlistBuddy float entry' do
      expect(convert_to_string_from_data_type(1.0)).to eq 'float 1.0'
    end
  end
end
