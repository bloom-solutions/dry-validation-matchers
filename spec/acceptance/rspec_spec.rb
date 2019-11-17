require 'spec_helper'

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
        required(:age).filled(:int?)
        required(:last_name).filled(:str?)
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
