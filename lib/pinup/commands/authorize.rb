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
        puts 'Valid netrc syntax for pinboard looks like:

            machine pinboard.in
              login username
              password apitoken'.yellow
        exit_now!(nil)
      end

      token = token(username, password)
      parameters = JSON_PARAMS
      parameters[:auth_token] = token

      uri = URI.parse("#{ API_URL }/user/api_token")
      uri.query = URI.encode_www_form(JSON_PARAMS)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      if response.code != 200
        puts "Invalid user credentials in #{ path }".red
        exit_now!(nil)
      end
    end

    def self.authorize_credentials
      puts 'cred'
    end

    def self.token(username, password)
      "#{ username }:#{ password }"
    end
  end
end
