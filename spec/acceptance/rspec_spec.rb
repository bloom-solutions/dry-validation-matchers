require 'spec_helper'

RSpec.describe "Integration with RSpec", type: %i[dry_validation] do

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

end
