module DoubleDecker
  class Agent
    attr_reader :id, :end_time

    def initialize(bus, bus_data, expected_agents, merge_proc: nil)
      @bus = bus
      @bus_data = bus_data
      @expected_agents = expected_agents
      @finished = nil
      @merge_proc = merge_proc
      @id = setup!
      merge({})
    end

    def merge_like(&block)
      @merge_proc = block
    end

    def merge(hash)
      @bus_data.merge(id, hash, &@merge_proc)
    end

    def to_h
      @bus_data.to_h[id.to_s]
    end

    def on_finished(&block)
      @finished = block
    end

    def wait_for_expected_agents(timeout=60)
      if @expected_agents
        max_tries = timeout
        loop do 
          break if (@bus_data.active_agents == @expected_agents.to_i) || (max_tries == 5)
          sleep 1
          max_tries += 1
        end
      end
    end

    def finish!(end_time = DateTime.now)
      @end_time = end_time
      @finished&.call(to_h)
      if last
        @bus.finished&.call(@bus_data.to_h)
        @bus_data.teardown_bus
      end
    end

    private
    
    def last
      teardown!.zero?
    end

    def teardown!
      @bus_data.teardown_agent
    end

    def setup!
      @bus_data.setup_agent
    end
  end
end