require "kemal"
require "./solution"

get "/api/home/" do |env|
  env.response.content_type = "application/json"
  "Hello From Server".to_json
end

get "/api/get-subordinates/:user_id" do |env|
  organisation = Organisation.new usersFilePath: "data/users.json", rolesFilePath: "data/roles.json"
  env.response.content_type = "application/json"
  userId = env.params.url["user_id"].to_i
  organisation.getSubordinates(userId).to_json
end

Kemal.run 8080