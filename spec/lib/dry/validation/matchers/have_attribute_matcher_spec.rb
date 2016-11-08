require 'spec_helper'

module Dry::Validation::Matchers
  RSpec.describe ValidateMatcher do

    let(:schema_class) do
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

    context "attribute is required" do
      it "matches" do
        matcher = described_class.new(:username, :required)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:mobile, :required)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "attribute is required", "checking `filled`" do
      it "matches" do
        matcher = described_class.new(:first_name, :required).filled
        expect(matcher.matches?(schema_class)).to be false

        matcher = described_class.new(:username, :required).filled
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "attribute is required", "checking `filled` type" do
      it "matches" do
        matcher = described_class.new(:username, :required).filled(:str)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:age, :required).filled(:str)
        expect(matcher.matches?(schema_class)).to be false

        matcher = described_class.new(:age, :required).filled(:int)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:last_name, :required).filled(:int)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "attribute is optional" do
      it "matches" do
        matcher = described_class.new(:mobile, :optional)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:last_name, :optional)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "attribute is optional", "checking `filled` type" do
      it "matches" do
        matcher = described_class.new(:last_name, :optional).filled
        expect(matcher.matches?(schema_class)).to be false

        matcher = described_class.new(:email, :optional).filled
        expect(matcher.matches?(schema_class)).to be false

        matcher = described_class.new(:email, :optional)
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "attribute is optional", "checking `filled` type that is more specific than rule" do
      it "matches" do
        matcher = described_class.new(:mobile, :optional).filled(:int)
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "given a wrong class to match" do
      it "raises an intelligible error" do
        matcher = described_class.new(:mobile, :optional)
        expect { matcher.matches?("invalid") }.to raise_error(
          ArgumentError,
          %Q(must be a schema instance or class; got "invalid" instead)
        )
      end
    end

  end
end
