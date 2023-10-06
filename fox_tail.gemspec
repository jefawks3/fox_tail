require_relative "lib/fox_tail/version"

Gem::Specification.new do |spec|
  spec.name = "foxtail"
  spec.version = FoxTail::VERSION
  spec.authors = ["James Fawks"]
  spec.email = ["jefawks3@gmail.com"]

  spec.summary = "Unofficial Rails View Components built for Flowbite and Tailwind CSS"
  spec.description = "UI View Component library built on top of Tailwind CSS and based on the Flowbite Design System."
  spec.homepage = "https://github.com/jefawks3/fox_tail"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jefawks3/fox_tail"
  spec.metadata["changelog_uri"] = "https://github.com/jefawks3/fox_tail/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["LICENSE.txt", "README.md", "CHANGELOG.md", "app/**/*", "lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 4.1.0"
  spec.add_dependency "tailwind_merge", "~> 0.7"
  spec.add_runtime_dependency "view_component", "~> 3.0"
end
