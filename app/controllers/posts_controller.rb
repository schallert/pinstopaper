class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_owns_post!, :only => [:show, :sync]

  def index
    @posts = current_user.pinboard_posts.unread
  end

  def show
    # `@post` already set in before filter
  end

  # Sync a post to Instapaper
  def sync
    # `@post` already set in before filter
  end

  private
  def check_user_owns_post!
    @post = PinboardPost.find(params[:id])
    if @post.user_id == current_user.id
      # Do nothing, permissions good
    else
      render :nothing => true, :status => :unauthorized
    end
  end
end
