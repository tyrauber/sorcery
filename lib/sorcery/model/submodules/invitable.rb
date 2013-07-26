module Sorcery
  module Model
    module Submodules
      # This submodule enables user invitations. It generates an
      # invitation_token, sets invitation_sent_at and invitation_accepted_at,
      # optionally limits the amounts of invites and logs invited_by.
      # This is the model part of the submodule, which provides configuration options.
      module Invitable
        def self.included(base)
          base.extend(ClassMethods)

          base.sorcery_config.class_eval do
            attr_accessor :invitation_token_attribute_name,               # invitation token attribute name.
                          :invitation_sent_at_attribute_name,             # invitation sent at attribute name.
                          :invitation_accepted_at_attribute_name,         # invitation accepted at attribute name.
                          :invitation_limit_attribute_name,               # invitation limit attribute name
                          :invitation_limit_default,                      # invitation limit default
                          :invited_by_attribute_name,                     # invited_by_attribute_name
                          :invitation_mailer,                             # your mailer class
                          :invitation_mailer_disabled,                    # default fault
                          :invitationemail_method_name                    # invitation method name
          end
          
          base.sorcery_config.instance_eval do
            @defaults.merge!(:@invitation_token_attribute_name            => :invitation_token,
                            :@invitation_sent_at_attribute_name           => :invitation_sent_at,
                            :@invitation_accepted_at_attribute_name       => :invitation_accepted_at,
                            :@invited_by_attribute_name                   => :invited_by,
                            :@invitation_limit_attribute_name             => :invitation_limit,
                            :@invitation_limit_default                    => nil,
                            :@invitation_mailer                           => nil,
                            :@invitation_mailer_disabled                  => false,
                            :@invitation_email_method_name                => :invitation_email)
            reset!
          end
          
          base.class_eval do
            
            # scope providing list of other users who have been invited by user
            has_many sent_invitations, :through => User, :as => @invited_by_attribute_name
            
            # don't setup invitation if invited_by is not present
            before_create :setup_invitation, :if => Proc.new { |user| user.send(sorcery_config.invited_by_attribute_name).present? }
            # don't send invitation email if invited_by is not present
            after_create  :send_invitation_email!, :if => Proc.new { |user| user.send(sorcery_config.invited_by_attribute_name).present? }
          end
          
          base.sorcery_config.after_config << :define_invitable_mongoid_fields if defined?(Mongoid) and base.ancestors.include?(Mongoid::Document)
          
          base.extend(ClassMethods)
          base.send(:include, InstanceMethods)

        end
        
        module ClassMethods

          protected

          def define_invitable_mongoid_fields
            field sorcery_config.invitation_token_attribute_name,         :type => String
            field sorcery_config.invitation_lmit_attribute_name,          :type => String
            field sorcery_config.invitation_sent_at_attribute_name,       :type => Time
            field sorcery_config.invitation_accepted_at_attribute_name,   :type => Time
            #field sorcery_config.invited_by_attribute_name,         :type => Reference  # Polymorphic association?
          end
        end
      end
      module InstanceMethods
         
        # Verifies whether a user has been invited or not
        def invited?
          self.send(:"#{config.invitation_token_attribute_name}").present?
        end

        # Verifies whether a user accepted an invitation (or is accepting it)
        def invitation_accepted?
          self.send(:"#{config.invitation_accepted_at_attribute_name}").present?
        end

        # Verifies whether a user has accepted an invitation (or is accepting it), or was never invited
        def accepted_or_not_invited?
          invitation_accepted? || !invited?
        end
        
        def may_invite?
          !!((sorcery_config.invitation_limit_default.nil? ) ||  # No limit
          (sent_invitations.size < sorcery_config.invitation_limit_default)   # sent invitations less than global limit
          (sent_invitations.size < (self.send(:"#{config.invitation_limit_attribute_name}")))  #sent invitations less than user limit
        end
         
        # clears invitation_code, sets invitation_accepted_at and optionaly sends a success email.
        def accept!
          config = sorcery_config
          self.send(:"#{config.invitation_token_attribute_name}=", nil)
          self.send(:"#{config.invitation_accepted_at_attribute_name}=", Time.now.in_time_zone)
          send_invitation_success_email! unless self.external?
          save!(:validate => false) # don't run validations
        end

        def invite(email)
          if may_invite?
            User.create({:email => email, :invited_by => self})
          end
        end
          
        protected

        def setup_invitation
          config = sorcery_config
          generated_invitation_token = TemporaryToken.generate_random_token
          self.send(:"#{config.invitation_token_attribute_name}=", generated_invitation_token)
          self.send(:"#{config.invitation_sent_at_attribute_name}=", Time.now.in_time_zone)
        end

        # called automatically after user initial creation.
        def send_invitation_email!
          generic_send_email(:invitation_email_method_name, :user_activation_mailer) unless sorcery_config.activation_needed_email_method_name.nil? or sorcery_config.activation_mailer_disabled == true
        end
      end
    end
  end
end