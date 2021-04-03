require "redis" 
require "date"
require "json"
require_relative "./agent"
require_relative "./bus_data"

module DoubleDecker
  class Bus
    attr_reader :run_id, :expected_agents, :finished

    def initialize(run_id, url: "redis://redis", expected_agents: nil, redis: Redis.new(url: url))
      @store = redis
      @run_id = run_id
      @expected_agents = expected_agents
      setup!
    end

    def register(&merge_proc)
      Agent.new(self, BusData.new(run_id, @store), expected_agents, merge_proc: merge_proc)
    end

    def on_finished(&block)
      @finished = block
    end

    protected

    def setup!
      @store.get(run_id) || @store.set(run_id, {}.to_json)
    end
  end
end