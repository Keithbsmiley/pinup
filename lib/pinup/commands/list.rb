module Pinup
  class List
    def self.list_pins(options = {})
      unread   = options[:unread]      unless options[:unread].nil?
      untagged = options[:untagged]    unless options[:untagged].nil?
      count    = options[:number].to_i unless options[:number].nil?
      items    = Pinup::Queries.list_items(count)
      filtered = Pinup::Queries.filter_items(items, unread, untagged)
      puts Pinup::Queries.item_string(filtered)
    end
  end
end
