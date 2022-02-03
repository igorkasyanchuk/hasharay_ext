# frozen_string_literal: true

require_relative "lib/hasharay_ext/version"

Gem::Specification.new do |spec|
  spec.name = "hasharay_ext"
  spec.version = HasharayExt::VERSION
  spec.authors = ["Igor Kasyanchuk"]
  spec.email = ["igorkasyanchuk@gmail.com"]

  spec.summary = "Useful method to fetch data from complex hashes and arrays"
  spec.description = "Useful method to fetch data from complex hashes and arrays"
  spec.homepage = "https://github.com/igorkasyanchuk/hasharay_ext"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_development_dependency "pry"
end
