shared_examples_for "rails_3_invitable_model" do
  # ----------------- PLUGIN CONFIGURATION -----------------------
  describe User, "loaded plugin configuration" do
    before(:all) do
      sorcery_reload!([:invitation], :invitation_mailer => ::SorceryMailer)
    end
  
    after(:each) do
      User.sorcery_config.reset!
      sorcery_reload!([:invitation], :invitation_mailer => ::SorceryMailer)
    end

    # it "should enable configuration option 'invitation_token_attribute_name'" do
    #   sorcery_model_property_set(:invitation_state_attribute_name, :status)
    #   User.sorcery_config.invitation_state_attribute_name.should equal(:status)    
    # end
    
    it "should enable configuration option 'invitation_token_attribute_name'" do
      sorcery_model_property_set(:invitation_token_attribute_name, :code)
      User.sorcery_config.invitation_token_attribute_name.should equal(:code)    
    end
     #  
     #   it "should enable configuration option 'invitation_mailer'" do
     #     sorcery_model_property_set(:invitation_mailer, TestMailer)
     #     User.sorcery_config.invitation_mailer.should equal(TestMailer)    
     #   end
     #   
     #   it "should enable configuration option 'invitation_needed_email_method_name'" do
     #     sorcery_model_property_set(:invitation_needed_email_method_name, :my_invitation_email)
     #     User.sorcery_config.invitation_needed_email_method_name.should equal(:my_invitation_email)
     #   end
     #   
     #   it "should enable configuration option 'invitation_success_email_method_name'" do
     #     sorcery_model_property_set(:invitation_success_email_method_name, :my_invitation_email)
     #     User.sorcery_config.invitation_success_email_method_name.should equal(:my_invitation_email)
     #   end
     # 
     #   it "should enable configuration option 'invitation_mailer_disabled'" do
     #     sorcery_model_property_set(:invitation_mailer_disabled, :my_invitation_mailer_disabled)
     #     User.sorcery_config.invitation_mailer_disabled.should equal(:my_invitation_mailer_disabled)
     #   end
     #   
     #   it "if mailer is nil and mailer is enabled, throw exception!" do
     #     expect{sorcery_reload!([:user_invitation], :invitation_mailer_disabled => false)}.to raise_error(ArgumentError)
     #   end
     # 
     #   it "if mailer is disabled and mailer is nil, do NOT throw exception" do
     #     expect{sorcery_reload!([:user_invitation], :invitation_mailer_disabled => true)}.to_not raise_error
     #   end
     # end
     # 
     # # ----------------- ACTIVATION PROCESS -----------------------
     # describe User, "invitation process" do
     #   before(:all) do
     #     sorcery_reload!([:user_invitation], :invitation_mailer => ::SorceryMailer)
     #   end
     #   
     #   before(:each) do
     #     create_new_user
     #   end
     #   
     #   it "should initialize user state to 'pending'" do
     #     @user.invitation_state.should == "pending"
     #   end
     #   
     #   specify { @user.should respond_to(:activate!) }
     #   
     #   it "should clear invitation code and change state to 'active' on invitation" do
     #     invitation_token = @user.invitation_token
     #     @user.activate!
     #     @user2 = User.find(@user.id) # go to db to make sure it was saved and not just in memory
     #     @user2.invitation_token.should be_nil
     #     @user2.invitation_state.should == "active"
     #     User.find_by_invitation_token(invitation_token).should be_nil
     #   end
     # 
     # 
     #   context "mailer is enabled" do
     #     it "should send the user an invitation email" do
     #       old_size = ActionMailer::Base.deliveries.size
     #       create_new_user
     #       ActionMailer::Base.deliveries.size.should == old_size + 1
     #     end
     # 
     #     it "subsequent saves do not send invitation email" do
     #       old_size = ActionMailer::Base.deliveries.size
     #       @user.username = "Shauli"
     #       @user.save!
     #       ActionMailer::Base.deliveries.size.should == old_size
     #     end
     # 
     #     it "should send the user an invitation success email on successful invitation" do
     #       old_size = ActionMailer::Base.deliveries.size
     #       @user.activate!
     #       ActionMailer::Base.deliveries.size.should == old_size + 1
     #     end
     # 
     #     it "subsequent saves do not send invitation success email" do
     #       @user.activate!
     #       old_size = ActionMailer::Base.deliveries.size
     #       @user.username = "Shauli"
     #       @user.save!
     #       ActionMailer::Base.deliveries.size.should == old_size
     #     end
     # 
     #     it "invitation needed email is optional" do
     #       sorcery_model_property_set(:invitation_needed_email_method_name, nil)
     #       old_size = ActionMailer::Base.deliveries.size
     #       create_new_user
     #       ActionMailer::Base.deliveries.size.should == old_size
     #     end
     # 
     #     it "invitation success email is optional" do
     #       sorcery_model_property_set(:invitation_success_email_method_name, nil)
     #       old_size = ActionMailer::Base.deliveries.size
     #       @user.activate!
     #       ActionMailer::Base.deliveries.size.should == old_size
     #     end
     #   end
     # 
     #   context "mailer has been disabled" do
     #     before(:each) do
     #       sorcery_reload!([:user_invitation], :invitation_mailer_disabled => true, :invitation_mailer => ::SorceryMailer)
     #     end
     # 
     #     it "should not send the user an invitation email" do
     #       old_size = ActionMailer::Base.deliveries.size
     #       create_new_user
     #       ActionMailer::Base.deliveries.size.should == old_size
     #     end
     # 
     #     it "should not send the user an invitation success email on successful invitation" do
     #       old_size = ActionMailer::Base.deliveries.size
     #       @user.activate!
     #       ActionMailer::Base.deliveries.size.should == old_size
     #     end
     #   end
     # end
     # 
     # describe User, "prevent non-active login feature" do
     #   before(:all) do
     #     sorcery_reload!([:user_invitation], :invitation_mailer => ::SorceryMailer)
     #   end
     # 
     #   before(:each) do
     #     User.delete_all
     #     create_new_user
     #   end
     # 
     #   it "should not allow a non-active user to authenticate" do
     #     User.authenticate(@user.username,'secret').should be_false
     #   end
     #   
     #   it "should allow a non-active user to authenticate if configured so" do
     #     sorcery_model_property_set(:prevent_non_active_users_to_login, false)
     #     User.authenticate(@user.username,'secret').should be_true
     #   end
     # end
     # 
     # describe User, "load_from_invitation_token" do
     #   before(:all) do
     #     sorcery_reload!([:user_invitation], :invitation_mailer => ::SorceryMailer)
     #   end
     #   
     #   after(:each) do
     #     Timecop.return
     #   end
     #   
     #   it "load_from_invitation_token should return user when token is found" do
     #     create_new_user
     #     User.load_from_invitation_token(@user.invitation_token).should == @user
     #   end
     #   
     #   it "load_from_invitation_token should NOT return user when token is NOT found" do
     #     create_new_user
     #     User.load_from_invitation_token("a").should == nil
     #   end
     #   
     #   it "load_from_invitation_token should return user when token is found and not expired" do
     #     sorcery_model_property_set(:invitation_token_expiration_period, 500)
     #     create_new_user
     #     User.load_from_invitation_token(@user.invitation_token).should == @user
     #   end
     #   
     #   it "load_from_invitation_token should NOT return user when token is found and expired" do
     #     sorcery_model_property_set(:invitation_token_expiration_period, 0.1)
     #     create_new_user
     #     Timecop.travel(Time.now.in_time_zone+0.5)
     #     User.load_from_invitation_token(@user.invitation_token).should == nil
     #   end
     #   
     #   it "load_from_invitation_token should return nil if token is blank" do
     #     User.load_from_invitation_token(nil).should == nil
     #     User.load_from_invitation_token("").should == nil
     #   end
     #   
     #   it "load_from_invitation_token should always be valid if expiration period is nil" do
     #     sorcery_model_property_set(:invitation_token_expiration_period, nil)
     #     create_new_user
     #     User.load_from_invitation_token(@user.invitation_token).should == @user
     #   end
  end
end