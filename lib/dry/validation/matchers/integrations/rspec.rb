if defined?(RSpec)
  RSpec.configure do |c|
    c.include Dry::Validation::Matchers, type: :dry_validation
  end
end
