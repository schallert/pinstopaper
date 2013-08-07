class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_owns_post!, :only => [:show, :sync]

  def index
    @posts = current_user.pinboard_posts
    @title = 'All Pins'
  end

  def unread
    @posts = current_user.pinboard_posts.unread
    @unread = true
    @title = 'Unread Pins'
    render 'index'
  end

  def import
    old_count = current_user.pinboard_posts.count

    if current_user.last_pinboard_import
      current_user.import_recent_items
    else
      current_user.import_all_pinboard_items
    end

    new_count = current_user.pinboard_posts.count
    difference = new_count - old_count

    flash[:notice] = "Imported #{difference} pinboard items"

    redirect_to unread_posts_path
  end

  def show
    # `@post` already set in before filter
    @title = @post.description
  end

  # Sync a post to Instapaper
  def sync
    # `@post` already set in before filter
    @post.sync
    redirect_to unread_posts_path
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
