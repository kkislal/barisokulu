class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.references :blog_category, foreign_key: true
      t.string :title
      t.text :content
      t.string :status
      t.integer :comment_count
      t.integer :view_count

      t.timestamps
    end
  end
end
