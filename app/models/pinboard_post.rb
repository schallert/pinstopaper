class PinboardPost < ActiveRecord::Base
  serialize :tag, Array

  belongs_to :user

  scope :unread,         -> { where(:toread => true) }
  scope :unread_ordered, -> { unread.order('time ASC') }

  # Last defense in preventing importing a post multiple times
  validates :href, :uniqueness => { :scope => :user_id }

  def formatted_description
    if self.description.blank?
      "(Empty)"
    else
      self.description
    end
  end

  def sync (username, password)
    # Add post to instapaper
    client = Instapaper::InstapaperClient.new(username, password)
    if client.authenticated?
      unless synced_with_instapaper?
        client.add(self.href, self.description)
        self.mark_as_synced
      end
      true
    else
      false
    end
  end

  def mark_as_synced
    update_attribute(:synced_with_instapaper, true)
  end

  def view_style
    if synced_with_instapaper? then 'color: green' else '' end
  end

  def self.create_from_pin_res (pin_res, user)
    PinboardPost.create(
      :href        => pin_res.href,
      :description => pin_res.description,
      :extended    => pin_res.extended,
      :time        => pin_res.time,
      :replace     => pin_res.replace == "yes",
      :shared      => pin_res.shared == "yes",
      :toread      => pin_res.toread == "yes",
      :tag         => pin_res.tag,
      :user        => user)
  end

  def self.sync_all (username, password)
    PinboardPost.unread_ordered.each do |post|
      post.sync(username, password)
    end
  end
end
