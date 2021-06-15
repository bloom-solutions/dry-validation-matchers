require 'spec_helper'

module Dry::Validation::Matchers
  RSpec.describe ValidateMatcher do

    let(:schema_class) do
      Class.new(Dry::Validation::Contract) do
        params do
          required(:username).filled(:string, min_size?: 20)
          required(:first_name)
          required(:age).filled(:integer)
          required(:last_name).filled(:string)
          optional(:mobile).filled
          optional(:email)
          optional(:height).filled(:float)
          optional(:weight).filled(:decimal)
          optional(:active).filled(:bool)
          optional(:born_on).filled(:date)
          optional(:dismissed_at).filled(:time)
          optional(:born_at).filled(:date_time)
          required(:pets).filled(:array)
          required(:other).filled(:hash)
          optional(:hair_color).filled(:string, included_in?: %w(blue orange))
          optional(:address).value(min_size?: 1, max_size?: 10)
        end

        register_macro(:email) do
          key.failure('must_be_a_valid_email') if value.is_a?(String) &&
              !value.match?(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
        end

        register_macro(:precision) do |macro:|
          num = macro.args[0]
          key.failure("cant_have_more_than_#{num}_decimal_numbers") if value && value.to_s.split('.').last.size > num
        end

        rule(:email).validate(:email)
        rule(:weight).validate(precision: 2)
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
        matcher = described_class.new(:mobile, :optional).filled(:integer)
        expect(matcher.matches?(schema_class)).to be true
      end
    end

    context "checking `required` only" do
      it "matches" do
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
        matcher = described_class.new(:username, :required).filled(:string)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:age, :required).filled(:string)
        expect(matcher.matches?(schema_class)).to be false
      end
    end

    context "checking `filled` type `int`" do
      it "matches" do
        matcher = described_class.new(:age, :required).filled(:integer)
        expect(matcher.matches?(schema_class)).to be true

        matcher = described_class.new(:last_name, :required).filled(:integer)
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

    describe '#macro_use?' do
      context 'when have one parameter' do
        it 'returns true when macro uses' do
          matcher = described_class.new(:email, :optional).macro_use?(:email)
          expect(matcher.matches?(schema_class)).to be true
        end

        it 'returns false when macro unused' do
          matcher = described_class.new(:email, :optional).macro_use?(:wrong)
          expect(matcher.matches?(schema_class)).to be false
        end
      end

      context 'when have two parameters' do
        it 'returns true when macro uses' do
          matcher = described_class.new(:weight, :optional).macro_use?(precision: 2)
          expect(matcher.matches?(schema_class)).to be true
        end

        it 'returns false when macro unused' do
          matcher = described_class.new(:weight, :optional).macro_use?(precision: 3)
          expect(matcher.matches?(schema_class)).to be false
        end
      end
    end

    describe "#description" do
      it "gives an apt description of passing spec" do
        matcher = described_class.new(:email, :optional).filled(:string)
        expect(matcher.description).
          to eq "validate for optional `email` (filled with string) exists"
      end

      it "gives an apt description of passing macro spec" do
        matcher = described_class.new(:weight, :optional).macro_use?(precision: 2)
        expect(matcher.description).
            to eq "validate for optional `weight` (macro usage `{:precision=>2}`) exists"
      end
    end

    describe "#failure_message" do
      it "gives enough clues to the developer" do
        matcher = described_class.new(:email, :required).filled(:integer)
        expect(matcher.failure_message).
          to eq "be missing validation for required `email` (filled with integer)"
      end

      it "gives enough clues to the developer when testing macro" do
        matcher = described_class.new(:weight, :optional).macro_use?(precision: 3)
        expect(matcher.failure_message).
            to eq "be missing validation for optional `weight` (macro usage `{:precision=>3}`)"
      end
    end
  end
end
