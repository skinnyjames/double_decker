module DoubleDecker
  class Agent
    attr_reader :id, :end_time

    def initialize(bus, bus_data, merge_proc: nil)
      @bus = bus
      @bus_data = bus_data
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