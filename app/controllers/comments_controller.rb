class CommentsController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

    def create
        @comment = current_user.comments.build(comment_params)
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
    end

    def update
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @comment.destroy
        head :no_content
    end

    private

    def set_comment
        @comment = Comment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Comment not found' }, status: :not_found
    end


    def authorize_user!
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @comment.user == current_user
    end

    def comment_params
        params.require(:comment).permit(:body, :post_id)
    end
end
