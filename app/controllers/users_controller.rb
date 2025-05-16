class UsersController < ApplicationController
    before_action :authorize_request, only: [:index, :update, :destroy]

    def index
        users = User.all
        render json: users
    end

    # POST /signup
    def create
        @user = User.new(user_params)
        if @user.save
          render json: { user: @user }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # def show
    #     render json: @current_user
    # end
    
    def update
        requested_user_id = params[:id].to_i

        # If the requested user ID does not match current user's ID, deny access
        if requested_user_id != @current_user.id
          return render json: { error: "Unauthorized to update another user's information" }, status: :forbidden
        end

        if @current_user.update(user_params)
          render json: @current_user
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        requested_user_id = params[:id].to_i

        # If the requested user ID does not match current user's ID, deny access
        if requested_user_id != @current_user.id
          return render json: { error: "Unauthorized to delete another user's information" }, status: :forbidden
        end

        @current_user.destroy
        head :no_content
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    
      
    def authorize_user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end
end
