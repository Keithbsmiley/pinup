require 'io/console'
require 'net/https'
require 'uri'
require 'json'
require 'netrc'
require 'colored'

module Pinup
  class Authorize
    def self.authorize_command(options)
      if options[:netrc]
        authorize_netrc(options)
      else
        authorize_credentials(options)
      end
    end

    def self.authorize_netrc(options = {})
      path = DEFAULT_NETRC
      if options[:path]
        path = File.expand_path(options[:path])
      end

      netrc = Netrc.read(path)
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
      parameters = JSON_PARAMS.dup
      parameters[:auth_token] = token
      response = authorize({ params: parameters })

      if response.code != '200'
        puts "Invalid user credentials in #{ path }".red
        return nil
      elsif path && DEFAULT_NETRC != path
        Pinup::Settings.write_settings({ path: path })
      else
        Pinup::Settings.clear_settings
      end

      return true
    end

    def self.authorize_credentials(options = {})
      # Ask for user and pass, save to passed or default netrc location
      # Reading from options hash for testing

      print 'Enter your username: ' if options[:username].nil?
      username = options[:username] || gets.chomp
      print 'Enter your password (not saved): ' if options[:password].nil?
      password = options[:password] || STDIN.noecho(&:gets).chomp

      parameters = { params: JSON_PARAMS.dup, username: username, password: password }
      response = authorize(parameters)

      if response.code != '200'
        puts 'Invalid user credentials'.red
        return nil
      else
        path = DEFAULT_NETRC
        if options[:path]
          path = File.expand_path(options[:path])
        end

        json   = JSON.parse(response.body)
        digits = json['result']
        token = Pinup::Settings.token(username, digits)

        options[:path]  = path
        options[:token] = token

        Pinup::Settings.save_token(options)

        return true
      end
    end

    private

      def self.authorize(options = {})
        parameters = options[:params] || {}
        username   = options[:username]
        password   = options[:password]

        uri = URI.parse("#{ API_URL }/user/api_token")
        uri.query = URI.encode_www_form(parameters)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        if username && password
          request.basic_auth(username, password)
        end

        http.request(request)
      end
  end
end
