class SorceryInvitable < ActiveRecord::Migration
  def self.up
    add_column :<%= model_class_name.tableize %>, :invitation_token,     :string, :limit => 60
    add_column :<%= model_class_name.tableize %>, :invitation_sent_at,    :datetime, :default => nil
    add_column :<%= model_class_name.tableize %>, :invitation_accepted_at,  :datetime, :default => nil
    add_column :<%= model_class_name.tableize %>, :invitation_limit,  :integer, :default => nil
    add_column :<%= model_class_name.tableize %>, :invited_by_type,  :string
    add_column :<%= model_class_name.tableize %>, :invited_by_id,  :integer
  end

  def self.down
    remove_column :<%= model_class_name.tableize %>, :invitation_token
    remove_column :<%= model_class_name.tableize %>, :invitation_sent_at
    remove_column :<%= model_class_name.tableize %>, :invitation_accepted_at
    remove_column :<%= model_class_name.tableize %>, :invitation_limit
    remove_column :<%= model_class_name.tableize %>, :invited_by
  end
end
