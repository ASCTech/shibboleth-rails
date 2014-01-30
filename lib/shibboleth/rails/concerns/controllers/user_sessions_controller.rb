module Shibboleth
  module Rails
    module Concerns
      module Controllers
        module UserSessionsController
          extend ActiveSupport::Concern

          included do

            layout 'login'

            # skip CanCan authorization
            skip_authorization_check if respond_to?(:skip_authorization_check)

            skip_before_action :require_login
            before_action :not_in_production

            def new
              @users = ::User.all
            end

            def create
              session[:simulate_id] = params[:user_id]
              session['new'] = true
              target = session.delete :target
              redirect_to target || main_app.root_url
            end

            def destroy
              session[:simulate_id] = nil
              redirect_to shibboleth_rails.new_user_session_url, :notice => "Logout successful!"
            end

            private

            def not_in_production
              redirect_to main_app.root_url if ::Rails.env.in? Shibboleth::Rails::LIVE_ENVS
            end

          end
        end
      end
    end
  end
end
