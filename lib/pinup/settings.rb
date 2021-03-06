require 'yaml'
require 'netrc'
require 'colored'

module Pinup
  class Settings
    def self.write_settings(settings)
      File.open(SETTINGS, 'w') do |f|
        f.write(settings.to_yaml)
      end
    end

    def self.read_settings
      settings = nil
      if File.exists?(SETTINGS)
        settings = YAML::load_file(SETTINGS)
      end

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
        return nil
      end

      if options[:path]
        path = options[:path]
      end

      token_split = token.split(/:/)
      if token_split.count != 2
        puts "Invalid token #{ token_split.join(':') }".red
        return nil
      end

      username = token_split.first
      password = token_split.last
      
      netrc = Netrc.read(path)
      netrc.new_item_prefix = "\n\n# This Entry was added automatically\n"
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
        return nil
      end

      return token
    end

    def self.clear_settings
      if File.exists? SETTINGS
        File.delete(SETTINGS)
      end
    end

    def self.token(username, password)
      if username.nil? || password.nil? || username.empty? || password.empty?
        return nil
      end

      "#{ username }:#{ password }"
    end
  end
end
