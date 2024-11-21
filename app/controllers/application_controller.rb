class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

    def current_user
      if decoded_token
        user_id = decoded_token[0]["user_id"]
        @user = User.find_by(id: user_id)
      end
    end

    def authorize_user!
      unless !!current_user
        render json: { message: "Please log in" }, status: :unauthorized
      end
    end

    def encode_token(payload)
      JWT.encode(payload, ENV.fetch("JWT_SECRET"))
    end

    def decoded_token
      header = request.headers["Authorization"]
      if header
        token = header.split(" ")[1]
        begin
          JWT.decode(token, ENV.fetch("JWT_SECRET"))
        rescue JWT::DecodeError
          nil
        end
      end
    end

  private

    def record_not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end
end
