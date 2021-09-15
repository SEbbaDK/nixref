require "kemal"

get "/" do
    "online"
end

puts "Started"
Kemal.run 8080
