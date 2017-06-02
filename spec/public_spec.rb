require "spec_helper"
require_relative "../app"

describe "The public app" do
  def app
    Public
  end

  before do
    @user = User.create!(email: "fake@example.com", password: "right")
    ENV["JWT_SECRET"] = "secret"
  end

  it "returns a bad response when credentials are not correct" do
    post "/login", {email: "fake@example.com", password: "wrong"}

    expect(last_response.status).to eq 401
  end

  it "returns a successful response" do
    post "/login", {email: "fake@example.com", password: "right"}

    expect(last_response).to be_ok
    response_body = JSON.parse(last_response.body, symbolize_names: true)
    expect(response_body.keys).to match_array([:email, :id, :token, :token_expiry_date])
    expect(response_body[:id]).to eq @user.id
  end
end
