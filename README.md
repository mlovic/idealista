# Idealista

**Gem still in early development**

A Ruby interface to the [idealista.com](https://www.idealista.com) API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'idealista'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install idealista

## Usage

```ruby
require 'idealista'

client = Idealista::Client.new("YOUR_API_KEY")

query = {country:       "es",
         max_items:      5,
         num_page:       1,
         center:        "40.4229014,-3.6976351",
         distance:       100,
         property_type: "bedrooms",
         operation:     "A",
         }

properties = client.search(query)
  #=> [#<Idealista::Property:0x007ff732c82d10 @price=500, ...
```

## Configuration

```ruby
client.configure do |config| 
  config.wait_and_retry = true

  config.wait_and_retry do |w|
    w.sleep_time = 2
    w.number_of_retries = 2
end
```
## Contributing

To contribute, get your API key from http://developers.idealista.com/access-request, and edit `secret.sample.rb`. Then rename file to `secret.rb`.

1. Fork it ( https://github.com/[my-github-username]/idealista/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

