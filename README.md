# Dry::Validation::Matchers

[![Build Status](https://travis-ci.org/imacchiato/dry-validation-matchers.svg?branch=master)](https://travis-ci.org/imacchiato/dry-validation-matchers)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/dry/validation/matchers`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dry-validation-matchers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dry-validation-matchers

## Usage

```ruby
subject(:schema_class) do
  Class.new(Dry::Validation::Schema) do
    define! do
      required(:username).filled
      required(:first_name)
      required(:age).filled(:int?)
      required(:last_name).filled(:str?)
      optional(:mobile).filled
      optional(:email)
    end
  end
end

it { is_expected.to validate(:username, :required).filled }
it { is_expected.to validate(:mobile, :optional).filled }
it { is_expected.to validate(:email, :optional) }
```

See `spec/acceptance/rspec_spec.rb` as well.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dry-validation-matchers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

