module Sorcery
  module Controller
    module Submodules
      module External
        module Providers
          # This module adds support for OAuth with tradeking.com.
          # When included in the 'config.providers' option, it adds a new option, 'config.tradeking'.
          # Via this new option you can configure Tradeking specific settings like your app's key and secret.
          #
          #   config.tradeking.key = <key>
          #   config.tradeking.secret = <secret>
          #   ...
          #
          module Tradeking
            def self.included(base)
              base.module_eval do
                class << self
                  attr_reader :tradeking

                  def merge_tradeking_defaults!
                    @defaults.merge!(:@tradeking => TradekingClient)
                  end
                end
                merge_tradeking_defaults!
                update!
              end
            end

            module TradekingClient
              class << self
                attr_accessor :key,
                              :secret,
                              :callback_url,
                              :site,
                              :authorize_path,
                              :request_token_path,
                              :access_token_path,
                              :user_info_path,
                              :user_info_mapping
                attr_reader   :access_token

                include Protocols::Oauth1

                # Override included get_consumer method to provide authorize_path
                def get_consumer
                  ::OAuth::Consumer.new(@key, @secret, @configuration)
                end

                def init
                  @configuration = {
                      site: "https://developers.tradeking.com",
                      authorize_path: '/authorize',
                      request_token_path: '/request_token',
                      access_token_path: '/access_token'
                  }
                  @user_info_path = "/users/me"
                end

                def get_user_hash
                  user_hash = {}
                  response = @access_token.get(@user_info_path)
                  user_hash[:user_info] = JSON.parse(response.body)['users'].first
                  user_hash[:uid] = user_hash[:user_info]['id'].to_s
                  user_hash
                end

                def has_callback?
                  true
                end

                # calculates and returns the url to which the user should be redirected,
                # to get authenticated at the external provider's site.
                def login_url(params,session)
                  req_token = self.get_request_token
                  session[:request_token]         = req_token.token
                  session[:request_token_secret]  = req_token.secret
                  self.authorize_url({:request_token => req_token.token, :request_token_secret => req_token.secret})
                end

                # tries to login the user from access token
                def process_callback(params,session)
                  args = {}
                  args.merge!({:oauth_verifier => params[:oauth_verifier], :request_token => session[:request_token], :request_token_secret => session[:request_token_secret]})
                  args.merge!({:code => params[:code]}) if params[:code]
                  @access_token = self.get_access_token(args)
                end

              end
              init
            end
          end
        end
      end
    end
  end
end
