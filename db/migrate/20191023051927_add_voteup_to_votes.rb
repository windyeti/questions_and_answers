class AddVoteupToVotes < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :voteup, :boolean, default: false
  end
end
