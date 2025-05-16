class ApplicationController < ActionController::API

    attr_reader :current_user

    SECRET_KEY = ENV['SECRET_KEY_BASE']

    def encode_token(payload)
        JWT.encode(payload, SECRET_KEY)
    end

    def decode_token
        auth_header = request.headers['Authorization']
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end
    
    def authorize_request
        decoded_token = decode_token
        if decoded_token
          user_id = decoded_token[0]['user_id']
          @current_user = User.find_by(id: user_id)
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end

    def current_user
        @current_user
    end

    def authorize_user!
        unless @post.user_id == current_user.id
          render json: { error: "You are not authorized to perform this action." }, status: :forbidden
        end
    end

end
