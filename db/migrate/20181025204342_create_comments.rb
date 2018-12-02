class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
        t.string :caption
        t.text :comment
        t.integer :refmodel_id
        t.string  :refmodel_type
        t.references :user, foreign_key: true
        t.timestamps
    end

      add_index :comments, [:refmodel_type, :refmodel_id]
  end
end
