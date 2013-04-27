module Pinup
  class List
    def self.list_pins(options = {})
      unread   = options[:unread]      unless options[:unread].nil?
      untagged = options[:untagged]    unless options[:untagged].nil?
      count    = options[:number].to_i unless options[:number].nil?
      items    = Pinup::Queries.list_items(unread, untagged, count)
      Pinup::Queries.print_items(items, unread, untagged)
    end
  end
end
