module Pinup
  class List
    def self.list_pins(options)
      p Pinup::Settings.read_settings
    end
  end
end
