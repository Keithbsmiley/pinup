require 'launchy'

module Pinup
  class Open
    def self.open_pins(options = {})
      unread   = options[:unread]
      untagged = options[:untagged]
      count    = options[:number].to_i
      delete   = options[:delete]

      items        = Pinup::Queries.list_items
      filtered     = Pinup::Queries.filter_items(items, unread, untagged, count)
      items_string = Pinup::Queries.item_string(filtered)
      urls         = items_string.split(/\n/)

      if count > 0 # For testing
        urls.delete_if do |url|
          Launchy.open(url) do |exception|
            true # if there is an exception remove it from the array so it is not deleted
          end

          false
        end
      else
        puts "You must specify more than #{ count } items"
      end

      if delete
        Pinup::Queries.delete_items(urls)
      end
    end
  end
end
