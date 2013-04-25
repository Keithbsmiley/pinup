require 'netrc'

module Pinup
  class Authorize
    def self.authorize(options)
      p options
      puts 'authorizerrr'

      if options[:netrc]
        authorize_netrc(options)
      else
        authorize_credentials
      end
    end

    def self.authorize_netrc(options)
      path = options[:path]
      if path
        path = File.expand_path(path)
        netrc = Netrc.read(path)
      else
        netrc = Netrc.read
      end

      username, password = netrc[PINBOARD_URL]
      if username.nil? || password.nil?
        puts "Couldn't read credentials from #{ path }".red
        puts "Correct netrc syntax looks like:

            machine pinboard.in
              login email@foo.com
              password mysekret
          ".yellow
        exit_now!(nil)
      end

      p netrc
      puts 'netrcc'
    end

    def self.authorize_credentials
      puts 'cred'
    end
  end
end
