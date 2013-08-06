class PinboardPost < ActiveRecord::Base
  serialize :tag, Array

  belongs_to :user

  scope :unread, -> { where(:toread => true) }

  def formatted_description
    if self.description.blank?
      "(Empty)"
    else
      self.description
    end
  end
end
