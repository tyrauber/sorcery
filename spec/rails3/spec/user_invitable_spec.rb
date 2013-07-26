require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../app/mailers/sorcery_mailer')
require File.expand_path(File.dirname(__FILE__) + '/../../shared_examples/user_invitable_shared_examples')

describe "User with invitable submodule" do
  before(:all) do
    ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate/invitable")
  end
  
  after(:all) do
    ActiveRecord::Migrator.rollback("#{Rails.root}/db/migrate/invitable")
  end

  it_behaves_like "rails_3_invitable_model"
  
end