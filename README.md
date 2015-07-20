# Idealista

Gem not published yet!!
=======================

A Ruby interface to the idealista.com API.

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
client = Idealista::Client.new("YOUR_API_KEY")

query = {"country" => "es",
         "max_items" => 5,
         "num_page" => 1,
         "center" => "40.4229014,-3.6976351",
         "property_type" => "bedrooms",
         "operation" => "A",
         }

properties = client.search(query)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/idealista/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

