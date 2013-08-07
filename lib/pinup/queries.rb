require 'net/https'
require 'uri'
require 'json'
require 'typhoeus'

module Pinup
  class Queries
    def self.list_items
      token = Pinup::Settings.get_token
      if token.nil?
        return nil
      end

      parameters = JSON_PARAMS.dup
      parameters[:auth_token] = token

      request = Typhoeus::Request.new(
        "#{ API_URL }/#{ LIST_PATH }",
        :params => parameters
      )
      response = request.run

      if response.response_code != 200
        puts "Error getting bookmarks: #{ response.response_body }"
        return nil
      else
        return response.response_body
      end
    end

    def self.filter_items(response, unread, untagged, count = 20)
      begin
        json = JSON.parse(response)
      rescue JSON::ParserError => e
        puts "Failed to parse JSON: #{ e }"
        exit
      end

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
      hydra = Typhoeus::Hydra.new

      urls.each do |url|
        url_params = parameters.dup
        url_params[:url] = url
        request = Typhoeus::Request.new(
          "#{ API_URL }/#{ DELETE_PATH }",
          :params => url_params
        )

        hydra.queue(request)
      end

      hydra.run
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
  end
end
