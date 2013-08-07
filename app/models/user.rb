class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pinboard_posts

  def all_pinboard_items
    client.posts
  end

  def pinboard_items_since (after_time)
    client.posts(:fromdt => after_time)
  end

  def import_pinboard_items (posts)
    update_attribute(:last_pinboard_import, DateTime.now)
    posts.each do |pin_res|
      PinboardPost.create_from_pin_res(pin_res, self)
    end
  end

  def import_recent_items
    recent_items = pinboard_items_since(last_pinboard_import)
    import_pinboard_items(recent_items)
  end

  def import_all_pinboard_items
    import_pinboard_items(all_pinboard_items)
  end

  private
  def client
    @pinboard ||= Pinboard::Client.new(:token => self.pinboard_token)
    @pinboard
  end
end
