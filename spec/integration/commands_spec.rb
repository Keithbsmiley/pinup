require_relative '../spec_helper'

describe Pinup::List do
  describe 'cli usage' do
    before do
      @response = %x[bundle exec bin/pinup list]
    end

    it 'should print some URLs' do
      expect(@response).to match(/http/)
      expect(@response).to match(/com/)
    end
  end
end

describe Pinup::Open do
  describe 'cli usage' do
    it 'should get called from the open command' do
      Pinup::Open.should_receive(:open_pins)
      %x[bundle exec bin/pinup open]
    end
  end
end
