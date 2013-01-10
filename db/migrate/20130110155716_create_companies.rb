class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.text :name, null: false
      t.text :slug

      t.timestamps
    end
    add_index :companies, :slug, unique: true
  end
end
