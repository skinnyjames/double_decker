require 'simplecov'
SimpleCov.start
require 'codecov'

class SimpleCov::Formatter::Codecov
  def format(result, disable_net_blockers = true)
    report = Codecov::SimpleCov::Formatter.new.format(result)
  end
end


SimpleCov.formatter = SimpleCov::Formatter::Codecov
SimpleCov.command_name("rspec_ci_node_#{ENV["CI_NODE_INDEX"]}")

require "rspec"
require "securerandom"
require_relative "../src/double_decker"

bus = DoubleDecker::Bus.new 'test-run', expected_agents: ENV['CI_NODE_TOTAL']

bus.on_finished do |payload|
  File.open("result.json", "w") do |f|
    f << payload.to_json
  end
end

agent = bus.register
agent.merge({ uuid: SecureRandom.uuid })

at_exit do 
  agent.finish!
end