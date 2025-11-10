RSpec.describe ContactsUtils::Email::Normalizer do
  subject(:n) { described_class.new }

  it "downcases only the domain" do
    expect(n.normalize("User.Name@GMAiL.cOm")).to eq("User.Name@gmail.com")
  end

  it "strips spaces" do
    expect(n.normalize("  u@d.com  ")).to eq("u@d.com")
  end
end