class Bookmark
  attr_accessor :href, :unread, :untagged

  def initialize(options = {})
    @href     = options['href']              unless options['href'].nil?
    @unread   = is_unread(options['toread']) unless options['toread'].nil?
    @untagged = is_untagged(options['tags']) unless options['tags'].nil?
  end

  def is_unread(attribute)
    if attribute == 'yes'
      true
    else
      false
    end
  end

  def is_untagged(attribute)
    if attribute.strip.empty?
      true
    else
      false
    end
  end

  def to_s
    "URL: #{ @href } Unread: #{ self.unread } Untagged: #{ self.untagged }"
  end
end
