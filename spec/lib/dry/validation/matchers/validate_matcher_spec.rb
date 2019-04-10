require 'spec_helper'

module Dry::Validation::Matchers
  RSpec.describe ValidateMatcher do

    let(:schema_class) do
      Class.new(Dry::Validation::Schema) do
        define! do
          required(:username).filled(:str?, min_size?: 20)
          required(:first_name)
          required(:age).filled(:int?)
          required(:last_name).filled(:str?)
          optional(:mobile).filled
          optional(:email)
          optional(:height).filled(:float?)
          optional(:weight).filled(:decimal?)
          optional(:active).filled(:bool?)
          optional(:born_on).filled(:date?)
          optional(:dismissed_at).filled(:time?)
          optional(:born_at).filled(:date_time?)
          required(:pets).filled(:array?)
          required(:other).filled(:hash?)
          optional(:hair_color).filled(:str?, included_in?: %w(blue orange))
          optional(:address).value(min_size?: 1, max_size?: 10)
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

    describe "passing message details" do
      context "there are no details" do
        it "does not pollute the sentence with artifacts" do
          matcher = described_class.new(:email, :optional)
          matcher.matches?(schema_class)
          expect(matcher.description).
            to eq "validate for optional `email` exists"
        end
      end
    end

    describe "failing message details" do
      context "there are no details" do
        it "does not pollute the sentence with artifacts" do
          matcher = described_class.new(:asd, :required)
          matcher.matches?(schema_class)
          expect(matcher.failure_message).
            to eq "be missing validation for required `asd`"
        end
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

    context "checking `filled` type that is more specific than rule" do
      it "matches" do
        matcher = described_class.new(:mobile, :optional).filled(:int)
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "checking `required` only" do
      it "matches" do
        pending
        matcher = described_class.new(:first_name, :required)
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "checking `filled`" do
      it "matches" do
        matcher = described_class.new(:first_name, :required).filled
        expect(matcher.matches?(schema_class)).to be false

        matcher = described_class.new(:username, :required).filled
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "checking `filled` type `str`" do
      it "matches" do
        matcher = described_class.new(:username, :required).filled(:str)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:age, :required).filled(:str)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "checking `filled` type `int`" do
      it "matches" do
        matcher = described_class.new(:age, :required).filled(:int)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:last_name, :required).filled(:int)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "checking `filled` type `float`" do
      it "matches" do
        matcher = described_class.new(:email, :optional).filled(:float)
        expect(matcher.matches?(schema_class)).to be false

        matcher = described_class.new(:height, :optional).filled(:float)
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "checking `filled` type `decimal`" do
      it "matches" do
        matcher = described_class.new(:weight, :optional).filled(:decimal)
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "checking `filled` type `bool`" do
      it "matches" do
        matcher = described_class.new(:active, :optional).filled(:bool)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:weight, :optional).filled(:bool)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "checking `filled` type `date`" do
      it "matches" do
        matcher = described_class.new(:born_on, :optional).filled(:date)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:height, :optional).filled(:date)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "checking `filled` type `time`" do
      it "matches" do
        matcher = described_class.new(:dismissed_at, :optional).filled(:time)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:last_name, :required).filled(:time)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "checking `filled` type `date_time`" do
      it "matches" do
        matcher = described_class.new(:dismissed_at, :optional).filled(:date_time)
        expect(matcher.matches?(schema_class)).to be false

        matcher = described_class.new(:born_at, :optional).filled(:date_time)
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "checking `filled` type `array`" do
      it "matches" do
        matcher = described_class.new(:pets, :required).filled(:array)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:dismissed_at, :optional).filled(:array)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "checking `filled` type `hash`" do
      it "matches" do
        matcher = described_class.new(:other, :required).filled(:hash)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:born_at, :optional).filled(:hash)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "checking value `included_in`" do
      it "matches" do
        matcher = described_class.new(:hair_color, :optional).
          value(included_in: %w(white green))
        expect(matcher.matches?(schema_class)).to be false

        matcher = described_class.new(:hair_color, :optional).
          value(included_in: %w(orange blue))
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:hair_color, :optional).
          value(included_in: %w(orange blue white))
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    it "checks value against `min_size`" do
      matcher = described_class.new(:address, :optional).
        value(min_size: 3)
      expect(matcher.matches?(schema_class)).to be false

      matcher = described_class.new(:address, :optional).
        value(min_size: 2)
      expect(matcher.matches?(schema_class)).to be false

      matcher = described_class.new(:address, :optional).
        value(min_size: 1)
      expect(matcher.matches?(schema_class)).to be true
    end

    it "checks value against `max_size`" do
      matcher = described_class.new(:address, :optional).
        value(max_size: 11)
      expect(matcher.matches?(schema_class)).to be false

      matcher = described_class.new(:address, :optional).
        value(max_size: 10)
      expect(matcher.matches?(schema_class)).to be true

      matcher = described_class.new(:address, :optional).
        value(max_size: 9)
      expect(matcher.matches?(schema_class)).to be false
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

    describe "#description" do
      it "gives an apt description of passing spec" do
        matcher = described_class.new(:email, :optional).filled(:str)
        expect(matcher.description).
          to eq "validate for optional `email` (filled with str) exists"
      end
    end

    describe "#failure_message" do
      it "gives enough clues to the developer" do
        matcher = described_class.new(:email, :required).filled(:int)
        expect(matcher.failure_message).
          to eq "be missing validation for required `email` (filled with int)"
      end
    end

  end
end
