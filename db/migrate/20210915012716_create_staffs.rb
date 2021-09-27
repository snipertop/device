class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|
      t.string :number
      t.string :name
      t.string :department
      t.string :position

      t.timestamps
    end
  end
end
