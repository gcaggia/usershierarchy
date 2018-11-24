require "./solution"

users = Array(User).from_json(File.read("data/users.json"))
roles = Array(Role).from_json(File.read("data/roles.json"))
organisation = Organisation.new users, roles

puts organisation.getSubordinates(3).to_json