lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hatena_fotolife/version"

Gem::Specification.new do |spec|
  spec.name          = "hatena_fotolife"
  spec.version       = HatenaFotolife::VERSION
  spec.authors       = ["riho.takagi"]
  spec.email         = ["rihohearts@gmail.com"]

  spec.summary       = %q{A ruby gem for Uploading image to Hatena Fotolife}
  spec.description   = %q{A ruby gem for Uploading image to Hatena Fotolife}
  spec.homepage      = "https://github.com/rlho/hatena_fotolife"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "oauth", "~> 1.1"
  spec.add_dependency "hatenablog"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "yard"
end
