class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pinboard_posts

  def posts_from_pinboard
    @pinboard ||= Pinboard::Client.new(:token => self.pinboard_token)
    @pinboard_posts ||= @pinboard.posts
    @pinboard_posts
  end

  def import_pinboard_posts
    posts_from_pinboard.each do |post_res|
      post = PinboardPost.create(
        :href        => post_res.href,
        :description => post_res.description,
        :extended    => post_res.extended,
        :time        => post_res.time,
        :replace     => post_res.replace == "yes",
        :shared      => post_res.shared == "yes",
        :toread      => post_res.toread == "yes",
        :tag         => post_res.tag,
        :user        => self
      )
    end
  end
end
