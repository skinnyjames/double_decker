module DoubleDecker
  describe Agent do 
    before(:each) do 
      @bus = DoubleDecker::Bus.new SecureRandom.uuid, expected_agents: 2
      @bus.on_finished do |d|
        @actual = d
      end
    end

    it "should wait for all agents" do 
      Thread.new do 
        sleep 2
        @agent_1 = @bus.register
      end
      @agent_2 = @bus.register
      @agent_1.finish!
      @agent_2.finish!

      expect(@actual).to eql({'1' => {}, '2' => {}})
    end
  end
end
