class PostsController < ApplicationController
    before_action :authorize_request, only: [ :create, :update, :destroy ]
    before_action :set_post, only: [ :show, :update, :destroy ]
    before_action :authorize_user!, only: [ :update, :destroy ]

    def index
      @posts = Post.all
      render json: @posts  # Uses PostSerializer if configured
    end

    def show
      render json: @post
    end

    def create
      @post = current_user.posts.build(post_params.except(:tags))

      if params[:post][:tags].present?
        params[:post][:tags].each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name.strip)
          @post.tags << tag unless @post.tags.include?(tag)
        end
      end

      if @post.save
        render json: @post, status: :created
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      head :no_content
    end

    private

    def set_post
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Post not found" }, status: :not_found
    end

    def post_params
      params.require(:post).permit(:title, :body, tag_ids: [])
    end
end
