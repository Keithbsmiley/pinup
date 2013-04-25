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
end
