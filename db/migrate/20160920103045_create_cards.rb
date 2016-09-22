class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :card_number, unique: true, default: "", null: false

      t.timestamps null: false
    end
  end
end
