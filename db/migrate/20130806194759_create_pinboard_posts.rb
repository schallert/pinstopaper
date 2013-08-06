class CreatePinboardPosts < ActiveRecord::Migration
  def change
    create_table :pinboard_posts do |t|
      t.string :href
      t.string :description
      t.text :extended
      t.string :tag
      t.datetime :time
      t.boolean :replace
      t.boolean :shared
      t.boolean :toread

      t.integer :user_id

      t.timestamps
    end
  end
end
