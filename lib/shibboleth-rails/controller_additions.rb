module Shibboleth::Rails

  module ControllerAdditions
    private

    def authenticated?
      request.env['employeeNumber'].present?
    end

    def shibboleth
      {:emplid       => request.env['employeeNumber'],
       :name_n       => request.env['REMOTE_USER'].chomp("@osu.edu"),
       :affiliations => request.env['affiliation']}
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = if session[:simulate_id].present?
                        User.find(session[:simulate_id])
                      elsif authenticated?
                        User.find_or_create_from_shibboleth(shibboleth)
                      end
    end

    def require_shibboleth
      if current_user
        current_user.update_usage_stats(request, :login => session['new'])
        session.delete('new')
      else
        session['new'] = true
        if Rails.env.production? or Rails.env.staging?
          redirect_to [request.protocol, request.host,
            '/Shibboleth.sso/Login?target=', CGI.escape(requested_url)].join
        else
          session['target'] = requested_url
          redirect_to new_user_session_url, :notice => 'Login first, please.'
        end
      end
    end

    def requested_url
      if request.respond_to?(:url)
        request.url
      else
        request.protocol + request.host + request.request_uri
      end
    end
  end

end

ActionController::Base.class_eval do
  include Shibboleth::Rails::ControllerAdditions
  helper_method :current_user
end
