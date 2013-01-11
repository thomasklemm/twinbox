class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end
