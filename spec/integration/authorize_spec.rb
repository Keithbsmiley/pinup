require_relative '../spec_helper'

describe Pinup::Authorize do
  before do
    @netrc_path = File.expand_path('~/foobar')
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
