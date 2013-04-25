module Pinup
  VERSION       = '0.0.1'
  SETTINGS      = File.expand_path('~/.pinup')
  PINBOARD_URL  = 'pinboard.in'
  API_URL       = 'https://api.pinboard.in/v1'
  JSON_PARAMS   = { format: 'json' }
  DEFAULT_NETRC = File.expand_path('~/.netrc')
end
