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
      p username
      p password
      if username.nil? && password.nil?
        puts "Couldn't read credentials from #{ path }".red
        puts "Valid netrc syntax for pinboard looks like:

            machine pinboard.in
              password username:apitoken
          ".yellow
        exit_now!(nil)
      end

      if username.nil?
        # has token
      else
        # has user and pass
        uri = URI.parse("#{ API_URL }/user/api_token?format=json")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        # http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        request = Net::HTTP::Get.new(uri.request_uri)
        p uri.request_uri
        p uri.to_s
        request.basic_auth(username, password)
        response = http.request(request)
        p response.code
        p response.body
        p JSON.parse(response.body)
        p response.body.class
      end

      p netrc
      puts 'netrcc'
    end

    def self.authorize_credentials
      puts 'cred'
    end
  end
end
