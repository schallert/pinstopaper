class PinboardPost < ActiveRecord::Base
  serialize :tag, Array

  belongs_to :user
end
