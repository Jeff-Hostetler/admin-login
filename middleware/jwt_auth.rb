require "jwt"

class JwtAuth
  #Rack middleware setup
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      bearer = env.fetch("HTTP_AUTHORIZATION", "").slice(7..-1)
      payload, header = JWT.decode(bearer, ENV["JWT_SECRET"], true)

      env[:scopes] = payload["scopes"]

      @app.call env
    rescue JWT::DecodeError
      [401, { "Content-Type" => "text/plain" }, ["A token must be passed."]]
    rescue JWT::ExpiredSignature
      [403, { "Content-Type" => "text/plain" }, ["The token has expired."]]
    end
  end
end
