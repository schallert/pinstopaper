class StaticPagesController < ApplicationController
  def home
    if current_user
      redirect_to unread_posts_path
    end
  end
end
