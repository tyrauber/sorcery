class SorceryInvitable < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_token,     :string, :limit => 60
    add_column :users, :invitation_sent_at,    :datetime, :default => nil
    add_column :users, :invitation_accepted_at,  :datetime, :default => nil
    add_column :users, :invitation_limit,  :integer, :default => nil
    add_column :users, :invited_by_type,  :string
    add_column :users, :invited_by_id,  :integer
  end

  def self.down
    remove_column :users, :invitation_token
    remove_column :users, :invitation_sent_at
    remove_column :users, :invitation_accepted_at
    remove_column :users, :invitation_limit
    remove_column :users, :invited_by_type
    remove_column :users, :invited_by_id
  end
end
