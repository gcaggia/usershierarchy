require "json"

# Map a role from a json file of different roles 
class Role
  include JSON::Serializable
  @[JSON::Field(key: "Id")]
  property id : Int32
  @[JSON::Field(key: "Name")]
  property name : String
  @[JSON::Field(key: "Parent")]
  property parent : Int32
end

# Map a user from a json file of different users 
class User
  include JSON::Serializable
  @[JSON::Field(key: "Id")]
  property id : Int32
  @[JSON::Field(key: "Name")]
  property name : String
  @[JSON::Field(key: "Role")]
  property role : Int32
end

# An organisation is a set of Users and Roles, both defined as list
class Organisation
  private property users : Array(User)  # list of users
  private property roles : Array(Role)  # list of roles

  # Constructor
  #  - input: users json filepath and roles json filepath 
  #  - goal: parse json files to transform them in a list of objects (user|role)
  def initialize(usersFilePath : String, rolesFilePath : String)
    @users = Array(User).from_json(File.read(usersFilePath))
    @roles = Array(Role).from_json(File.read(rolesFilePath))
  end

  # Get the Role ID of a user
  def getUserRoleId(userId : Int32) : Int32
    users = @users.reject { |user| user.id != userId }
    users.first.role
  end

  # Get all subordinates roles from a specific role
  # Returns an array of integer where each integer is a role id
  def getSubordinatesRoleId(roleId : Int32) : Array(Int32)
    subordinates = Array(Int32).new
    # we loop trough each roles of the organisation
    @roles.each do |role|
      # If a role has role id as parent
      if role.parent == roleId
        # It means we keep it because he is a child in the hierarchy tree
        subordinates << role.id
        # Recursively, this role could become potentially a parent
        subordinates += getSubordinatesRoleId(role.id)  
      end
    end
    subordinates
  end

  # Get all subordinates users from a specific user
  def getSubordinates(userId : Int32) : Array(User)
    # From the user we get its role. From the role we get all the subordinates roles
    subordinatesRoles = getSubordinatesRoleId(getUserRoleId(userId))
    # From all the users in the organisation we filter them. 
    # Does it match with the array of the subordinates roles we get previously ?
    @users.select { |user| subordinatesRoles.includes?(user.role) }
  end
end
