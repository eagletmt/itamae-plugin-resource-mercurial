# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "itamae-plugin-resource-mercurial"
  spec.version       = '0.0.1'
  spec.authors       = ["Kohei Suzuki"]
  spec.email         = ["eagletmt@gmail.com"]
  spec.summary       = %q{itamae resource plugin to clone mercurial repository.}
  spec.description   = %q{itamae resource plugin to clone mercurial repository.}
  spec.homepage      = "https://github.com/eagletmt/itamae-plugin-resource-mercurial"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_dependency "itamae"
end
