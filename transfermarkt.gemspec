
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "transfermarkt/version"

Gem::Specification.new do |spec|
  spec.name          = "transfermarkt"
  spec.version       = Transfermarkt::VERSION
  spec.authors       = ["'Umberto Palazzo'"]
  spec.email         = ["'upalazzo93@gmail.com'"]

  spec.summary       = %q{see players on transfermarkt}
  spec.license       = "MIT"


  if spec.respond_to?(:metadata)

  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  
  spec.add_dependency "nokogiri"
  spec.add_dependency "tty"
  spec.add_dependency "pastel"
end
