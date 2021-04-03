describe "Output" do 
  it "should have 2 agents" do 
    data = JSON.parse File.read("#{__dir__}/../report.json")
    expect(data.keys.length).to eql(2)
  end
end