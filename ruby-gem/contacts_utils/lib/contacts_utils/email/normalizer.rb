module ContactsUtils
  module Email
    class Normalizer
      def normalize(email)
        input = email.to_s
        str = input.strip

        # basic validation
        raise ArgumentError, "Email must contain exactly one @" unless str.count("@") == 1

        local, domain = str.split("@", 2)
        raise ArgumentError, "Local part is empty"  if local.nil?  || local.empty?
        raise ArgumentError, "Domain part is empty" if domain.nil? || domain.empty?

        "#{local}@#{domain.downcase}"
      end
    end
  end
end