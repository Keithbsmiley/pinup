require_relative '../spec_helper'

describe Pinup::Settings do

  describe 'write_settings' do
    before do
      @path = File.expand_path('~/netrc_test')
      @settings_path = File.expand_path('~/.pinup')
      @options = { path: @path }
      Pinup::Settings.write_settings(@options) 
    end
    
    after do
      File.delete(@path) if File.exists?(@path)
      File.delete(@settings_path) if File.exists?(@settings_path)
    end

    it 'should write the the correct file' do
      expect(File.exists?(File.expand_path(@settings_path))).to be_true
    end

    it 'should contain the passed path' do
      text = File.read(@settings_path)
      expect(text).to match(/#{ @path }/)
      expect(text).to match(/path/)
    end
  end
end
