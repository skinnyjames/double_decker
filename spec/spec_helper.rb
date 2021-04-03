require "rspec"
require "securerandom"
require_relative "../src/double_decker"
require 'knapsack'

Knapsack::Adapters::RSpecAdapter.bind

bus = DoubleDecker::Bus.new 'test-run', expected_agents: ENV['KNAPSACK_PRO_CI_NODE_TOTAL']

bus.on_finished do |payload|
  File.open("result.json", "w") do |f|
    f << payload.to_json
  end
  puts "#{payload.inspect}"
end

agent = bus.register
agent.merge({ uuid: SecureRandom.uuid })

at_exit do 
  agent.finish!
end