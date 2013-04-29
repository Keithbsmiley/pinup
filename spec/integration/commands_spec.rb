require_relative '../spec_helper'

describe Pinup::List do
  describe 'cli usage' do
    before do
      Pinup::List.list_pins
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
    before do
      Pinup::Open.open_pins({ number: 0 })
      @output = %x[bundle exec bin/pinup open -n 0]
    end

    it 'should get called from the open command' do
      expect(@output).to match(/0/)
      expect(@output).to match(/specify/)
    end
  end
end
