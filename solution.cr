require "json"

class Role
  include JSON::Serializable
  @[JSON::Field(key: "Id")]
  property id : Int32
  @[JSON::Field(key: "Name")]
  property name : String
  @[JSON::Field(key: "Parent")]
  property parent : Int32
end

class User
  include JSON::Serializable
  @[JSON::Field(key: "Id")]
  property id : Int32
  @[JSON::Field(key: "Name")]
  property name : String
  @[JSON::Field(key: "Role")]
  property role : Int32
end

class Organisation
  private property users : Array(User)
  private property roles : Array(Role)

  def initialize(users :  Array(User), roles : Array(Role))
    @users = users
    @roles = roles
  end

  def getUserRoleId(userId : Int32) : Int32
    users = @users.reject { |user| user.id != userId }
    users.first.role
  end

  def getSubordinatesRoleId(roleId : Int32) : Array(Int32)
    subordinates = Array(Int32).new
    @roles.each do |role|
      if role.parent == roleId
        subordinates << role.id
        subordinates += getSubordinatesRoleId(role.id)
      end
    end
    subordinates
  end

  def getSubordinates(userId : Int32) : Array(User)
    subordinatesRoles = getSubordinatesRoleId(getUserRoleId(userId))
    @users.select { |user| subordinatesRoles.includes?(user.role) }
  end
end

users = Array(User).from_json(File.read("data/users.json"))
roles = Array(Role).from_json(File.read("data/roles.json"))
organisation = Organisation.new users, roles

puts organisation.getSubordinates(3).to_json