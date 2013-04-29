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

      response = pinboard_query(LIST_PATH, parameters)
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

      count     = 20 if count < 1
      new_items = []

      json.each do |item|
        bookmark = Bookmark.new(item)

        if should_show(bookmark, unread, untagged)
          new_items << bookmark
        end

        if new_items.count >= count
          break
        end
      end

      return new_items
    end

    def self.delete_items(urls)
      token = Pinup::Settings.get_token
      if token.nil?
        return nil
      end

      parameters = JSON_PARAMS.dup
      parameters[:auth_token] = token

      urls.each do |url|
        url_params = parameters.dup
        url_params[:url] = url
        pinboard_query(DELETE_PATH, url_params)
      end
    end

    def self.should_show(bookmark, unread, untagged)
      if unread && untagged
        if bookmark.unread || bookmark.untagged
          return true
        end
      elsif unread
        if bookmark.unread && !bookmark.untagged
          return true
        end
      elsif untagged
        if bookmark.untagged && !bookmark.unread
          return true
        end
      else
        if !bookmark.unread && !bookmark.untagged
          return true
        end
      end

      return false
    end

    def self.item_string(items)
      item_output = ""
      items.each do |item|
        item_output << "#{ item.href }\n"
      end

      return item_output
    end

    private

      def self.pinboard_query(path, parameters)
        uri = URI.parse("#{ API_URL }/#{ path }")
        uri.query = URI.encode_www_form(parameters)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        http.request(request)
      end
  end
end
