class CreateComputers < ActiveRecord::Migration[6.1]
  def change
    create_table :computers do |t|
      t.string :code
      t.string :brand
      t.string :version
      t.string :place
      t.string :state
      t.string :date
      t.string :configure
      t.text :remarks
      t.references :staff, null: false, foreign_key: true

      t.timestamps
    end
  end
end
