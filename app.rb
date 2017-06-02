require "json"
require "jwt"
require "sinatra"
# require "pry"
require_relative "app/models/user"
require_relative "middleware/jwt_auth"
require "./environment"

class AdminApi < Sinatra::Base

  use JwtAuth

  get "/console" do
    scopes = request.env.values_at(:scopes).flatten
    if scopes.include?("console")
      content_type :json
      { message: "You have logged in to the console" }.to_json
    else
      halt 403
    end
  end
end

class Public < Sinatra::Base

  post "/login" do
    login_response = false
    user = User.find_by("lower(email) = ?", params[:email].downcase)
    if user && user.authenticate(params[:password])
      login_response = {
        token: secure_token(user.id),
        token_expiry_date: token_expiry_date,
        email: user.email,
        id: user.id,
      }
    end

    if login_response
      content_type :json
      login_response.to_json
    else
      halt 401
    end
  end


  private

  def token_expiry_date
    Time.now.to_i + 60 * 60
  end

  def secure_token(user_id)
    payload = { user_id: user_id, exp: token_expiry_date, scopes: ["console"] }
    JWT.encode(payload, ENV["JWT_SECRET"])
  end

end




