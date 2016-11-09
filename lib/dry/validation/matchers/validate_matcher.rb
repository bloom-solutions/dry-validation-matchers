module Dry::Validation::Matchers
  class ValidateMatcher

    DEFAULT_TYPE = :str
    TYPE_ERRORS = {
      str: {
        test_value: "str",
        message: "must be a string",
      },
      int: {
        test_value: 43,
        message: "must be an integer",
      },
      float: {
        test_value: 41.5,
        message: "must be a float",
      },
      decimal: {
        test_value: BigDecimal.new("41.5"),
        message: "must be a decimal",
      },
      bool: {
        test_value: false,
        message: "must be a boolean",
      },
      date: {
        test_value: Date.new(2011, 1, 2),
        message: "must be a date",
      },
      time: {
        test_value: Time.new(2011, 1, 2, 2, 33),
        message: "must be a time",
      },
      date_time: {
        test_value: DateTime.new(2011, 5, 1, 2, 3, 4),
        message: "must be a date_time",
      },
      array: {
        test_value: [1, 3, 5],
        message: "must be a array",
      },
      hash: {
        test_value: {hello: "there"},
        message: "must be a hash",
      },
    }

    def initialize(attr, acceptance)
      @attr = attr
      @acceptance = acceptance
      @type = DEFAULT_TYPE
    end

    def description
      @desc = []
      @desc << "validation for #{@acceptance} `#{@attr}`"
      @desc << " ("
      @desc << "filled with #{@type}" if @check_filled
      @desc << ")"
      @desc << " exists"
      @desc.join
    end

    def failure_message
      @desc = []
      @desc << "validation for #{@acceptance} `#{@attr}`"
      @desc << " ("
      @desc << "filled with #{@type}" if @check_filled
      @desc << ")"
      @desc << " is lacking"
      @desc.join
    end

    def matches?(schema_or_schema_class)
      if schema_or_schema_class.is_a?(Dry::Validation::Schema)
        schema = schema_or_schema_class
      elsif schema_or_schema_class.is_a?(Class) &&
        schema_or_schema_class.ancestors.include?(Dry::Validation::Schema)

        schema = schema_or_schema_class.new
      else
        fail(
          ArgumentError,
          "must be a schema instance or class; got #{schema_or_schema_class.inspect} instead"
        )
      end

      check_required_or_optional!(schema) &&
        check_filled!(schema) &&
        check_filled_with_type!(schema)
    end

    def filled(type=:str)
      @check_filled = true
      @type = type
      self
    end

    private

    def check_required_or_optional!(schema)
      case @acceptance
      when :required
        result = schema.({})
        error_messages = result.errors[@attr]
        error_messages.present? && error_messages.include?("is missing")
      else
        result = schema.({})
        result.errors[@attr].nil?
      end
    end

    def check_filled!(schema)
      return true if !@check_filled

      result = schema.(@attr => nil)
      if result.errors[@attr].nil? ||
          !result.errors[@attr].include?("must be filled")
        return false
      end
      true
    end

    def check_filled_with_type!(schema)
      return true if !@check_filled
      result = schema.(@attr => TYPE_ERRORS[@type][:test_value])
      error_messages = result.errors[@attr]
      return true if error_messages.nil?
      allowed_errors = [TYPE_ERRORS[@type][:message]] & error_messages
      unallowed_errors = error_messages - allowed_errors
      unallowed_errors.empty?
    end

  end
end
