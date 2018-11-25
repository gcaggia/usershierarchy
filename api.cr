require "kemal"
require "./solution"

# Healthcheck of the API
get "/api/home/" do |env|
  env.response.content_type = "application/json"
  "Hello From Server".to_json
end

# Main route for the API
get "/api/get-subordinates/:user_id" do |env|
  env.response.content_type = "application/json"
  # Get data folder path
  pathData = Kemal.config.env == "test" ? "spec" : "data"
  # Organisation is a list of users and roles
  organisation = Organisation.new usersFilePath: "#{pathData}/users.json", 
                                  rolesFilePath: "#{pathData}/roles.json"
  # Get user id from url parameter
  userId = env.params.url["user_id"].to_i
  # Call method getSubordinates and return answer as json
  organisation.getSubordinates(userId).to_json
end

Kemal.run ARGV[0]?.try &.to_i? || 8080