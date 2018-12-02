class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
        t.string :tag
        t.integer :refmodel_id
        t.string  :refmodel_type
        t.timestamps
    end

      add_index :tags, [:refmodel_type, :refmodel_id]
  end
end
