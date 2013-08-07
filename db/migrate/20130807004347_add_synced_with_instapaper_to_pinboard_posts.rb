class AddSyncedWithInstapaperToPinboardPosts < ActiveRecord::Migration
  def change
    add_column :pinboard_posts, :synced_with_instapaper, :boolean
  end
end
