class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.references :event_category, foreign_key: true
      t.references :event_type, foreign_key: true
      t.string :title
      t.text :content
      t.string :status
      t.integer :comment_count
      t.integer :view_count
      t.datetime :start_date
      t.datetime :end_date
      t.string :event_time

      t.timestamps
    end
  end
end
