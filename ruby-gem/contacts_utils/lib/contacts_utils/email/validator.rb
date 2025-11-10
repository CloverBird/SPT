module ContactsUtils
  module Email
    class Validator
      MAX_EMAIL_LENGTH = 320
      MAX_DOMAIN_LENGTH = 253
      TLD_MIN_LENGTH = 2
      LABEL_MAX_LENGTH = 63
      # these characters can be used in local part,
      # but it cannot start or end with them and cannot contain them consecutively
      SPECIAL_CHARACTERS = ['.', '_', '-'].freeze

      def validate(email)
        input = email.to_s
        str = input.strip
        errors = []

        errors << "Email is empty." if str.empty?
        # regex that ensures that checks str for containing spaces
        errors << "Email contains spaces." if str.match?(/\s/)
        errors << "Email contains non-ASCII characters." unless str.ascii_only?
        errors << "Email is too long (Max length is #{MAX_EMAIL_LENGTH}, but was #{str.length})." if str.length > MAX_EMAIL_LENGTH

        unless str.count("@") == 1
          errors << "Email must contain exactly one '@' symbol."
          return ContactsUtils::ValidationResult.new(errors: errors)
        end

        local, domain = str.split("@", 2)

        errors += validate_local(local) + validate_domain(domain)

        ContactsUtils::ValidationResult.new(errors: errors)
      end

      def validate_local(local)
        errors = []

        return ["Local part is empty."] if local.nil? || local.empty?

        # this regex check that string contains only letters (latin), digits and possible symbols
        unless local.match?(/\A[A-Za-z0-9.!#$%&'*+\/=?^_`{|}~-]+\z/)
          errors << "Local part contains invalid characters."
        end

        if SPECIAL_CHARACTERS.any? { |c| local.start_with?(c) || local.end_with?(c) }
          errors << "Local part cannot start or end with #{SPECIAL_CHARACTERS.join(', ')} symbols."
        end

        if SPECIAL_CHARACTERS.any? { |c| local.include?(c * 2) }
          errors << "Local part cannot contain #{SPECIAL_CHARACTERS.join(', ')} symbols consecutively."
        end

        errors
      end

      def validate_domain(domain)
        errors = []

        return ["Domain part is empty."] if domain.nil? || domain.empty?

        domain = domain.downcase

        if domain.length > MAX_DOMAIN_LENGTH
          errors << "Domain contains more than #{MAX_DOMAIN_LENGTH} characters."
        end
        labels = domain.split('.')

        if labels.length < 2
          errors << "Domain must contain a TLD."
          return errors
        end

        labels[0..-2].each do |label|
          errors += validate_domain_label(label)
          break if errors.any?
        end

        errors + validate_tld(labels.last)
      end

      def validate_domain_label(domain_label)
        errors = []

        return ["Domain name is empty."] if domain_label.nil? || domain_label.empty?

        # regex checks that tld contains only symbols and numbers
        unless domain_label.match?(/\A[a-z0-9-]+\z/)
          errors << "Domain label contains invalid characters."
        end

        if domain_label.length > LABEL_MAX_LENGTH
          errors << "Domain label #{domain_label} contains more than #{LABEL_MAX_LENGTH} characters."
        end

        if domain_label.start_with?('-') || domain_label.end_with?('-') || domain_label.include?('--')
          errors << "Domain label cannot start or end with hyphen or contain it consecutively."
        end

        errors
      end

      def validate_tld(tld)
        errors = []

        return ["Domain TLD is empty."] if tld.nil? || tld.empty?

        if tld.length > LABEL_MAX_LENGTH
          errors << "Domain TLD contains more than #{LABEL_MAX_LENGTH} characters."
        end

        if tld.length < TLD_MIN_LENGTH
          errors << "Domain TLD contains less than #{TLD_MIN_LENGTH} characters."
        end

        # regex checks that tld contains only symbols and numbers
        unless tld.match?(/\A[a-z0-9]+\z/)
          errors << "Domain TLD contains invalid characters."
        end

        errors
      end
    end
  end
end