require "kemal"
require "./resource.cr"
require "./example_resource.cr"

get "/" do
    "online"
end

class Request
  include JSON::Serializable

  property text : String
end

resources = [ExampleResource.new()]

post "/search" do |env|
    request = Request.from_json env.request.body.not_nil!
    results = [] of SearchResult
    resources.each { |x| results += x.search(request.text) }
    {results: results}.to_json
end

puts "Started"
Kemal.run 8080
