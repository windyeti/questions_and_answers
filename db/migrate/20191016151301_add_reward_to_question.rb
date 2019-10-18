class AddRewardToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :reward, foreign_keys: true
  end
end
