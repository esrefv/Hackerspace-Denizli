class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :user, index: true, foreign_key: true
      t.references :card, index: true, foreign_key: true
      t.datetime :online_at
      t.datetime :offline_at
      t.boolean :status
      t.integer :value

      t.timestamps null: false
    end
  end
end
