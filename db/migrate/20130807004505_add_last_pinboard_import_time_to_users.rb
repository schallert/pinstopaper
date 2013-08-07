class AddLastPinboardImportTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_pinboard_import, :datetime
  end
end
