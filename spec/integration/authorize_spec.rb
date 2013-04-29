require_relative '../spec_helper'

describe Pinup::Authorize do
  before do
    @netrc_path = File.expand_path('~/foobar')
  end

  describe 'authorize_command' do
    describe 'when netrc is true' do
      it 'should call the correct method' do
        options = { netrc: true }
        Pinup::Authorize.should_receive(:authorize_netrc)
        Pinup::Authorize.authorize_command(options)
      end
    end

    describe 'when netrc is false' do
      it 'should call the correct method' do
        options = { netrc: false }
        Pinup::Authorize.should_receive(:authorize_credentials)
        Pinup::Authorize.authorize_command(options)
      end
    end
  end

  describe 'authorize_netrc' do
    describe 'an empty netrc' do
      it 'should return nil' do
        expect(Pinup::Authorize.authorize_netrc({ path: @netrc_path })).to be_nil
      end
    end

    describe 'a valid netrc' do
      it 'should return true' do
        # This will only pass if your default netrc has a valid username and password (token)
        expect(Pinup::Authorize.authorize_netrc).to be_true
      end
    end

    describe 'invalid credentials' do
      before do
        @path = File.expand_path('~/foobar') 
        Pinup::Settings.write_settings({ path: @path })
      end

      after do
        File.delete(@path) if File.exists?(@path)
        Pinup::Settings.clear_settings
      end

      describe 'invalid token' do
        before do
          Pinup::Settings.save_token({ token: 'foo:bar', path: @path })
        end

        it 'should return nil' do
          expect(Pinup::Authorize.authorize_netrc({ path: @path })).to be_nil
        end
      end
    end
    
    describe 'valid credentials with custom path' do
      before do
        token = Pinup::Settings.get_token
        @path = File.expand_path('~/foobar') 
        Pinup::Settings.save_token({ token: token, path: @path })
      end

      it 'should write the settings' do
        Pinup::Authorize.authorize_netrc({ path: @path })
        settings = Pinup::Settings.read_settings
        result = settings[:path] == @path
        expect(result).to be_true
      end
    end
  end

  describe 'authorize_credentials' do
    describe 'invalid credentials' do
      it 'should return nil' do
        expect(Pinup::Authorize.authorize_credentials({ username: 'foo', password: 'bar' })).to be_nil
      end
    end

    describe 'valid credentials' do
      # Note: this will only work if you set up netrc's for this testing
      it 'should return true' do
        netrc = Netrc.read
        username, password = netrc['test.pinboard.in']
        expect(username).not_to be_nil
        expect(password).not_to be_nil
        result = Pinup::Authorize.authorize_credentials({ username: username, password: password })
        expect(result).to be_true
      end
    end
  end
end
