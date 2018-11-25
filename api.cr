require "kemal"
require "./solution"

get "/api/home/" do |env|
  env.response.content_type = "application/json"
  "Hello From Server".to_json
end

get "/api/get-subordinates/:user_id" do |env|
  pathData = Kemal.config.env == "test" ? "spec" : "data"

  organisation = Organisation.new usersFilePath: "#{pathData}/users.json", 
                                  rolesFilePath: "#{pathData}/roles.json"
                                  
  env.response.content_type = "application/json"
  userId = env.params.url["user_id"].to_i
  organisation.getSubordinates(userId).to_json
end

Kemal.run ARGV[0]?.try &.to_i? || 8080