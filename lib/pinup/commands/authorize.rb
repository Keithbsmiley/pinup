module Pinup
  class Authorize
    def self.authorize(options)
      p options
      puts 'authorizerrr'

      if options[:netrc]
        authorize_netrc
      else
        authorize_credentials
      end
    end

    def self.authorize_netrc
      puts 'netrcc'
    end

    def self.authorize_credentials
      puts 'cred'
    end
  end
end
