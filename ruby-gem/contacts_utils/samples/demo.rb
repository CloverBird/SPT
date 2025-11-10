$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "contacts_utils"

def print_validation_result(label, result)
  puts "- #{label}"
  puts "  sucess: #{result.success?}"
  puts "  errors: #{result.errors.inspect}"
end

def show_value(label, value)
  puts "- #{label}"
  puts "  #{value.inspect}"
end

# email validation check
print "Email Validator:\n"

email_validator = ContactsUtils::Email::Validator.new
print_validation_result("valid: user@example.com", email_validator.validate("user@example.com"))
print_validation_result("valid: User.Name+tag@GmAiL.com", email_validator.validate("User.Name+tag@GmAiL.com"))
print_validation_result("invalid: 'user..name@example.com'", email_validator.validate("user..name@example.com"))
print_validation_result("invalid: 'user@example'", email_validator.validate("user@example"))

#email normalization
print "\nEmail Normalizer:\n"

email_normalizer = ContactsUtils::Email::Normalizer.new
begin
  show_value("normalize: 'User.Name+Tag@GMAIL.com'", email_normalizer.normalize("User.Name+Tag@GMAIL.com"))
rescue => e
  show_value("normalize raised", e.message)
end

#phone validation
print "\nPhone Validator:\n"

phone_validator = ContactsUtils::Phone::Validator.new
print_validation_result("valid: +380 (50) 123-45-67", phone_validator.validate("+380 (50) 123-45-67"))
print_validation_result("valid with ext: +1 (650) 555-1234 x9", phone_validator.validate("+1 (650) 555-1234 x9"))
print_validation_result("invalid: +12+34", phone_validator.validate("+12+34"))
print_validation_result("invalid ext: +1 650 555 1234 x12a", phone_validator.validate("+1 650 555 1234 x12a"))

#phone normalization
print "\nPhone normalizer:\n"

phone_normalizer = ContactsUtils::Phone::Normalizer.new
begin
  show_value("normalize: '+1 (650) 555-1234 x 9'", phone_normalizer.normalize("+1 (650) 555-1234 x 9"))
  show_value("normalize: '0044 20 1234 5678'", phone_normalizer.normalize("0044 20 1234 5678"))
rescue => e
  show_value("normalize raised", e.message)
end

begin
  show_value("normalize: '+12+34'", phone_normalizer.normalize("+12+34"))
rescue => e
  show_value("normalize raised", e.message)
end