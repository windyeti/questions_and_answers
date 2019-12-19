class CreateJoinTableSubscribersSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :questions do |t|
      t.index :user_id
      t.index :question_id
    end
  end
end
