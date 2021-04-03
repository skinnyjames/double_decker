require "redis" 
require "date"
require "json"
require_relative "./agent"
require_relative "./bus_data"

module DoubleDecker
  class Bus
    attr_reader :run_id, :start_time, :finished

    def initialize(run_id, url: "redis://redis", redis: Redis.new(url: url), start_time: DateTime.now)
      @store = redis
      @run_id = run_id
      @start_time = start_time
      setup!
    end

    def register(&merge_proc)
      Agent.new(self, BusData.new(run_id, @store), merge_proc: merge_proc)
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