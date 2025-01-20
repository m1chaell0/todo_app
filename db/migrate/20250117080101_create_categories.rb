class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
