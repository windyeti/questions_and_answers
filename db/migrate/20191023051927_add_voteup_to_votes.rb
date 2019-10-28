class AddVoteupToVotes < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :value, :integer
  end
end
