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

  it "responds to /api/get-subordinates" do
    get "/api/get-subordinates/1"
    response.status_code.should eq 200
  end

end