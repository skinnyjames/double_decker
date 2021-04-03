module DoubleDecker
  describe Agent do 
    before(:each) do 
      @bus = DoubleDecker::Bus.new SecureRandom.uuid
      @bus.on_finished do |payload|
        @bus_payload = payload
      end
      @agent = @bus.register
      @agent.on_finished do |payload|
        @agent_payload = payload
      end
    end
    
    it "should report it's payload on finish" do 
      @agent.merge({ one: :two })
      @agent.finish!
      expect(@bus_payload).to eql({ "1" => {'one' => 'two'} })
      expect(@agent_payload).to eql({'one' => 'two'})
    end

    it "should report multiple agents payloads" do 
      @agent_2 = @bus.register
      @agent_2.merge({three: :four})
      @agent.finish!
      @agent_2.finish!
      expect(@bus_payload).to eql({ "1" => {}, "2" => { "three" => "four" }})
    end

    it "order of agents finishing doesn't matter" do
      @agent_2 = @bus.register
      @agent_2.finish!
      @agent.finish!
      expect(@bus_payload).to eql({ "1" => {}, "2" => {}})
    end
  end
end