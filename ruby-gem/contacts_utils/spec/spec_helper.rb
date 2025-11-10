# it allows to load required files
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "contacts_utils"

RSpec.configure do |config|
  config.order = :random
end