# pinup

Pinup is a [RubyGem](http://rubygems.org/) for quickly getting through your [Pinboard](https://pinboard.in) bookmarks. It allows you to open or list your bookmarks and delete them afterwards (if you'd like).

[![Build Status](https://travis-ci.org/Keithbsmiley/pinup.png?branch=master)](https://travis-ci.org/Keithbsmiley/pinup)
[![Code Climate](https://codeclimate.com/github/Keithbsmiley/pinup.png)](https://codeclimate.com/github/Keithbsmiley/pinup)
[![Dependency Status](https://gemnasium.com/Keithbsmiley/pinup.png)](https://gemnasium.com/Keithbsmiley/pinup)

## Authorization

First you need to setup your Pinboard credentials. Either:

```
pinup authorize
```

This will ask you for your username and password, which are then used to get your user token from Pinboard and save it to your `~/.netrc`

Or in your `~/.netrc` (get your token from <https://pinboard.in/settings/password> and split it at the `:`)

```
machine pinboard.in
  login username
  password token
```

Note that in the end these achieve the same result. Your Pinboard username and token (not password) are saved in your `~/.netrc` file. If you'd like to save it in a different location check out the `--path` argument with `pinup authorize -h`


## Usage

```
pinup open
```

By default this will open your 20 most recent unread or untagged bookmarks in the default browser. If that's not to your fancy you can use some flags to change the behavior:

```
pinup open --no-untagged
```

This will open your 20 most recent unread bookmarks, without the untagged ones. There is also a `--no-unread` flag for just untagged entires. Using:

```
pinup open --no-untagged --no-unread
```

Will open bookmarks that are both tagged and marked as read. I think you get the idea. But of course you can also limit the number of responses.

```
pinup open -n 5
pinup open --number=5
```

Will show the most recent five bookmarks. You can also delete the bookmarks from Pinboard as they are opened:

```
pinup open --no-untagged --delete -n 5
```

There is also a list command that takes the same arguments as `open` but instead of opening the URLs it just prints them one per line to the console. This way you could pipe the output in to another command for additional processing.

## Installation

```
[sudo] gem install pinup
```

Pinup requires Ruby 1.9+ I recommend you install it with [rbenv](https://github.com/sstephenson/rbenv/). [RVM](https://rvm.io/) exists as well. Note that this is higher than the default installation on OS X. Ruby 1.8 is [no longer being supported](http://www.ruby-lang.org/en/news/2011/10/06/plans-for-1-8-7/) so I suggest you upgrade anyways.

