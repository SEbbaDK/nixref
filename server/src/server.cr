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

get "/search/:query" do |env|
    query = env.params.url["query"].not_nil!
    results = [] of SearchResult
    resources.each { |x| results += x.search(query) }
    {results: results}.to_json
end

puts "Started"
Kemal.run 8080
