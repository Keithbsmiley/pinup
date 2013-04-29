module Pinup
  class List
    def self.list_pins(options = {})
      unread   = options[:unread]
      untagged = options[:untagged]
      count    = options[:number].to_i
      delete   = options[:delete]

      items        = Pinup::Queries.list_items
      filtered     = Pinup::Queries.filter_items(items, unread, untagged, count)
      items_string = Pinup::Queries.item_string(filtered)
      urls         = items_string.split(/\n/)

      puts items_string

      if delete
        Pinup::Queries.delete_items(urls)
      end
    end
  end
end
