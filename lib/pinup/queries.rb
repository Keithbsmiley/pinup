require 'net/https'
require 'uri'
require 'json'

module Pinup
  class Queries
    def self.list_items(unread = true, untagged = true)
      token = Pinup::Settings.get_token
      if token.nil?
        return nil
      end

      parameters = JSON_PARAMS.dup
      parameters[:auth_token] = token

      response = list_query(parameters)
      if response.code != '200'
        puts "Error getting bookmarks: #{ response.body }"
        return nil
      else
        print_response(response.body, unread, untagged)
      end
    end

    private
      
      def self.list_query(parameters)
        uri = URI.parse("#{ API_URL }/posts/recent")
        uri.query = URI.encode_www_form(parameters)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        http.request(request)
      end

      def self.print_response(response, unread, untagged)
        begin
          json = JSON.parse(response)
        rescue JSON::ParserError => e
          puts "Failed to parse JSON: #{ e }"
          exit
        end

        json.each do |item|
          bookmark = Bookmark.new(item)
          if bookmark.unread == unread || bookmark.untagged == untagged
            puts bookmark.href
          end
        end
      end
  end
end
