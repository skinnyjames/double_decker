Gem::Specification.new do |s|
  s.name        = 'double_decker'
  s.version     = '0.1.3'
  s.licenses    = ['MIT']
  s.summary     = "synchronize results from parallel"
  s.description = "Redis bus for aggregating data from parallel processing in Ruby"
  s.authors     = ["Sean Gregory"]
  s.email       = 'sean.christopher.gregory@gmail.com'
  s.files       = Dir['src/**/*.rb']
  s.require_paths = ['src']
  s.homepage    = 'https://rubygems.org/gems/double_decker'
  s.metadata    = { "source_code_uri" => "https://github.com/skinnyjames/double_decker" }
  s.add_runtime_dependency 'redis'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'knapsack'
  s.add_development_dependency 'simplecov'
end