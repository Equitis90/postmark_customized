# Griddler::PostmarkCustomized

Customized adapter for [Postmark](http://developer.postmarkapp.com/developer-inbound-parse.html) to use with [Griddler](https://github.com/thoughtbot/griddler)

Original gem - [griddler-postmark](https://github.com/r38y/griddler-postmark)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'griddler'
gem 'postmark_customized'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install postmark_customized

## Usage

Create an initializer with the following settings:

```ruby
Griddler.configure do |config|
  config.email_service = :postmark_customized
end
```
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
