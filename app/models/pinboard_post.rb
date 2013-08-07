class PinboardPost < ActiveRecord::Base
  serialize :tag, Array

  belongs_to :user

  scope :unread, -> { where(:toread => true) }

  # Last defense in preventing importing a post multiple times
  validates :href, :uniqueness => { :scope => :user_id }

  def formatted_description
    if self.description.blank?
      "(Empty)"
    else
      self.description
    end
  end
end
