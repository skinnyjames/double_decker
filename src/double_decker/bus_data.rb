require "json"

module DoubleDecker
  class BusData
    attr_reader :run_id, :store

    def initialize(run_id, store)
      @run_id = run_id
      @store = store
    end

    def to_h
     data = store.get(run_id) 
     data && JSON.parse(data)
    end

    def setup_agent
      store.incr("#{run_id}_agents").to_i
    end

    def teardown_bus
      store.del(run_id)
      store.del("#{run_id}_agents")
    end

    def teardown_agent
      store.decr("#{run_id}_agents").to_i
    end

    def active_agents
      store.get("#{run_id}_agents").to_i
    end

    def merge(agent_id, hash, &block)
      block.call(hash) if block
      data = to_h || {}
      data[agent_id.to_s] ||= {}
      data[agent_id.to_s].merge!(hash)
      store.set(run_id, data.to_json)
    end
  end
end