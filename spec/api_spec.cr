require "json"
require "spec-kemal"
require "../api"

describe "api" do

  it "responds to /api/home/" do
    get "/api/home"
    JSON.parse(response.body).should eq "Hello From Server"
  end

  it "responds to /api/get-subordinates" do
    get "/api/get-subordinates/1"
    response.status_code.should eq 200
  end

  it "should output 2 employees for Sam Supervisor user #3" do
    get "/api/get-subordinates/3"
    users = Array(User).from_json(response.body)
    users.size.should eq 2
  end

  it "should output 'Emily Employee' and 'Steve Trainer' for Sam Supervisor user #3" do
    get "/api/get-subordinates/3"
    users = Array(User).from_json(response.body)
    [users[0].name, users[1].name].sort.should eq ["Emily Employee", "Steve Trainer"]
  end

  it "should output 4 employees for Adam Admin user #1" do
    get "/api/get-subordinates/1"
    users = Array(User).from_json(response.body)
    users.size.should eq 4
  end

  it "should output [objUser2, objUser3, objUser4, objUser5] for Adam Admin user #1" do
    get "/api/get-subordinates/1"
    users = Array(User).from_json(response.body)
    [users[0].id, users[1].id, users[2].id, users[3].id].sort.should eq [2, 3, 4, 5]
  end

  it "should output nothing for Emily Employee user #2" do
    get "/api/get-subordinates/2"
    users = Array(User).from_json(response.body)
    users.size.should eq 0
  end

end