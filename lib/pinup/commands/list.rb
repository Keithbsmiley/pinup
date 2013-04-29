module Pinup
  class List
    def self.list_pins(options = {})
      unread   = options[:unread]      unless options[:unread].nil?
      untagged = options[:untagged]    unless options[:untagged].nil?
      count    = options[:number].to_i unless options[:number].nil?
      delete   = options[:delete]      unless options[:delete].nil?

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
