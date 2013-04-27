module Pinup
  class List
    def self.list_pins(options = {})
      unread   = options[:unread]   unless options[:unread].nil?
      untagged = options[:untagged] unless options[:untagged].nil?
      items = Pinup::Queries.list_items(unread, untagged)
      Pinup::Queries.print_items(items, unread, untagged)
    end
  end
end
