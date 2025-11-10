RSpec.describe ContactsUtils::Email::Validator do
  subject(:validator) { described_class.new }

  def success?(email)
    validator.validate(email).success
  end

  def errors_for(email)
    validator.validate(email).errors
  end

  context "happy path" do
    it "accepts a simple address" do
      expect(success?("user@example.com")).to be true
    end

    it "accepts plus-tag and dots in local" do
      expect(success?("User.Name+promo@example.museum")).to be true
    end

    it "accepts digits in TLD (per current policy)" do
      expect(success?("user@example.c0m")).to be true
    end
  end

  context "basic sanity checks" do
    it "rejects empty string" do
      res = validator.validate("")
      expect(res.success?).to be false
      expect(res.errors).to include("Email is empty.")
    end

    it "rejects spaces" do
      res = validator.validate("user name@example.com")
      expect(res.success?).to be false
      expect(res.errors).to include("Email contains spaces.")
    end

    it "rejects non-ascii" do
      res = validator.validate("юзер@example.com")
      expect(res.success?).to be false
      expect(res.errors).to include("Email contains non-ASCII characters.")
    end
  end

  context "at-sign rules" do
    it "rejects missing @" do
      res = validator.validate("user.example.com")
      expect(res.success?).to be false
      expect(res.errors).to include("Email must contain exactly one '@' symbol.")
    end

    it "rejects multiple @" do
      res = validator.validate("a@@b@c.com")
      expect(res.success?).to be false
      expect(res.errors).to include("Email must contain exactly one '@' symbol.")
    end
  end

  context "local part" do
    it "rejects empty local" do
      res = validator.validate("@example.com")
      expect(res.success?).to be false
      expect(res.errors).to include("Local part is empty.")
    end

    it "rejects invalid characters in local" do
      res = validator.validate("user,comma@example.com")
      expect(res.success?).to be false
      expect(res.errors).to include("Local part contains invalid characters.")
    end

    it "rejects edge symbols at start/end (._-)" do
      res1 = validator.validate(".user@example.com")
      res2 = validator.validate("user-@example.com")
      expect(res1.success?).to be false
      expect(res2.success?).to be false
      expect(res1.errors).to include(a_string_including("Local part cannot start or end"))
      expect(res2.errors).to include(a_string_including("Local part cannot start or end"))
    end

    it "rejects consecutive identical edge symbols (.., __, --)" do
      ["user..name@example.com", "user__name@example.com", "user--name@example.com"].each do |addr|
        res = validator.validate(addr)
        expect(res.success?).to be false
        expect(res.errors).to include(a_string_including("symbols consecutively"))
      end
    end
  end

  context "domain" do
    it "rejects empty domain" do
      res = validator.validate("user@")
      expect(res.success?).to be false
      expect(res.errors).to include("Domain part is empty.")
    end

    it "requires at least one dot (TLD present)" do
      res = validator.validate("user@example")
      expect(res.success?).to be false
      expect(res.errors).to include("Domain must contain a TLD.")
    end

    it "rejects invalid domain label characters" do
      res = validator.validate("user@exa_mple.com")
      expect(res.success?).to be false
      expect(res.errors).to include("Domain label contains invalid characters.")
    end

    it "rejects hyphen at label edges or consecutive hyphens" do
      ["user@-example.com", "user@example-.com", "user@ex--ample.com"].each do |addr|
        res = validator.validate(addr)
        expect(res.success?).to be false
        expect(res.errors).to include(a_string_including("hyphen"))
      end
    end

    it "rejects empty label (double dot)" do
      res = validator.validate("user@example..com")
      expect(res.success?).to be false
      expect(res.errors).to include("Domain name is empty.")
    end

    it "rejects short TLD (< 2)" do
      res = validator.validate("user@example.c")
      expect(res.success?).to be false
      expect(res.errors).to include("Domain TLD contains less than #{described_class::TLD_MIN_LENGTH} characters.")
    end

    it "rejects too long TLD (> 63)" do
      long_tld = "a" * (described_class::LABEL_MAX_LENGTH + 1)
      res = validator.validate("user@example.#{long_tld}")
      expect(res.success?).to be false
      expect(res.errors).to include("Domain TLD contains more than #{described_class::LABEL_MAX_LENGTH} characters.")
    end
  end

  context "length caps" do
    it "rejects domain longer than MAX_DOMAIN_LENGTH" do
      label = "a" * 63
      long_domain = ([label] * 5).join(".")
      res = validator.validate("user@#{long_domain}")
      expect(res.success?).to be false
      expect(res.errors).to include(a_string_including("Domain contains more than"))
    end

    it "rejects email longer than MAX_EMAIL_LENGTH" do
      local = "a" * ContactsUtils::Email::Validator::MAX_EMAIL_LENGTH
      res = validator.validate("#{local}@e.com")
      expect(res.success?).to be false
      expect(res.errors).to include(a_string_including("Email is too long"))
    end
  end
end