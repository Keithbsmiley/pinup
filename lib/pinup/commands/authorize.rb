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
      elsif !path.nil? && DEFAULT_NETRC != path
        Pinup::Settings.write_settings({path: path})
      else
        Pinup::Settings.clear_settings
      end

      return true
    end

    def self.authorize_credentials(options = {})
      # Ask for user and pass, save to passed or default netrc location
      username = options[:username] || ask('Enter your username')
      password = options[:password] || ask('Enter your password (not saved)')

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

        token = response.body['result']

        options[:path]  = path
        options[:token] = token

        Pinup::Settings.save_token(options)

        return true
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
        if !username.nil? && !username.empty? && !password.nil? && !password.empty?
          request.basic_auth(username, password)
        end

        http.request(request)
      end
  end
end
