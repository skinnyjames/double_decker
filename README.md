# double_decker

[![Build Status](http://drone.skinnyjames.net/api/badges/skinnyjames/double_decker/status.svg?ref=refs/heads/main)](http://drone.skinnyjames.net/skinnyjames/double_decker) [![codecov](https://codecov.io/gh/skinnyjames/double_decker/branch/main/graph/badge.svg)](https://codecov.io/gh/skinnyjames/double_decker)

library for parallel aggregation in Ruby

## installation

in your Gemfile

`gem "double_decker"`

## usage

```ruby
require "double_decker"

# instatiate the bus with a run id shared across parallel processes
bus = DoubleDecker::Bus.new(UNIQUE_SHARED_RUN_ID, url: 'redis://127.0.0.1')

# call an on finished hook with the final payload when all processes complete
bus.on_finished do |payload|
  ...
end

# register in agent in each process
agent = bus.register

# merge data into the agent
agent.merge({ hello: :world })

# finish each agent at the end of the process
at_exit do
  agent.finish!
end
```
## running tests
`docker-compose build && docker-compose run lib rspec`



