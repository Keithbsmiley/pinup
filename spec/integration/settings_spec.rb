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

  describe 'save_token' do
    describe 'when no options are passed' do
      it 'should exit' do
        expect(Pinup::Settings.save_token).to equal(nil)
      end
    end

    describe 'when an invalid token is passed' do
      it 'should return' do
        expect(Pinup::Settings.save_token({ token: 'foobar' })).to equal(nil)
      end
    end
    
    describe 'when a validish token and path is passed' do
      before do
        @options = { path: @path, token: 'Foo:bar' }
        Pinup::Settings.save_token(@options)
      end

      it 'should return true' do
        expect(Pinup::Settings.save_token(@options)).to equal(true)
      end

      it 'should create and save to the given file path' do
        expect(File.exists?(@path)).to equal(true)
      end

      it 'should write the correct information to the file' do
        @text = File.read(@path)
        expect(@text).to match(/machine\s+pinboard\.in/)
        expect(@text).to match(/login\s+Foo/)
        expect(@text).to match(/password\s+bar/)
      end
    end
  end

  describe 'get_token' do
    describe 'if there is a token' do
      before do
        Pinup::Settings.write_settings(@options) 
        @options = { path: @path, token: 'Foo:bar' }
        Pinup::Settings.save_token(@options)
      end

      it 'should load the correct token' do
        token = Pinup::Settings.get_token
        @same = token == 'Foo:bar'
        expect(@same).to be_true
      end
    end

    describe 'if there is no token' do
      before do
        Pinup::Settings.write_settings({ path: File.expand_path('~/foobar') })
      end

      it 'should return nil' do
        token = Pinup::Settings.get_token
        expect(token).to be_nil
      end
    end

    describe 'if there is only one attribute in the netrc' do
      before do
        @foopath = File.expand_path('~/foo')
        Pinup::Settings.write_settings({ path: @foopath })
        @netrc = Netrc.read(@foopath)
      end

      after do
        File.delete(@foopath) if File.exists? @foopath
      end

      describe 'if there is only a username' do
        before do
          @netrc['pinboard.in'] = 'Foo', nil
          @netrc.save
        end

        it 'should return nil' do
          expect { Pinup::Settings.get_token }.to raise_error
        end
      end

      describe 'if there is only a password' do
        before do
          @netrc['pinboard.in'] = nil, 'Foo'
          @netrc.save
        end

        it 'should return nil' do
          token = Pinup::Settings.get_token
          expect(token).to be_nil
        end
      end
    end
  end

  describe 'clear_settings' do
    describe 'if there is a settings file' do
      before do
        @settings = ""
        Pinup::Settings.write_settings(@settings)
      end

      after do
        File.delete(@settings_path) if File.exists?(@settings_path)
      end

      it 'should remove the file' do
        Pinup::Settings.clear_settings
        expect(File.exists?(@settings_path)).to be_false
      end
    end

    describe 'if ther eis no settings file' do
      before do
        File.delete(@settings_path) if File.exists?(@settings_path)
      end

      it 'should not create a file' do
        Pinup::Settings.clear_settings
        expect(File.exists?(@settings_path)).to be_false
      end
    end
  end

  describe 'token' do
    describe 'if there is invalid information' do
      it 'should return nil for an empty username' do
        expect(Pinup::Settings.token(nil, 'bar')).to be_nil
        expect(Pinup::Settings.token('', 'bar')).to be_nil
      end

      it 'should return nil for an empty password' do
        expect(Pinup::Settings.token('foo', nil)).to be_nil
        expect(Pinup::Settings.token('foo', '')).to be_nil
      end
    end
  end
end
