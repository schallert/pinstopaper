class AddPinboardTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :pinboard_token, :string
  end
end
