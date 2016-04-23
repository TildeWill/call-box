class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string :name
      t.string :code

      t.timestamps null: false
    end
  end
end
