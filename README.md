# Guard::WebsocketRails

Guard::WebsocketRails allows you to automatically start and stop your websocket-rails standalone server.

## Installation

The simplest way to install Guard is to use [Bundler](http://gembundler.com/).
Please make sure to have [Guard](https://github.com/guard/guard) installed before continue.

Add this line to your application's Gemfile:

```ruby
gem 'guard-websocket-rails', group: :development
```

And then execute:

    $ bundle

Add the default Guard::WebsocketRails template to your Guardfile by running:

    $ guard init websocket-rails

## Options
You can set RAILS\_ENV by setting the  `:environment` option.

```ruby
guard 'websocket-rails', :environment => 'development' do
  watch('Gemfile.lock')
  watch('config/sunspot.yml')
end

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/guard-websocket-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
