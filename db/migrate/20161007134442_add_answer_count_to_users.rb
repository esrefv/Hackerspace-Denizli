class AddAnswerCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :answers_count, :integer, :default => 0
  end
end
