# pinup

Pinup is a [RubyGem](http://rubygems.org/) for quickly getting through your [Pinboard](https://pinboard.in) bookmarks. It allows you to open or list your bookmarks and delete them afterwards (if you'd like).

## Authorization

First you need to setup your Pinboard credentials. Either:

In your `~/.netrc` (get your token from <https://pinboard.in/settings/password> and split it at the `:`)

```
machine pinboard.in
  login username
  password yourtoken
```

OR run:

```
pinup authorize
```

This will ask you for your username and password, which are then used to get your user token from Pinboard and save it to your `~/.netrc`

# Usage

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
