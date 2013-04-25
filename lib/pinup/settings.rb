require 'yaml'
require 'netrc'

module Pinup
  class Settings
    def self.write_settings(settings)
      File.open(SETTINGS, 'w') do |f|
        f.write(settings.to_yaml)
      end
    end

    def self.read_settings
      if !File.exists? SETTINGS
        return nil
      end

      settings = YAML::load_file(SETTINGS)
      if !settings || settings.empty?
        return nil
      end

      return settings
    end

    def self.save_token(options = {})
      path  = DEFAULT_NETRC
      token = options[:token]

      if token.nil?
        puts 'Attempted to save empty token'.red
        return
      end

      if options[:path]
        path = options[:path]
      end

      token_split = token.split(/:/)
      if token_split.count != 2
        puts "Invalid token #{ token_split.join(':') }".red
        return
      end

      username = token_split.first
      password = token_split.last
      
      netrc = Netrc.read(path)
      netrc[PINBOARD_URL] = username, password
      netrc.save

      return true
    end

    def self.get_token
      path = DEFAULT_NETRC

      settings = read_settings
      if settings
        path = settings[:path]
      end

      netrc = Netrc.read(path)
      username, password = netrc[PINBOARD_URL]
      token = token(username, password)
      if token.nil?
        puts "There are no credentials in #{ path }".red
        exit_now!(nil)
      end

      return token
    end

    def self.clear_settings
      if File.exists? SETTINGS
        File.delete(SETTINGS)
      end
    end

    def self.token(username, password)
      if username.nil? || password.nil?
        return nil
      end

      "#{ username }:#{ password }"
    end
  end
end
