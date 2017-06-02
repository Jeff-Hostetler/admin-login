require "spec_helper"
require_relative "../app"
require_relative "../middleware/jwt_auth"

describe "The public app" do
  def app
    AdminApi
  end

  before do
    @user = User.create!(email: "fake@example.com", password: "right")
    ENV["JWT_SECRET"] = "secret"
  end

  it "returns a bad response user not logged in" do
    header("Authorization", "Bearer badtoken")
    get "/console"

    expect(last_response).to_not be_ok
    expect(last_response.status).to eq 401
  end

  it "returns a successful response when token is accepted" do
    payload = { user_id: @user.id, exp: Time.now.to_i + 60 * 60, scopes: ["console"] }
    token = JWT.encode(payload, ENV["JWT_SECRET"])

    get "/console", {}, {"HTTP_AUTHORIZATION" => "Bearer #{token}"}

    expect(last_response).to be_ok
  end
end
