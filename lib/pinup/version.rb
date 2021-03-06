module Pinup
  VERSION       = '0.1.5'
  SETTINGS      = File.expand_path('~/.pinup')
  PINBOARD_URL  = 'pinboard.in'
  API_URL       = 'https://api.pinboard.in/v1'
  JSON_PARAMS   = { format: 'json' }
  DEFAULT_NETRC = File.expand_path('~/.netrc')
  DELETE_PATH   = 'posts/delete'
  LIST_PATH     = 'posts/all'
end
