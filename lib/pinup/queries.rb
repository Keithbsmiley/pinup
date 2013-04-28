require 'net/https'
require 'uri'
require 'json'

module Pinup
  class Queries
    def self.list_items
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
        return response.body
      end
    end

    def self.filter_items(response, unread, untagged, count)
      begin
        json = JSON.parse(response)
      rescue JSON::ParserError => e
        puts "Failed to parse JSON: #{ e }"
        exit
      end

      new_items = []

      json.each do |item|
        bookmark = Bookmark.new(item)

        if unread
          if unread && bookmark.unread
            new_items << bookmark
          end
        elsif untagged
          if untagged && bookmark.untagged
            new_items << bookmark
          end
        else
          if !bookmark.unread && !bookmark.untagged
            new_items << bookmark
          end
        end
      end

      return new_items
    end

    def self.item_string(items)
      item_output = ""
      items.each do |item|
        item_output << "#{ item.href }\n"
      end

      return item_output
    end

    private
      
      def self.list_query(parameters)
        uri = URI.parse("#{ API_URL }/posts/all")
        uri.query = URI.encode_www_form(parameters)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        http.request(request)
      end
  end
end
