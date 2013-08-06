class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.pinboard_posts.unread
  end

end
