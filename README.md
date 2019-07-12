# HatenaFotolife

A library to Hatena Fotolife Atom API.
You can upload image to hatena fotolife using this gem.
This gem is inspired_by [hatenablog](https://github.com/kymmt90/hatenablog) gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hatena_fotolife'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hatena_fotolife

## OAuth credentials
Hatena Fotolife API requires user authentication with OAuth.
So you need to get OAuth 1.0a keys and consumer tokens before using this gem.

### 1. Get consumer_key & consumer_secret 
Get consumer_key and consumer_secret from [Hatena Developer Center](https://www.hatena.ne.jp/rlho/config/auth/develop)

### 2. Get access_token & access_token_secret

```
% bundle exec get_access_token <consumer_key> <consumer_secret>
```

## Usage
1. Create config.yml file

```yaml
consumer_key: <Hatena application consumer key>
consumer_secret: <Hatena application consumer secret>
access_token: <Hatena application access token>
access_token_secret: <Hatena application access token secret>
```

2. Run
```ruby
require 'hatena_fotolife'

# Read the configuration from 'config.yml'
HatenaFotolife::Client.create.post_image(file_path: your_image_path)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rlho/hatena_fotolife. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HatenaFotolife project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hatena_fotolife/blob/master/CODE_OF_CONDUCT.md).
