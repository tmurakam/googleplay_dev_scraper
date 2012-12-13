# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'android-checkout-scraper/version'

Gem::Specification.new do |gem|
  gem.name          = "android-checkout-scraper"
  gem.version       = AndroidCheckoutScraper::VERSION
  gem.authors       = ["Takuya Murakami"]
  gem.email         = ["tmurakam@tmurakam.org"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
