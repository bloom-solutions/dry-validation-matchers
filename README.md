# Dry::Validation::Matchers

RSpec matchers for [Dry::Validation](dry-rb.org/gems/dry-validation).

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
RSpec.describe "Integration with RSpec", type: %i[dry_validation] do

  subject(:schema_class) do
    Class.new(Dry::Validation::Contract) do
      register_macro(:email) do
        key.failure('must_be_a_valid_email') if value.is_a?(String) &&
            !value.match?(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      end

      register_macro(:precision) do |macro:|
        num = macro.args[0]
        key.failure("cant_have_more_than_#{num}_decimal_numbers") if value && value.to_s.split('.').last.size > num
      end

      params do
        required(:username).filled
        required(:first_name)
        required(:age).filled(:integer)
        required(:last_name).filled(:string)
        optional(:mobile).filled
        optional(:email)
        optional(:decimal_value)
      end

      rule(:email).validate(:email)
      rule(:decimal_value).validate(precision: 5)
    end
  end

  it { is_expected.to validate(:username, :required).filled }
  it { is_expected.to validate(:mobile, :optional).filled }
  it { is_expected.to validate(:email, :optional) }
  it { is_expected.to validate(:email, :optional).macro_use?(:email) }
  it { is_expected.to validate(:decimal_value, :optional).macro_use?(precision: 5) }
end
```

See `spec/acceptance/rspec_spec.rb` as well.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bloom-solutions/dry-validation-matchers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

