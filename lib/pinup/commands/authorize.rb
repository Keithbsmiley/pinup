require 'net/https'
require 'uri'
require 'json'
require 'netrc'

module Pinup
  class Authorize
    def self.authorize(options)
      p options
      puts 'authorizerrr'

      if options[:netrc]
        authorize_netrc(options)
      else
        authorize_credentials(options)
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
        puts 'Valid netrc syntax for pinboard looks like:

            machine pinboard.in
              login username
              password apitoken
        
              NOTE: Just include the digits from the API token for the password'.yellow
        return nil
      end

      token = Pinup::Settings.token(username, password)
      parameters = JSON_PARAMS
      parameters[:auth_token] = token
      response = authorize(parameters)

      if response.code != '200'
        puts "Invalid user credentials in #{ path }".red
        exit_now!(nil)
      elsif !path.nil? && DEFAULT_NETRC != path
        Pinup::Settings.write_settings({path: path})
      else
        Pinup::Settings.clear_settings
      end
    end

    def self.authorize_credentials(options)
      # Ask for user and pass, save to passed or default netrc location
      username = ask('Enter your username')
      password = ask('Enter your password (not saved)')

      parameters = { params: JSON_PARAMS, username: username, password: password }
      response = authorize(parameters)

      if response.code != '200'
        puts 'Invalid user credentials'.red
        return nil
      else
        Pinup::Settings.save_token({path: path})
      end
    end

    def self.ask(string)
      print "#{ string }: "
      gets.chomp
    end

    private

      def self.authorize(options = {})
        parameters = options[:params]   || {}
        username   = options[:username] || {}
        password   = options[:password] || {}

        uri = URI.parse("#{ API_URL }/user/api_token")
        uri.query = URI.encode_www_form(parameters)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        http.request(request)
      end
  end
end
