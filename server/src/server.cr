require "kemal"
require "./resource.cr"
require "./example_resource.cr"

get "/" do
    if ARGV[0]?.nil?
        "online"
    else
        File.read(ARGV[0])
    end
end

resources = {} of String => Resource

def addResource(list : Hash(String, Resource), r : Resource)
  list[r.name()] = r
  list
end

resources = addResource(resources, ExampleResource.new())


get "/:resource_name/:url" do |env|
    resource_name = env.params.url["resource_name"].not_nil!
    url = env.params.url["url"].not_nil!
    resource = resources[resource_name]
    resource.getResource(url)
end

get "/search/:query" do |env|
    query = env.params.url["query"].not_nil!
    results = [] of SearchResult
    resources.each { |x| results += x[1].search(query) }
    {results: results}.to_json
end

puts "Started"
Kemal.run 8080
