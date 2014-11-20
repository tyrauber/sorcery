module Sorcery
  module Providers

    # This class adds support for OAuth with the Doorkeeper Gem
    # https://github.com/doorkeeper-gem/doorkeeper

    # config.doorkeeper.site = 'http://localhost:3000/'
    #config.doorkeeper.provider = 'provider_name'
    # config.doorkeeper.key = <key>
    # config.doorkeeper.secret = <secret>
    # config.doorkeeper.callback_url = "<host>/oauth/callback"
    # config.doorkeeper.scope = "read"

    class Doorkeeper < Base

      include Protocols::Oauth2

      attr_accessor :auth_path, :scope, :token_url, :user_info_path, :provider

      def initialize
        super
        @scope          = nil
        @provider       = 'doorkeeper'
        @site           = 'http://localhost:3000'
        @user_info_path = '/api/v1/account.json'
        @auth_path      = '/oauth/authorize'
        @token_url      = '/oauth/token'
        @state          = SecureRandom.hex(16)
      end

      def get_user_hash(access_token)
        response = access_token.get(user_info_path)
        body = JSON.parse(response.body)
        auth_hash(access_token).tap do |h|
          h[:user_info] = body
          h[:uid] = body['id'].to_s
          h[:email] = body['email'].to_s
        end
      end

      def login_url(params, session)
        authorize_url({ authorize_url: auth_path })
      end

      def process_callback(params, session)
        raise "Invalid state. Potential Cross Site Forgery" if params[:state].present? && params[:state] != state
        args = { }.tap do |a|
          a[:code] = params[:code] if params[:code]
        end
        get_access_token(args, token_url: token_url, token_method: :post)
      end
    end
  end
end