module Shibboleth
  module Rails
    module Concerns
      module Controllers
        module ApplicationController
          extend ActiveSupport::Concern

          included do

          private

            ##
            #
            #
            def authenticated?
              request.env['employeeNumber'].present?
            end

            ##
            #
            #
            def shibboleth
              {
                emplid: request.env['employeeNumber'],
                name_n: request.env['REMOTE_USER'].chomp("@osu.edu"),
                affiliations: request.env['affiliation'],
                first_name: request.env['FIRST-NAME'] || request.env['givenName'],
                last_name: request.env['LAST-NAME'] || request.env['sn'],
              }
            end

            ##
            #
            #
            def current_user
              @current_user ||= begin
                if session[:simulate_id].present?
                  ::User.find(session[:simulate_id])
                elsif authenticated?
                  ::User.find_or_create_from_shibboleth(shibboleth)
                elsif request.xhr?
                  ::User.where(id: session[:user_id]).first
                end
              end
            end
            helper_method :current_user

            ##
            #
            #
            def current_user?
              !!current_user
            end
            helper_method :current_user?

            ##
            #
            #
            def require_login
              if current_user
                if current_user.respond_to?(:update_usage_stats)
                  current_user.update_usage_stats(request, :login => session['new'])
                end
                session.delete('new')
                session[:user_id] = current_user.id
              else
                session['new'] = true
                session.delete(:simulate_id)
                if request.xhr?
                  render :json => {:login_url => login_url}, :status => 401
                else
                  redirect_to login_url
                end
              end
            end

            def requested_url
              if request.respond_to? :url
                request.url
              else
                request.protocol + request.host + request.request_uri
              end
            end

            def login_url
              if ::Rails.env.in? Shibboleth::Rails::LIVE_ENVS
                [request.protocol, request.host, '/Shibboleth.sso/Login?target=', CGI.escape(requested_url)].join
              else
                session['target'] = requested_url
                shibboleth_rails.new_user_session_url
              end
            end
          end

        end
      end
    end
  end
end
