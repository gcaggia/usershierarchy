require "kemal"
require "./solution"

get "/api/home/" do |env|
  env.response.content_type = "application/json"
  {"Hello From Server"}.to_json
end

get "/api/get-subordinates/:user_id" do |env|
  users = Array(User).from_json(File.read("data/users.json"))
  roles = Array(Role).from_json(File.read("data/roles.json"))
  organisation = Organisation.new users, roles
  
  env.response.content_type = "application/json"
  userId = env.params.url["user_id"].to_i
  organisation.getSubordinates(userId).to_json
end

Kemal.run 8080