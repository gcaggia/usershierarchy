require "kemal"
require "./solution"

get "/" do
  users = Array(User).from_json(File.read("data/users.json"))
  roles = Array(Role).from_json(File.read("data/roles.json"))
  organisation = Organisation.new users, roles
  
  organisation.getSubordinates(3).to_json
end

Kemal.run 8080