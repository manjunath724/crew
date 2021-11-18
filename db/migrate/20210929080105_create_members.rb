class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :name, null: false, default: ""
      t.string :title, null: false, default: ""
      t.text :bio
      t.boolean :active, null: false, default: true
      t.integer :votes_count, null: false, default: 0
      t.string :image_url, null: false, default: ""

      t.timestamps
    end
  end
end
