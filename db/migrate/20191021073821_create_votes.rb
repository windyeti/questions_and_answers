class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :voteable, polymorphic: true
      t.belongs_to :user, foreign_keys: true
    end
  end
end
