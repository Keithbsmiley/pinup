require 'yaml'
require 'netrc'

module Pinup
  class Settings
    def self.write_settings(settings)
      File.open(SETTINGS, 'w') do |f|
        f.write(settings.to_yaml)
      end

      File.chmod(0600, SETTINGS)
    end

    def self.read_settings
      if !File.exists? SETTINGS
        return nil
      end

      settings = YAML::load_file(SETTINGS)
      if settings.nil? || settings.empty?
        return nil
      end

      return settings
    end

    def self.get_token
      path = DEFAULT_NETRC

      settings = read_settings
      if settings
        path = settings[:path]
      end

      netrc = Netrc.read(path)
      username, password = netrc[PINBOARD_URL]
      return token(username, password)
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
