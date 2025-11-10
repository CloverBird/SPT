module ContactsUtils
  class ValidationResult
    attr_reader :success, :errors

    def initialize(errors: [])
      @errors = errors.freeze
      @success = @errors.empty?
    end

    def success? = @success
  end
end