require_relative '../spec_helper'

describe Pinup::Settings do

  before do
    @path = File.expand_path('~/netrc_test')
    @settings_path = File.expand_path('~/.pinup')
    @options = { path: @path }
  end

  after do
    File.delete(@path) if File.exists?(@path)
    File.delete(@settings_path) if File.exists?(@settings_path)
  end

  describe 'write_settings' do
    before do
      Pinup::Settings.write_settings(@options) 
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

  describe 'read_settings' do
    describe 'if the file does not exist' do
      it 'should return nil' do
        expect(Pinup::Settings.read_settings).to be_nil
      end
    end

    describe 'if the file is empty' do
      before do
        File.open(@settings_path, 'w') do |f|
          f.write("")
        end
      end

      it 'should return nil' do
        expect(Pinup::Settings.read_settings).to be_nil
      end
    end

    describe 'if the file does exist' do
      before do
        Pinup::Settings.write_settings(@options) 
      end

      it 'should return the correct path' do
        @settings = Pinup::Settings.read_settings
        @same_path = @settings[:path] == @path
        expect(@same_path).to be_true
      end
    end
  end
end
